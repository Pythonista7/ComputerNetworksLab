//TCP Server

import java.net.*;
import java.io.*;

class tcpServer
{
	
	public static void main(String args[]) throws IOException
	{
		//setup a server socket on a port no(needs to be greater than 1023) , say 5050
		ServerSocket sersock=new ServerSocket(5050);
		System.out.println("Server Started");
		
		//Once a client tries to connect to the server we accept the connection
		Socket sock=sersock.accept();
		System.out.println("Server ready");
		
		//Create an input stream to read the information sent by the client 
		InputStream istream=sock.getInputStream();

		//Use a BufferedReader to read the contents from the above created input stream
		BufferedReader br=new BufferedReader(new InputStreamReader(istream));

		//read and store the contents from the istream into a string variable 'filename'
		String fname=br.readLine();

		//the contents of the specified filename passed by the client is read here(at the server) using another bufferedReader
		BufferedReader ContentReader=new BufferedReader(new FileReader(fname));

		//An output stream is created so as to realy the data the client had requested for
		OutputStream ostream=sock.getOutputStream();

		//create a PrintWriter class to write the contents of the requested file into the outstream
		PrintWriter pr=new PrintWriter(ostream,true);//SYNTAX : PrintWriter(Writer out, boolean autoFlush

		//msg is a temporary variable to store and send data to the outstream via printwriter 		
		String msg;
		System.out.println("Sending contents of "+fname);
		//Keep sending data from file to outstream until EOF/Null is encountered
		while((msg=ContentReader.readLine()) != null)
		{
			pr.println(msg);
		}
		
		sock.close();
	}



}
