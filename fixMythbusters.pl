#!/usr/bin/perl 

use strict;
use warnings;
use TVDB::API;
use DBI;
use DBD::SQLite;
use Data::Dumper;
use File::Basename;
use File::Copy;
#Debug::Simple::debuglevels({verbose=>4, debug=>4, test=>4, quiet=>0});

my $tvdb = TVDB::API::new('4412E34B1A552F29') or die("no tvdb $!");
my $series = "MythBusters";

my $realEpMap;
foreach my $season (1..$tvdb->getMaxSeason($series))
{
    foreach my $epNum (1..$tvdb->getMaxEpisode($series, $season))
    {
        my $info = $tvdb->getEpisode($series, $season, $epNum);
        next unless $info->{'EpisodeName'};

        $realEpMap->{$info->{'EpisodeName'}} = {
            'epNum' => $info->{'EpisodeNumber'},
            'season' => $info->{'SeasonNumber'},
        };
    }
}
my $dbh = DBI->connect(
        "dbi:SQLite:dbname=/home/halkeye/.xbmc/userdata/Database/MyVideos34.db",
        "","",
        {
            RaiseError => 1,
        }
);

my $sth = $dbh->prepare("
    select
        path.strPath, file.strFilename, ep.c12 as season, ep.c13 as epNum, ep.c00 as epName 
    from 
        tvshow tv 
    left join
        tvshowlinkpath tvp on (tv.idShow=tvp.idShow) 
    left join 
        tvshowlinkepisode tve on (tv.idShow=tve.idShow) 
    left join
        path on (tvp.idPath=path.idPath) 
    left join
        episode ep on (tve.idEpisode=ep.idEpisode) 
    left join
        files file on (ep.idFile=file.idFile) 
    where
        tv.c00 = 'MythBusters' 
");
$sth->execute();
my $showMap;
while (my $row = $sth->fetchrow_hashref())
{
    die "Unable to find $row->{epName}" unless $realEpMap->{$row->{epName}};
    my $info = $realEpMap->{$row->{epName}};
    # path.strPath, file.strFilename, ep.c12 as season, ep.c13 as epNum, ep.c00 as epName 
 
    my $oldFilename = join('', $row->{strPath}, $row->{strFilename});
    my ($name,$path,$suffix) = fileparse($oldFilename,qr/\.[^.]*/);

    my $newFileName = sprintf("%s - S%02dE%02d - %s%s", 
            $series, $info->{season}, $info->{epNum}, $row->{epName}, $suffix
    );
    warn("$oldFilename => $newFileName\n");
}
$sth->finish();
$dbh->disconnect();

#print Dumper($showMap);
