BEGIN {
send=0;
recv=0;
st=-1;
ft=-1;
bytes=0;
delay=0;
last_pkt_t=0;
jitter=0;
j_count=0;
rtr=0;

max_node=0;
avg_consumed_energy=0;
}


{

if($3 == "energy_consumption")
{
consumed_energy[$2]=$4;
max_node=(max_node > $2) ? max_node : $2;
num_nodes=max_node+1;
}

if ($1 == "Node" && $3 == "send" && $4 == "bytes")
{
send++;
if(st == -1)
st=$9;
ft=$9;
send_t[$7]=$9;
}


if ($1 == "Sink" && $3 == "recv" && $4 == "bytes")
{
recv++;
bytes += $5;
recv_t[$7]=$9;
delay += (recv_t[$7]-send_t[$7]);
if(last_pkt_t)
{
jitter += ($9-last_pkt_t);
j_count++;
}
last_pkt_t=$9;
}

if($4 == "RTR")
{
rtr++;
}

}

END {

tot_con_egy=0;
for(i=0;i<num_nodes;i++)
{
tot_con_egy += consumed_energy[i];
}
avg_consumed_energy = tot_con_egy/num_nodes;

print "send\t\t\t" send;
print "recv\t\t\t" recv;
print "control_overhead\t" rtr;
print "Packet_delivery_ratio\t" (recv/send)*100.0;
print "Avg_delay\t\t" delay/recv;
print "Throughput\t\t" (bytes*8)/(ft-st);
print "PktsDropped\t\t" send-recv;
print "Jitter\t\t\t" jitter/j_count;
print "avg_consumed_energy\t" avg_consumed_energy;
}
