#-------------------------------------------------------------------------------
# repository link : https://github.com/Pythonista7/ComputerNetworksLab
#-------------------------------------------------------------------------------
#
#                           PERFORMANCE STUDY : GSM   
#
#-------------------------------------------------------------------------------
#                              AIM
#-------------------------------------------------------------------------------
# Implement and study the performance of GSM on NS2/NS3 (Using MAC layer) or
# equivalent environment.
#-------------------------------------------------------------------------------


#Key line difference between this program and CDMA 
set val(type) GSM

#Open 3 files to record thoughput,loss and delay respectively
set f0 [open out02.tr w]
set f1 [open lost02.tr w]
set f2 [open delay02.tr w]

#Setup new simulator and Topography with tracefiles 
set ns [ new Simulator ]
set topo [ new Topography ]
set tracefd [open out.tr w]
set namtrace [ open out.nam w ]

$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace 1000 800
$topo load_flatgrid 1000 1000

#Create 25 gods for 25 nodes
create-god 25

#Set traffic color
$ns color 0 red

# COMMAND AT A GLANCE : https://www.isi.edu/nsnam/ns/doc/node195.html
#
#https://www.nsnam.com/2012/09/wireless-node-configuration-in-network.html
#
# adhoc routing AODV = Ad hoc On-Demand Distance Vector Routing is a 
#                      routing protocol for mobile ad hoc networks and other wireless ad hoc networks.
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
# initialEnergy <joule>  , ReceiverPower = rxPower <Watts> , TransmitorPower = txPower <Watts>
#
#
$ns node-config -adhocRouting AODV \
		-llType LL \
		-macType Mac/802_11 \
		-ifqType Queue/DropTail/PriQueue \
		-ifqLen 1000 \
		-phyType Phy/WirelessPhy \
		-channelType Channel/WirelessChannel \
		-propType Propagation/TwoRayGround \
		-antType Antenna/OmniAntenna \
		-energyModel EnergyModel \
		-initialEnergy 100 \
		-rxPower 0.3 \
		-txPower 0.6 \
		-topoInstance $topo \
		-agentTrace ON \
		-routerTrace ON \
		-macTrace OFF

#Create 25 nodes and place them in random positions 
for {set i 0} {$i < 25 } {incr i} {
	set node_($i) [$ns node]
$node_($i) set X_ [expr rand() * 1000]
$node_($i) set Y_ [expr rand() * 800]
$node_($i) set Z_ 0
}

#Randomly move the 25 nodes by setting random destinations for each and move towards dest with speed 40
for {set i 0} {$i < 25} {incr i} {
set xx [expr rand() * 1000]
set yy [expr rand() * 800]
$ns at 0.1 "$node_($i) setdest $xx $yy 40"
}


puts "loading connection pattern.."
puts "Loading scenario file.."


for {set i 0} {$i < 25} {incr i} {
	# The function must be called after mobility model is defined
	#Here 100 defines the node size set according to topo size
	$ns initial_node_pos $node_($i) 100
}

for {set i 0} {$i < 25} {incr i} {
	$ns at 10.0 "$node_($i) reset"
}

#udp0 to send traffic from node 4
set udp0 [new Agent/UDP]
$ns attach-agent $node_(4) $udp0

#sink to receive and Monitor packet loss at node 20
set sink [new Agent/LossMonitor]
$ns attach-agent $node_(20) $sink

#setup a cbr application at node4(udp0) with parameters : packetSize,interval,maxpkts
set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 1000
$cbr1 set interval_ 0.1
$cbr1 set maxpkts_ 10000
$cbr1 attach-agent $udp0

#connect the source and destination 
$ns connect $udp0 $sink
#Start sending traffic from udp0
$ns at 1.00 "$cbr1 start"

#temporary holder var to carry over values of 
#		holdtime (lastPktTime_) i.e - Time when the last packet was received  
#		holdseq (npkts_) i.e - No of packets
#		holdrate (bytes_) i.e - no of bytes
set holdtime 0
set holdseq 0
set holdrate1 0

#proc to record all the requried values to calculate throughput and meansure performance
proc record {} {
# import all necessary trace file references and holder vars from global namespace
global sink f0 f1 f2 holdtime holdseq holdrate1
set ns [Simulator instance]
#Record values for every 0.9 seconds
set time 0.9
#Store all the instance variables (bytes_,nlost_,lastPktTime_,npkts_) 
#				into an objects (i.e-bw0,bw1,bw2,bw3) and also get current time ($ns now)
set bw0 [$sink set bytes_]
set bw1 [$sink set nlost_]
set bw2 [$sink set lastPktTime_]
set bw3 [$sink set npkts_]
set now [$ns now]
#Write the current time and through-put into f0 trace file.
#	throughput = (no_of_bytes in current 0.9 sec) + bytes from all prev instances{which we get from holdrate var}) / (2*time in sec)
puts $f0 "$now [expr (($bw0+$holdrate1)*8)/(2*$time*1000000)]"

#Here f1 is the trace file for loss
#		loss = nlost_{i.e referenced by bw1} / current time duration{which is 0.9 seconds}
puts $f1 "$now [expr $bw1/$time]"

#Here we write to the f2 file which traces delay
#	if no of packets(bw3) > sum of all prev no of packets 
if { $bw3 > $holdseq } {
#	calculate delay as (lastPktTime_ - previous_lastPktTime)/(current npkts - previous npkts)
puts $f2 "$now [expr ($bw2 - $holdtime)/($bw3 - $holdseq)]"
} else {
#	else directly calculate and write delay into $f2 as (current npkts - previous npkts)
puts $f2 "$now [expr ($bw3 - $holdseq)]"
}

#reset instance var for next 0.9s
$sink set bytes_ 0
$sink set nlost_ 0

#record  lastPktTime(stored in bw2) into holdtime  , npkts(stored in bw3) into holdseq and no of bytes byte_(stored in bw0) into holdrate
set holdtime $bw2
set holdseq $bw3
set holdrate1 $bw0

#Recursively call this proc every 0.9 seconds
$ns at [expr $now+$time] "record"
}

#Start recording values from 0.0 seconds by calling the "record" proc
$ns at 0.0 "record"
#mark sender node with blue square
$ns at 1.0 "$node_(4) add-mark m blue square"
#mark reciever node with magenta square
$ns at 1.0 "$node_(20) add-mark m magenta square"
#Add lables to sender and receiver 
$ns at 1.0 "$node_(4) label SENDER"
$ns at 1.0 "$node_(20) label RCV"
$ns at 0.01 "$ns trace-annotate \"Network Deployment\""

#Finish proc to close all f0,f1,f2 file handles and run the nam
proc finish {} {
global ns tracefd f0 f1 f2
$ns flush-trace
exec nam out.nam &
close $f0
close $f1
close $f2
exit 0
}
  

#End simulation at 10 seconds
$ns at 10 "finish"
$ns run
