/*
Write a program on datagram sockets for client/server to display message on client side,typed on server side.
*/

import java.io.*;
import java.net.*;

class udpClient
{

    public static void main(String[] args) throws IOException
    {
        //Set the port number on which the client must communicate to the server.
        DatagramSocket ds=new DatagramSocket(2345);
        String msg;
        byte[] buf=new byte[100];

        while(true)
        {
            DatagramPacket rdp=new DatagramPacket(buf,buf.length);
            ds.receive(rdp);
            msg=new String(rdp.getData(),rdp.getOffset(),rdp.getLength());

            System.out.println(msg);
        }

    }

}