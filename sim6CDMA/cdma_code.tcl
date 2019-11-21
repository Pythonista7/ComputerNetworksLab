Mac/802_11 set cdma_code_bw_start_ 0
Mac/802_11 set cdma_code_bw_stop_ 63
Mac/802_11 set cdma_code_init_start_ 64 
Mac/802_11 set cdma_code_init_stop_ 127
Mac/802_11 set cdma_code_cqich_start_ 128
Mac/802_11 set cdma_code_cqich_stop_ 195
Mac/802_11 set cdma_code_handover_start 196
Mac/802_11 set cdma_code_handover_stop_ 255

set f0 [open out02.tr w]
set f1 [open lost02.tr w] 
set f2 [open delay02.tr w]

set ns [new Simulator]
set topo [new Topography]
set tracefd [open out.tr w]
set namtrace [open out.nam w]

$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace 1000 800
$topo load_flatgrid 1000 1000

create-god 25
$ns color 0 red
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
		-macTrace OFF \


#Creating Node in flat grid
for {set i 0} {$i < 25} {incr i} {
	set node_($i) [$ns node]

$node_($i) set X_ [expr rand() * 1000]
$node_($i) set Y_ [expr rand() * 800]
$node_($i) set Z_ 0
}


for {set i 0} {$i < 25} {incr i} {
	set xx [expr rand() * 1000]
	set yy [expr rand() * 800]

	$ns at 0.1 "$node_($i) setdest $xx $yy 40"
}


puts "Loading connection pattern...."

puts "Loading senario file ....."

for {set i 0} {$i < 25} {incr i} {
	$ns initial_node_pos $node_($i) 50
}

for {set i 0} {$i < 25} {incr i} {

	$ns at 10.0 "$node_($i) reset"

}

set udp0 [new Agent/UDP]
$ns attach-agent $node_(4) $udp0


set sink [new Agent/LossMonitor]
$ns attach-agent $node_(20) $sink

set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 1000
$cbr1 set interval_ 0.1
$cbr1 set maxpkts_ 10000

$cbr1 attach-agent $udp0
$ns connect $udp0 $sink

$ns at 1.00 "$cbr1 start"

set holdtime 0
set holdseq 0
set holdrate1 0


proc record { } {
global sink f0 f1 f2 holdtime holdseq holdrate1
set ns [Simulator instance]
set time 0.9

set bw0 [$sink set bytes_]
set bw1 [$sink set nlost_]

set bw2 [$sink set lastPktTime_]
set bw3 [$sink set npkts_]

set now [$ns now]

puts $f0 "$now [expr (($bw0+$holdrate1)*8)/(2*$time*1000000) ]"

puts $f1 "$now [expr $bw1/$time]"

if { $bw3 > $holdseq } {
	puts $f2 "$now [expr ($bw2-$holdtime)/($bw3-$holdseq)]"

} else {
		puts $f2 "$now [expr ($bw3 - $holdseq)]"

}

$sink set bytes_ 0
$sink set nlost_ 0

set holdtime $bw2
set holdseq $bw3

set holdrate1 $bw0

	$ns at [expr $now + $time] "record"


}

$ns at 0.0 "record"

$ns at 1.0 "$node_(4) add-mark m blue square"
$ns at 1.0 "$node_(20) add-mark m red square"
$ns at 1.0 "$node_(4) label SENDER"
$ns at 1.0 "$node_(20) label RECEIVER"
$ns at 0.01 "$ns trace-annotate \"Network Deployment\""


proc finish { } {
	global ns tracefd f0 f1 f2
	$ns flush-trace
	exec nam out.nam &

	close $f0
	close $f1
	close $f2
	exit 0

}

$ns at 10 "finish"
$ns run

}




