BEGIN{
    #include<stdio.h>
}
{
    if($6=="cwnd_")
        printf("%f \t %f \t\n",$1,$7);
}
END{
    puts "done"
}