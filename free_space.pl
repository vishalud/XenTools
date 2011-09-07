#!/usr/bin/perl 
$limit = $ARGV[0]; 
chomp($belegt = `xe sr-param-get uuid=$ARGV[1] param-name=physical-utilisation`); 
chomp($total = `xe sr-param-get uuid=$ARGV[1] param-name=physical-size`); 
$membyte = $total - $belegt; 
$memkbyte = $membyte/1024; 
$memmbyte = $memkbyte/1024; 
$memgbyte = $memmbyte/1024; 
$memfree = sprintf("%.3f", $memgbyte); 
if ($memmbyte > $limit) { 
print "ScriptRes:Ok:".$memfree." GB"; 
} else { 
`xe message-create name="Speicherplatz auf SR" body="Speicherplatz auf dem genannten SR ist fast erschoepft. Noch $memfree GB verfuegbar" priority=1 sr-uuid=$ARGV[1]`; 
print "ScriptRes:Bad:".$memfree." GB"; 
}