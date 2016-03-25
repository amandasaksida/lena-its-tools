#!/usr/local/bin/perl
#
# Anne S. Warlaumont
#
# This tool allows you to find the start time, end time, and type of vocalization for each vocalization in a LENA recording, using the corresponding .its file.
# The output information is written into .csv file.
#
# Takes the following command line arguments:
# The path and file name of the input its file (e.g. "~/lena-its-tools/segments.pl)
# The path and csv file name where you want the segment data to be written (e.g. "~/lena-its-results/e20131126_155022_009145_segments.csv"
#
# Instructions:
# 1. Open up a unix shell (e.g. the Terminal application under Utilities on Mac or Cygwin on Windows)
# 2. Navigate to the directory where this file is located (e.g. "~/CodeDirectory/")
# 3. Run segments.pl with the path and file name of the its file as the first argument and the path and name of the desired segments csv output file as the 2nd argument
# (e.g. "perl segments.pl ~/DataDirectory/e20120417_130404_007941.its ~/DataDirectory/e20120417_130404_007941_segments.csv")

use strict; use warnings;

open INPUTFILE, $ARGV[0] or die "Could not open input file " . $ARGV[0] . "\r\n";
open OUTPUTFILE, ">", $ARGV[1] or die "Could not open output file " . $ARGV[1] . "\r\n";

print OUTPUTFILE "segtype,startsec,endsec\r\n";

while (my $line = <INPUTFILE>){
	
	chomp($line);
	
	if ($line=~ m/Segment spkr=/){
		
		my $segtype = $line;
		$segtype =~ s/.*Segment spkr="//g;
		$segtype =~ s/".*//g;
		if ($segtype =~ m/CHN/){
			if ($line =~ m/startUtt1/){
				$segtype = $segtype . "SP";
			}
			else{
				$segtype = $segtype . "NSP";
			}
		}
		
		my $startTime = $line;
		$startTime =~ s/.*startTime="PT//g;
		$startTime =~ s/S" endTime=.*//g;
		
		my $endTime = $line;
		$endTime =~ s/.*endTime="PT//g;
		$endTime =~ s/S".*//g;
		
		print OUTPUTFILE "$segtype,$startTime,$endTime\r\n";
	}
	
}

close(INPUTFILE);
close(OUTPUTFILE);