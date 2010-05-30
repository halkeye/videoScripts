#!/usr/bin/perl 
use strict;
use warnings;

use Data::Dumper;
use File::Copy;

my $dirName = "/mnt/Drobo02/Anime/Bleach";
opendir(my $dir, $dirName);
while (my $file = readdir($dir))
{
    next unless -f $file;
    next if $file =~ /^\./;
    # Bleach - S11E02 - [Ep 245].avi at /home/halkeye/backToEpNum.pl line 30.
    my ($title, $epNum,$ext) = $file =~ /^(.*?)\s+-\s+S\d+E\d+\s+-\s+\[Ep (\d+)\]\.(\w+)$/;
    if (!$epNum)
    {
        warn("$file has no epnum");
        next;
    }
    my $newFilename = "/mnt/Drobo02/Unsorted Anime/Bleach/$title - $epNum.$ext";
    File::Copy::move("$dirName/$file", "/mnt/Drobo02/Unsorted Anime/Bleach/$title - $epNum.$ext")
        or die("unable to rename $dirName/$file to $newFilename");
}


