#!/usr/bin/perl 
$limit = $ARGV[0]; 
chomp($str = `xe host-list params=memory-free`); 
$membyte = substr($str,23,length($str)-23); 
$memkbyte = $membyte/1024; 
$memmbyte = $memkbyte/1024; 
$memgbyte = $memmbyte/1024; 
$memfree = sprintf("%.3f", $memgbyte); 
if ($memmbyte > $limit) { 
print "ScriptRes:Ok:".$memfree." GB"; 
} else { 
print "ScriptRes:Bad:".$memfree." GB"; 
}