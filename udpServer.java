/*
Write a program on datagram sockets for client/server to display message on client side,typed on server side.
*/

import java.io.*;
import java.net.*;

//First run the server program(this) on one terminal and then run the client on another terminal 
class udpServer
{
    public static void main(String[] args) throws IOException 
    {

        DatagramSocket ds=new DatagramSocket();
        InetAddress ip = InetAddress.getByName("localhost");//specify the IP Address
        BufferedReader br=new BufferedReader(new InputStreamReader(System.in));
        
        int port =2345;//define port number
        String msg;
        
        while(true)
        {
            //read every line
            msg=br.readLine();
            
            //create a Datagram packet with specifications-> string as bytes, length of the message,IP address, Port Number 
            DatagramPacket dp=new DatagramPacket(msg.getBytes(),msg.length(),ip,port);

            //if the message is quit , terminate the program
            if(!msg.equals("quit"))
                ds.send(dp);
            else
                break;
        }
        
    }
}