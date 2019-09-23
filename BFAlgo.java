//Write a program to find the shortest path between vertices using bellman-ford algorithm.

import java.util.*;
import java.io.*;
import java.math.*;

class BFAlgo
{
	public static void main(String args[])
	{
		Scanner s=new Scanner(System.in);

		//Input the number of nodes in the graph
		System.out.println("Enter the number of nodes: ");
		int n=s.nextInt();
		
		//Input source and destination node numbers
		System.out.println("Enter Source node number :");
		int source=s.nextInt();

		System.out.println("Enter Destination node number :");
		int dest=s.nextInt();

		//create distance array
		int[] dist=new int[n];
		for(int i=0;i<n;i++)
			//Initialize the array with a maximum value which is assumed to be far greater then any edge weight
			dist[i]=999;

		//create adj matrix
		int[][] adj_mat=new int[n][n];
		System.out.println("Enter adj matrix :");
		
		//Input the adj_matrix
		for(int i=0;i<n;i++)
		{
			for(int j=0;j<n;j++)
			{
				
				adj_mat[i][j]=s.nextInt();
		
			}
		}

		//display adj_mat
		System.out.println("\n\nEntered ADJ MATRIX IS:");
		disp(adj_mat);
		dist[source]=0;

		//loop through all the nodes
		for(int k=0;k<n-1;k++)
		{
			for(int i=0;i<n;i++)
			{
				//for each node as the souce update the cost in adj_matrix
				for(int j=0;j<n;j++)
				{
					//if there is a direct path between nodes i and j
					if(adj_mat[j][i]!=999)
					{
					  //then check if the direct path is shorter than an alternate path through another node
					  //choose the shortest dist and update the distance array
						if(dist[i]>dist[j]+adj_mat[j][i])
							dist[i]= dist[j]+adj_mat[j][i];
					}
				}
			
		
			}
		}		

		//display statements
		for(int i=0;i<n;i++)
			System.out.println(source+"-->"+i+" = "+dist[i]);
	}

	//helper function for 2D matrix	
	public static void disp(int arr[][])
	{
		for(int[] x : arr)
		{	for(int y : x)				
				System.out.print(y);
			System.out.println();
		}
	}


}
