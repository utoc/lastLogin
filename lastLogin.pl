#!/usr/local/bin/perl

# You will need perl modules JSON and DateTime; Use the
# power of Google to install them
#
# THIS SCRIPT USES LAST WRITE TIME SO IF YOU FREQUENTLY OVERWRITE
# YOUR PLAYER DATA FILES, THIS WILL ALWAYS GIVE ERRONIOUS DATA OUT
#
# You'll need to set $filename and $pdata to their proper locations
#
# Licensing here: https://github.com/utoc/Dont-be-a-Jerk
# This is open source.  Give credit where it is due if you decide to modify
# this script as I have done
#
# If you're unsure of yourself, see the following: https://www.youtube.com/watch?v=eh7lp9umG2I
#
#

use lib qw(..);

use JSON qw();
use DateTime;

my $filename = '/home/minecraft/serverdir/whitelist.json';
my $pdata = '/home/minecraft/serverdir/world/playerdata/';
my $psuffix = '.dat';

my $json_text = do {
   open(my $json_fh, "<:encoding(UTF-8)", $filename)
      or die("Can't open \$filename\": $!\n");
   local $/;
   <$json_fh>
};

my $json = JSON->new;
my $data = $json->decode($json_text);
my $now = DateTime->now();
my $lastwk = $now->clone->subtract( weeks => 1);

for my $entry( @{$data} ){
    my $pfile = $pdata . $entry->{uuid} . $psuffix;
#   print "DEBUG: $pfile\n";
    if (-e $pfile) {
        my $last = (stat ($pfile))[9];
        my $dt = DateTime->from_epoch( epoch => $last );
        $dt->ymd;
        print $dt->ymd . " since seen $entry->{name} ($entry->{uuid})\n";
    } else {
        print "NEVER seen $entry->{name} ($entry->{uuid})\n";
    };
};
