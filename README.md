# ComputerNetworksLab VTU 17 Scheme
 A best effort service to comment code and learn about this lab.

## Installation Guide for NS2(Ubuntu)
 1. Install network simulator 
 `$sudo apt install ns2`
 
 2. Download xgraph from http://www.xgraph.org/linux/index.html for appropriate Ubuntu on your machine.
 3. Untar the downloaded file :
    `$sudo tar -C /bin/xgraph/ -xvf xgraph_4.38_linux64.tar.gz `
   <br><br> NOTE:  This untared dir has a bin dir which contains the xgraph executable which we need to add to .bashrc 
4. Navigate to home using directory and open .bashrc file
5. Create Alias for the command , add the below line into bashrc file<br>
	`alias xgraph='path_to_the_untarred_dir/bin/xgraph' `
7. Run the below command to reflect changes made to bashrc :<br>
    `$ source ~/.bashrc`
6. Have fun with tcl.`
