BEGIN{
    #include<stdio.h>
    count1=0;
    count2=0;
    Packet1=0;
    Packet2=0;
    time1=0;
    time2=0;
}
{
    if($1=="r" && $3=="_1_" && $4=="AGT")
    {
        count1++;
        Packet1=Packet1+$8;
        time1=$2;
    }

    if($1=="r" && $3=="_2_" && $4=="AGT")
    {
        count2++;
        Packet2 = Packet2 + $8;
        time2=$2;
    }

}
END{
    printf("Throughput from n0 to n1 %f Mbps \n",(count1 * Packet1 * 8)/(time1 * 1000000));
    printf("Throughput from n0 to n1 %f Mbps \n",(count2 * Packet2 * 8)/(time2 * 1000000));
}