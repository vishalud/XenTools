#!/usr/bin/perl 

$limit = $ARGV[0]; 
$i = 0; 
$LAST = 0; 
my @LOAD; 

`xe host-cpu-list | grep uuid > /tmp/cpulist`; 

open(DATEI, "</tmp/cpulist") || die "Datei nicht gefunden"; 
my @Zeilen = <DATEI>; 
close(DATEI); 

foreach (@Zeilen) { 
   chomp($_); 
   } 

foreach(@Zeilen) { 
   $_ =~ s/uuid \( RO\)           : //; 
   push(@NeueZeilen,$_) 
   } 

foreach(@NeueZeilen) { 
   $AUFRUF = 'xe host-cpu-param-get uuid='.$NeueZeilen[$i].' param-name=utilisation'; 
   $LOAD[$i] = qx($AUFRUF); 
   $i++; 
   } 
    
for ($j = 0; $j <= $i; $j++) {    
   $LAST=$LAST+$LOAD[$j]; 
   } 

$LAST=$LAST/$i; 

$LAST=sprintf("%.3f", $LAST); 
$LAST=$LAST*100; 
if ($LAST > $limit) { 
print "ScriptRes:Bad:".$LAST." %"; 
} else { 
print "ScriptRes:Ok:".$LAST." %"; 
}