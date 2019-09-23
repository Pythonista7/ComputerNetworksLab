//Write a program for congestion control using leaky bucket algorithm.

import java.security.SecureRandom;
import java.util.*; 
import java.io.*;

class Bucket
{
	public static void main(String args[])
	{
		Random r=new Random();
		Scanner s = new Scanner(System.in);
		 
		System.out.println("Enter the input rate: ");
		int n=s.nextInt();

		System.out.println("Enter the Bucket Size: ");
		int bucket_size=s.nextInt();

		System.out.println("Enter the Output Rate: ");
		int out_rate=s.nextInt();

		System.out.println("Enter packet data: ");
		int[] input_arr=new int[n];

		for(int i=0;i<n;i++)
		{
			input_arr[i]=r.nextInt(127);//s.nextInt(); here we'll be auto populating the array instead of inputting n numbers
		}
		
		int bc=0;//bucket_content=0

		//loop through for each packet in input_arr[]
		for(int i=0;i<n;i++)
		{
			//check if the new packet fits into the bucket at the current instance 
			if(bc+input_arr[i]<=bucket_size)
			{	//if new packet can be fit then insert it into the bucket
				bc=bc+input_arr[i];
				System.out.print(i+"\tPacket: "+input_arr[i]+"\tBucket Content: "+bc+"\tStatus: Accepted\tRemaining: ");		
				//after processing(displaying) the status display remove bucket content equal to out_rate 	
				bc=bc-out_rate;

				//note - removal of element must not cause negative bucket capacity.
				if(bc<=0)//bc=bc<=0?0:bc;
				{
					bc=0;
				}
				System.out.println(bc);//Display remaining capacity 
			}
			//If the packet does not fit into current bucket then simply drop the packet and continue to out_rate
			else
			{
				System.out.print(i+"\tPacket: "+input_arr[i]+"\tBucket Content: "+bc+"\tStatus: Rejected\tRemaining: ");		
				//remove outrate from bc as normal cycle
				bc=bc-out_rate;
				if(bc<=0)//dont let the bucket capacity assume negative values
				{
					bc=0;
				}
				System.out.println(bc);
			}


			
		}
		
	}

}
