BEGIN{
    #include<stdio.h>
    count=0
}

{
    if($1=="d")
        count++;
}

END{
    printf("Number of Dropped Packets : %d \n",count)
}