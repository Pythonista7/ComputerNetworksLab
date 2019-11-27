# ComputerNetworksLab VTU 17 Scheme
 A best effort service to comment code and learn about this lab.

## Installation Guide for NS2(Ubuntu)
 1. Install network simulator 
 `$sudo apt install ns2`
 
 2. Download xgraph from http://www.xgraph.org/linux/index.html for appropriate Ubuntu on your machine.
 3. Untar the downloaded file :
    `$sudo tar -C /bin/xgraph/ -xvf xgraph_4.38_linux64.tar.gz `
   <br><br> NOTE: <br>a. I have untarred this to my /bin/xgraph/ directory(of which the xgraph dir is once which Ive mkdir'd).You can choose to untar it to your desired location by replacing /bin/xgraph to your destination dir path.  
   		<br>b. This untared dir has a bin dir which contains the xgraph executable which we need to add to .bashrc 
4. Navigate to home using directory and open .bashrc file 
(.bashrc is a hidden file and hence may not show up in your file-explorer,either options->show hidden files or open it on VIM via the terminal).
5. Create Alias for the command , add the below line into bashrc file<br>
	`alias xgraph='path_to_the_untarred_dir/bin/xgraph' `
7. Run the below command to reflect changes made to bashrc :<br>
    `$ source ~/.bashrc`
6. Have fun with tcl.`
