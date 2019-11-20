#-------------------------------------------------------------------------------
# repository link : https://github.com/Pythonista7/ComputerNetworksLab
#-------------------------------------------------------------------------------
#
#                         POINT TO POINT
#
#-------------------------------------------------------------------------------
#                              AIM
#-------------------------------------------------------------------------------
#Implement three nodes point – to – point network with duplex links between them.
#Set the queue size, vary the bandwidth and find the number of packets dropped.
#-------------------------------------------------------------------------------

#STEP1

#Initialize Simulator
set ns [new Simulator]
#Setup a trace file
set tf [open p2p_code.tr w]  
$ns trace-all $tf
#Setup a Networks Animator File
set nf [open p2p_code.nam w]
$ns namtrace-all $nf

#STEP2 Building Topology

#A : Create 4 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

#B : Label the nodes
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

#UDP agent is used to generate the traffic 
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

#Constant bit rate [CBR] in Ns2 is used along with TCP and UDP to design the 
#traffic source behavior of packets. 
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0

#A "null" agent just frees the packets received. 
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
#Connect traffic generating nodes(udp0 and udp1) to destination node(null3)
$ns connect $udp0 $null3
$ns connect $udp1 $null3

#step5 : set parameter
$cbr1 set packetSize_ 200Mb
#set packet interal
$cbr1 set interval_ 0.001


#Step6
proc finish { } {
global ns tf nf
$ns flush-trace
exec nam p2p_code.nam
close $tf
exit 0
}

#Start traffic from node 0 at time 0.1 seconds and node 1 at time 0.5 seconds
$ns at 0.1 "$cbr0 start"
$ns at 0.5 "$cbr1 start"
$ns at 10.0 "finish"
$ns run

#-------------------------------------------------------------------------------
#      Run this file on cmd as 
#                                  $ ns p2p_code.tcl
#                                  $ nam p2p_code.tr #This will start simulation
#
#      To check for the number of dropped packers we need to count the number dropped packets.
#      The packets which are dropped are marked on the trace-file(.tr) with a 'd' on column 1
#      Run the drop_count.awk file to get the count of number of dropped packets.
#           To run awk file :
#                                  $ awk -f drop_count.awk p2p_code.tr
#-------------------------------------------------------------------------------