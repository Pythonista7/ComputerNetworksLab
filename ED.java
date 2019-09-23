import java.math.*;
import java.io.*;
import java.security.*;
/*
	ALGORITHM
	==========
	STEP 1 > pick 2 large prime numbers , say 'p' and 'q' 

	STEP 2 > Compute their product, say n = p * q

	STEP 3 > Compute PHI(n) as PHI(n) = (p-1) * (q-1)

	STEP 4 > pick a value 'e' such that GCD(e,PHI(n))=1 , here 'e' is the encrytion key

	STEP 5 > calculate 'd' as d = e^(-1) mod PHI(n) , here 'd' is the decryption key

	STEP 6 > now we have our PublicKey=(e,n) and PrivateKey=(d,n) 

	STEP 7 > Encryption : CipherText = (Message)^e mod n

	STEP 8 > Decryption : PlainMsg = (CipherText)^d mod n
  
*/

class ED_helper
{
	private int bitlen,r;
	private BigInteger p,q,n,phi,e,d;
	
	ED_helper(int bit)
	{
		bitlen=bit;//number of bits strong we want our encryption to be 
		SecureRandom r=new SecureRandom();//we use this because its a 128bit rand_generator,hence low chances of repeats.
		
		//<================================<  STEP 1 >======================================>
	
		//SYNTAX
		//BigInteger(int bitLength, int certainty, Random rnd)
		
		//we want to generate encryption keys as a product of p and q hence each of p and q much contain half as many digits
		//as bitlen.And the second value to the BigInt tells us we want to generate primes with 100% certainity using 'r'
		p=new BigInteger(bitlen/2,100,r);
		q=new BigInteger(bitlen/2,100,r);
		
		System.out.println("P value :"+p+"\n\n\n "+"Q value="+q);
	
		//<================================<  STEP 2 >======================================>	
		n=p.multiply(q);//BigInteger Multiplication
		
		//<================================<  STEP 3 >======================================>
		phi=p.subtract(BigInteger.ONE).multiply(q.subtract(BigInteger.ONE));
		
		//<================================<  STEP 4 >======================================>
		e=new BigInteger(bitlen/2,100,r);//BigInteger will take care of GCD() <UNDERATED STEP>
		
		//<================================<  STEP 5 >======================================>
		d=e.modInverse(phi);//e^-1 then % phi
		
		//<================================<  STEP 6 >======================================>
		System.out.println("\n\n\nValue of D :"+d+"\n\n\nValue of E : "+e);//Displaying keys
		
	}
	

	//<================================<  STEP 7 >======================================>
	public BigInteger encrypt(BigInteger Msg)
	{
		//CipherText = (Msg)^e mod n 
		return(Msg.modPow(e,n));
		
	}
	
	//<================================<  STEP 8 >======================================>
	public BigInteger decrypt(BigInteger Msg)
	{
		//DecodedMsg = (Ciphext)^d mod n
		return(Msg.modPow(d,n));
		
	}


}

//Main Driver Class to demonstrate functionalities implemented by the above class
class ED
{
	
	public static void main(String args[]) throws IOException
	{
		//Create object and pass the bit length 
		ED_helper rsa=new ED_helper(1200);
		
		BufferedReader br=new BufferedReader(new InputStreamReader(System.in));
		
		String text1,text2;
		BigInteger Pt,Ct;
		
		//Input Message from user
		System.out.println("\n\nEnter Plaintext :");
		text1=br.readLine();
		
		//pass the input message to the encrypt method to obtain cipher text
		Pt=new BigInteger(text1.getBytes());
		Ct=rsa.encrypt(Pt);
		System.out.println("\n\nCiperText is : "+Ct);
		
		//Pass the CipherText to the decrypt method to obtain original message
		Pt=rsa.decrypt(Ct);
		text2=new String(Pt.toByteArray());
		System.out.println("\n\n\nData after decrypt :"+text2);
	}

}
