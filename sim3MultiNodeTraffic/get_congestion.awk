BEGIN{
    #include<stdio.h>
}
{
    if($6=="cwdn_")
        printf("%f \t %f \n",$1,$7);
}
END{
    puts "done"
}