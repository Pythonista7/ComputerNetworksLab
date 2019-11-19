#STEP1
set ns [new Simulator]
set tf [open p2p_code.tr w]
$ns trace-all $tf
set nm [open p2p_code.nam w]
$ns namtrace-all $tf

#STEP2 Building Topology
#A
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

#B : name the nodes
$n0 label "Source1/udp0"
$n1 label "Source2/udp1"
$n2 label "IntermidiateNode/Router"
$n3 label "Destination Node"

#C : Vary bandwidth to observe packet drop
$ns duplex-link $n0 $n2 10Mb 300ms DropTail
$ns duplex-link $n1 $n2 10Mb 300ms DropTail
$ns duplex-link $n2 $n3 1Mb  300ms DropTail

#D : Set queue size between node
$ns set queue-limit $n0 $n2 10
$ns set queue-limit $n1 $n2 10
$ns set queue-limit $n2 $n3 5

#E : Color the Packets
$ns color 1 "green"
$ns color 2 "yellow"

#Step3
#A : Attach udp agents to n0 and n1 and null agent to n3
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0

set null3 [new Agent/Null]
$ns attach-agent $n3 $null3

set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1

#B : set udp0 to respective color
$udp0 set class_ 1
$udp1 set class_ 2

#step4 : connecting agents
$ns connect $udp0 $null3
$ns connect $udp1 $null3

#step5 : set parameter
$cbr1 set packetSize_ 200Mb
#set packet interal
$cbr1 set interval_ 0.001


#Step6
proc finish { } {
global ns tf
$ns flush-trace
exec nam egl-nam
close $tf
exit 0
}

$ns at 0.1 "$cbr0 start"
$ns at 0.5 "$cbr1 start"
$ns at 10.0 "finish"
$ns run