#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';
use TVDB::API;
use Data::Dumper;
use File::Copy ();
use File::Basename ();
use Getopt::Long;
use File::Spec ();

my $dryRun = 0;
GetOptions ("dryRun" => \$dryRun) or die('not handling');

#Debug::Simple::debuglevels({verbose=>4, debug=>4, test=>4, quiet=>0});

my $filepath = shift || '/media/storage/downloads/Ace_of_Cakes,Dog_Day_Afternoon.mkv';
die("Usage: $0  [filepath]\n") unless ($filepath);
$filepath = File::Spec->rel2abs($filepath);
die("unable to find file: $filepath") unless -e $filepath;

my ($filename, $path, $ext) = File::Basename::fileparse($filepath, qr/\.[^.]*/);
$filename =~ s/_/ /g;
my ($showName,$title) = split(',', $filename, 2);
die("No Showname") unless $showName;
die("No Title") unless $title;

$showName =~ s/Canadas Worst Handyman/Canada's Worst Handyman/g;
print "Looking up $showName - $title\n";

my $tvdb = TVDB::API::new('4412E34B1A552F29') or die("no tvdb $!");
my $series = $tvdb->getSeries($showName) or die("no seriesId: $!");

$filename = undef;
foreach my $season (@{$series->{Seasons}})
{
    foreach my $episode (@$season)
    {
        next unless $episode;
        my $info = $tvdb->getEpisodeId($episode);
        next unless $info->{EpisodeName} =~ m/\Q$title\E/i;
        $filename = sprintf("%s - S%02dE%02d - %s%s", 
                $showName, $info->{SeasonNumber},
                $info->{EpisodeNumber}, $info->{EpisodeName}, $ext);
        last if $filename;
    }
    last if $filename;
}
if ($filename)
{
    say (($dryRun ? "Dry run r" : "r") . "enaming '$filepath' to '$path$filename'");
    if (!$dryRun)
    {
        File::Copy::move("$filepath", "$path$filename") 
            or die("unable to move file ($filename): $!");
    }
}
else
{
    die("Unable to find ep info for $filepath\n");
}
