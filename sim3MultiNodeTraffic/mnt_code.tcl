#-------------------------------------------------------------------------------
# repository link : https://github.com/Pythonista7/ComputerNetworksLab
# Ref link for queue types : https://sites.google.com/a/seecs.edu.pk/network-technologies-tcp-ip-suite/home/performance-analysis-of-impact-of-various-queuing-mechanisms-on-mpeg-traffic/working-mechanism-of-fq-red-sfq-drr-and-drop-tail-queues
#-------------------------------------------------------------------------------
#
#                           ETHERNET-LAN   
#
#-------------------------------------------------------------------------------
#                              AIM
#-------------------------------------------------------------------------------
#Implement an Ethernet LAN using n nodes and set multiple traffic nodes and plot
#congestion window for different source / destination.
#-------------------------------------------------------------------------------

#STEP1

#Initialize Simulator
set ns [new Simulator]
#Setup a trace file
set tf [open mnt_code.tr w]  
$ns trace-all $tf
#Setup a Networks Animator File
set nf [open mnt_code.nam w]
$ns namtrace-all $nf

#STEP2 Building Topology

#A : Set Nodes 
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

#B : Label Nodes
$n1 label "ETH1"
$n2 label "ETH2"
$n3 label "ETH3"
$n4 label "ETH4"

#C : Set colors
$ns color 1 "green"
$ns color 2 "red"

#D : Create a lan connection consisting of the 4 nodes
#       SYNTAX : make-lan
#                $ns_ make-lan nodelist bw delay LL ifq MAC channel phy
#       DESCRIPTION:
#                Creates a lan from a set of nodes given by <nodelist>. Bandwidth, 
#                delay characteristics along with the link-layer, Interface queue, Mac layer and channel type
#                for the lan also needs to be defined. Default values used are as follows:
#                <LL> .. LL
#                <ifq>.. Queue/DropTail
#                <MAC>.. Mac
#                <channel>.. Channel and
#                <phy>.. Phy/WiredPhy 
#
#       REF LINK : https://www.isi.edu/nsnam/ns/doc/node161.html
#
$ns make-lan "$n1 $n2 $n3 $n4" 10Mb 10ms LL Queue/DropTail Mac/802_3


# STEP 3

#A : Attach agents to nodes

#Initialize a TCP agent used by a FTP application at node 1.This node generates traffic.
set ETH1 [ new Agent/TCP ]
$ns attach-agent $n1 $ETH1
#Attach node(ETH1) to the Application(FTP1)
set ftp1 [ new Application/FTP ]
$ftp1 attach-agent $ETH1

#setup node 2 as a TCP Sink for traffic from node 1
set ETH2 [ new Agent/TCPSink ]
$ns attach-agent $n2 $ETH2

#setup node 3 as a TCP Sink for traffic from node 4
set ETH3 [ new Agent/TCPSink ]
$ns attach-agent $n3 $ETH3

#setup node4 as a TCP node running FTP. It generates traffic towards node3
set ETH4 [ new Agent/TCP ]
$ns attach-agent $n4 $ETH4
#Attach node(ETH4) to the Application(FTP4)
set ftp4 [ new Application/FTP ]
$ftp4 attach-agent $ETH4

#B : Setup colors
$ETH1 set class_ 1
$ETH4 set class_ 2

#C : Connect the nodes
$ns connect $ETH1 $ETH2
$ns connect $ETH4 $ETH3

#D : Setup files for the nodes to write into
set file1 [ open file1.tr w ]
$ETH1 attach $file1 
#cwnd = Congestion Window
$ETH1 trace cwnd_ 
$ETH1 trace maxcwnd_ 10

set file2 [ open file2.tr w ]
$ETH4 attach $file2
#cwnd = Congestion Window
$ETH4 trace cwnd_ 
$ETH4 trace maxcwnd_ 10

#STEP 4
proc finish { } {
global ns tf nf
exec nam mnt_code.nam &
#exec awk -f get_congestion.awk file1.tr > cong1 &
#exec awk -f get_congestion.awk file2.tr > cong2 &
$ns flush-trace
close $tf
close $nf
exit 0
}

#SETP 5 Run the simulation

$ns at 0.1 "$ftp1 start"
$ns at 1.0 "$ftp1 start"
$ns at 2.0 "$ftp1 start"
$ns at 3.0 "$ftp1 start"

$ns at 0.1 "$ftp4 start"
$ns at 1.0 "$ftp4 start"
$ns at 2.0 "$ftp4 start"
$ns at 3.0 "$ftp4 start"

$ns at 5.0 "finish"
$ns run