#-------------------------------------------------------------------------------
# repository link : https://github.com/Pythonista7/ComputerNetworksLab
#-------------------------------------------------------------------------------
#
#                           ESS-WIRELESS-LAN   
#
#-------------------------------------------------------------------------------
#                              AIM
#-------------------------------------------------------------------------------
# Implement simple ESS and with transmitting nodes in wire-less LAN by simulation
# and determine the performance with respect to transmission of packets.
#-------------------------------------------------------------------------------

#STEP1

#Initialize Simulator
set ns [new Simulator]
#Setup a trace file
set tf [open ess_code.tr w]  
$ns trace-all $tf

#Setup a Topology and Networks Animator File
set topo [new Topography]
$topo load_flatgrid 1000 1000
set nf [open ess_code.nam w]
$ns namtrace-all-wireless $nf 1000 1000

#https://www.nsnam.com/2012/09/wireless-node-configuration-in-network.html

# adhoc routing DSDV = Destination-Sequenced Distance-Vector Routing (DSDV) 
#                   -is a table-driven routing scheme for ad hoc mobile networks based on the Bellman–Ford algorithm. 
# 
# LL = Link Layer , phyType=Physical Layer Type
#
# ifqType = Interface Queue type , ifqLen = Interface Queue Length
#
# channelType =  Channel to be used for communication(Wired/Wireless)
#
# propType =  Propogation Type of the signal 
#               -The Two-Rays Ground Reflected Model is a radio propagation model which predicts the
#                path losses between a transmitting antenna and a receiving antenna when they are in LOS (line of sight).
#                Generally, the two antenna each have different height.
#
# antType = Antenna Type
#           -Omni Antenna :  is a class of antenna which radiates equal radio power in all directions perpendicular to an axis,
#                            with power varying with angle to the axis, declining to zero on the axis. 
#
#
#
#
$ns node-config -adhocRouting DSDV \
                -llType LL \
                -ifqType Queue/DropTail \
                -macType Mac/802_11 \
                -ifqLen 50 \
                -phyType Phy/WirelessPhy \
                -channelType Channel/WirelessChannel \
                -propType Propagation/TwoRayGround \
                -antType Antenna/OmniAntenna \
                -topoInstance $topo \
                -agentTrace ON \
                -routeTrace ON \

# GOD --> General Operations Director
create-god 3 

#Create Nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

#Label the nodes
$n0 label "tcp0"
$n1 label "sink1/tcp1"
$n2 label "sink2"


# Mobile Node Movement
#--------------------
# Node position defined in a 3-D model.
# However z axis not used
# $node set X_ <x1>
# $node set Y_ <y1>
# $node set Z_ <z1>$node at 
# $time setdest<x2> <y2> <speed>
# Node movement may be logged

$n0 set X_ 50
$n0 set Y_ 50
$n0 set Z_ 0


$n1 set X_ 100
$n1 set Y_ 100
$n1 set Z_ 0


$n2 set X_ 200
$n2 set Y_ 200
$n2 set Z_ 0

# $time setdest<x2> <y2> <speed> from above comment ^^^^
$ns at 0.1  "$n0 setdest 50 50 15"
$ns at 0.1  "$n1 setdest 100 100 25"
$ns at 0.1  "$n2 setdest 600 600 25"

# Attaching agents to Nodes
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0 
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

set sink0 [new Agent/TCPSink]
$ns attach-agent $n1 $sink0
$ns connect $tcp0 $sink0

set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

set sink1 [new Agent/TCPSink]
$ns attach-agent $n2 $sink1
$ns connect $tcp1 $sink1

#Start sending traffic at 0.5 seconds
$ns at 0.5 "$ftp0 start"
$ns at 0.5 "$ftp1 start"

#Move n2 node towards 150 150 till 100s
$ns at 100 "$n2 setdest 150 150 35"
#Move n2 node towards 70 70 from 100s to 190s
$ns at 190 "$n2 setdest 70 70 15"

#Same as previous simulations
proc finish { } {
global ns nf tf
$ns flush-trace
exec nam ess_code.nam &
exec awk -f perf_test.awk ess_code.tr &
close $tf
exit 0
}

# Terminate simulation at 200 
$ns at 200 finish
$ns run 