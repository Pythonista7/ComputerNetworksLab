#-------------------------------------------------------------------------------
# repository link : https://github.com/Pythonista7/ComputerNetworksLab
#-------------------------------------------------------------------------------
#
#                             PING   
#
#-------------------------------------------------------------------------------
#                              AIM
#-------------------------------------------------------------------------------
# Implement transmission of ping messages/trace route over a network topology
# consisting of 6 nodes and find the number of packets dropped due to congestion.
#-------------------------------------------------------------------------------

#STEP1

#Initialize Simulator
set ns [new Simulator]
#Setup a trace file
set tf [open ping_code.tr w]  
$ns trace-all $tf
#Setup a Networks Animator File
set nf [open ping_code.nam w]
$ns namtrace-all $nf

#STEP2 Building Topology

#A : Create 6 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

#B : Label Nodes
$n2 label "Router"
$n0 label "Ping0"
$n1 label "Ping1"
$n4 label "Ping4"
$n5 label "Ping5"
$n6 label "Ping6"

#C : Set colors
$ns color 1 "red"
$ns color 2 "blue"

#D : Setup connection with packet size and rates
#       RED : Random early detection (RED), 
#             also known as random early discard or random early drop 
#             is a queuing discipline for a network scheduler suited for congestion avoidance.
$ns duplex-link $n0 $n2 10Mb 300ms RED
$ns duplex-link $n4 $n2 7Mb 300ms RED
$ns duplex-link $n5 $n2 10Mb 300ms RED
$ns duplex-link $n1 $n2 7Mb 300ms RED
$ns duplex-link $n2 $n6 3Mb 300ms RED

#E : Set queue limits
$ns set queue-limit $n0 $n2 10
$ns set queue-limit $n2 $n1 10
$ns set queue-limit $n4 $n2 10
$ns set queue-limit $n5 $n2 10
$ns set queue-limit $n6 $n2 10


#STEP 3
#A : Attach Agents to nodes

set ping0 [new Agent/Ping]
$ns attach-agent $n0 $ping0 

set ping1 [new Agent/Ping]
$ns attach-agent $n1 $ping1

set ping4 [new Agent/Ping]
$ns attach-agent $n4 $ping4

set ping5 [new Agent/Ping]
$ns attach-agent $n5 $ping5

set ping6 [new Agent/Ping]
$ns attach-agent $n6 $ping6


#B : Set packet sizes
$ping0 set packetSize_ 50000
$ping0 set interval_ 0.0001

$ping5 set packetSize_ 60000
$ping5 set interval_ 0.00001

$ping1 set packetSize_ 60000
$ping1 set interval_ 0.001

#C : Set colors
$ping0 set class_ 1
$ping4 set class_ 1
$ping5 set class_ 2
$ping6 set class_ 2
$ping1 set class_ 2


#D : Connect nodes
$ns connect $ping0 $ping4 
$ns connect $ping5 $ping6 
$ns connect $ping1 $ping6

Agent/Ping instproc recv { from rtt } {
$self instvar node_
#Note the space between $node_"SPACE"id
puts "The node [ $node_ id ] received a reply $from with a RTT of $rtt"
}


#-A procedure to run the simulation and execute awk file to count drops
proc finish { } {
global ns nf tf
exec nam ping_code.nam &
exec awk -f drop_count.awk ping_code.tr &
$ns flush-trace

close $tf
close $nf
exit 0
}

#-A fuction to generate traffic in the network at frequent intervals
proc sendPingPacket { } {
#Using global variables
global ns ping0 ping5 ping1
#Generate traffic every 0.001 secs
set interval_ 0.001
#Set a reference time variable w.r.t current time
set now [ $ns now ]
#Every $now + $interval seconds trigger traffic from nodes
$ns at [ expr $now + $interval_ ] "$ping0 send"
$ns at [ expr $now + $interval_ ] "$ping5 send"
$ns at [ expr $now + $interval_ ] "$ping1 send"
#After the nodes send traffic recursivly call this proc again and again until finish time(5.0 sec)
$ns at [ expr $now + $interval_ ] "sendPingPacket"
}

$ns at 0.01 "sendPingPacket"
$ns at 5.0 "finish"
$ns run

#-------------------------------------------------------------------------------
#      Run this file on cmd as 
#                                  $ ns ping_code.tcl
#  NOTE:
#       This program automatically runs nam and awk.
#  If you want to know how to execute nam and awk files individually
#  refer finish proc{} or /sim1p2p/p2p_code.tcl file comments.
#-------------------------------------------------------------------------------
