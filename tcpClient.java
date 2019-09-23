import java.net.*;
import java.io.*;

class tcpClient
{
	public static void main(String args[]) throws IOException
	{
		//Establish a connection at the given IP and port number. "localhost" refers to this computer
		Socket sock=new Socket("localhost",5050);

		//Input the file name to be retrived from the server
		System.out.println("Enter filename :");
		BufferedReader br=new BufferedReader(new InputStreamReader(System.in));
		String fname=br.readLine();
	
		//create output stream to send data to outstream
		OutputStream ostream=sock.getOutputStream();
		PrintWriter pw = new PrintWriter(ostream,true);
		//send filename to the server by writing to outstream using PrintWriter
		pw.println(fname);

		//Setup input strem to recieve file contents from the server
		InputStream istream=sock.getInputStream();
		BufferedReader sockread=new BufferedReader(new InputStreamReader(istream));
		String msg;
	
		//Store and print out each line that was read from the inputstream 
		while((msg=sockread.readLine())!=null)
		{
			System.out.println(msg);
		}
		
	}
}
