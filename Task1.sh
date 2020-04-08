
log=log_file.txt #create a new log file, if exist it opens that file


echo "Program was executed at datetime " $(date) >> $log #>> append in the file, > to overwrite that file

#get input from user to select what task to perform
echo -e "Please Enter the number to perform the respective task\nPress 1 to check Total Available RAM\nPress 2 to check Total storage space available for a mount point\nPress 3 to List top 5 processes for a specific user\nPress 4 to List the ports exposed and the process associate with it\nPress 5 to show Option to free up cached memory\nPress 6 to list the files with their size in (MBs) of given directory, sorted in descending order\nPress 7 to list the Folders with their size in (MBs) for a given directory, sorted in descending order "
read Task_num #read user input and store it in a variable

echo "Task number selected by user $Task_num" >> $log

if [ $Task_num -eq 1 ] #if user entered to perform task 1
then
	Avl_Mem=$(grep MemTotal /proc/meminfo | awk '{print $2}')
	#search for MemTotal in /proc/meminfo file and the convert the value in 2nd column corresponding to memtotal to GB and printing it
	echo "The Total Available Memory is $Avl_Mem KBs"
	echo "The Total Available Memory is $Avl_Mem KBs " $(date) >> $log #will store the results with datetime of execution of this task.

elif [ $Task_num -eq 2 ] #if user entered to perform task 2
then
        Avl_Stor=$(df -m | awk 'NR>1 {print "Total Storage Space in Mount " $6 " is " $4 "MBs"}')
	#used -m on df to show storage space in mbs, NR >1 to remove first row header
        echo -e "The Total Available Storage for each mount is the followings\n$Avl_Stor"
	echo -e "The Total Available Storage for each mount is the followings\n$Avl_Stor "$(date) >> $log

elif [ $Task_num -eq 3 ] #if user entered to perform task 3
then
	users=$(ps -Ao user | awk 'NR>1' | sort -u )
	echo "Please enter the User Name from following list to display top 5 process of that user"
	echo -e "$users"
        read username
	echo "User name entered was $username" >> $log
	#then
	user_proc=$(ps -Ao user,uid,comm,pid,pcpu,tty --sort=-pcpu|awk -v us=$username '$1 == us' | head -n 6 )
	#query above could also be run in line 18 where users are being stored this could have saved run time but if a process is started/stopped while entering username if wouldn't have shown here

	echo "$user_proc"
	echo "$user_proc" $(date) >> $log
	#else
	#echo "Enter a valid username"

elif [ $Task_num -eq 4 ]
then
	Listen_ports=$(sudo netstat -lntup | awk '{print $4, $NF}')  #sudo to access as root, l to display only listening sockets t: display tcp connection, n to display addresses in a numerical form, p to display process ID/ Program name
	#Ports with state listen had programid in column 7 and ports without any state had programid in column 6, I used NF which takes last column value
	echo -e "List of listening ports with their program ID and Name\n$Listen_ports"
	echo '$Listen_ports' >> $log


elif [ $Task_num -eq 5 ] #if user entered to perform task 5
then
	echo -e "Enter 1 to just clear Page Cache Only\nEnter 2 to just clear inodes and dentries\nEnter 3 to clear Page Cache, inodes and dentries"
	read CMC_option
	echo "Clear cache option selected by user was $CMC_option" >> $log
	if [ $CMC_option -eq 1 ] #if user wants to cleat only page cache
	then
		sudo sh -c 'echo 1 >/proc/sys/vm/drop_caches'
		echo "Page Cache Cleared"
		echo "Page Cache Cleared " $(date) >> $log
		#Page cache is stored by OS in memory from device storage so it doesn't have to access storage again for it
        elif [ $CMC_option -eq 2 ] #if user wants to clear inodes and dentries
        then
                sudo sh -c 'echo 2 >/proc/sys/vm/drop_caches'
		echo "inodes and dentries Cleared"
                echo "inodes and dentries Cleared " $(date) >> $log
		#inodes cache represents files

	elif [ $CMC_option -eq 3 ] #if user wants to clear both cahces
        then
                sudo sh -c 'echo 3 >/proc/sys/vm/drop_caches'
		echo "Page Cache, inodes and dentries Cleared"
                echo $(date) "Page Cache, inodes and dentries Cleared" >> $log
		#dentries cache respresents folders/directories
	else #if invalid number or option entered
		echo "Entered an invalid Option number"
	fi

elif [ $Task_num -eq 6 ] #if user entered to perform task 6
then
	echo -e "Enter the directory you want parse"
	read directry
	echo "Directory entered was $directry" >> $log
	list_of_files=$(ls --block-size=M -laS $directry | awk  '$1 ~ /^[-,b,c,l,d,n,p,s]/' | awk ' {print $9, $5}')
	#it will also work if you remove the regular expression, it is just to get valid files and in case you want to include to exclude some type (details are mentioned below)
#--block-size=M will show file size in MBs, a in -laS is for getting all files including files starting with . and S is to sort them by file size
	echo -e "Following files are in the directory with respective size in MBs and sorted in decending order\n$list_of_files"
	echo -e "$list_of_files " $(date) >> $log

#Notes
#- - Regular file
#b - Block special file
#c - Character special file
#d - Directory
#l - Symbolic link
#n - Network file
#p - FIFO
#s - Socke
#Above regular expression can be changed to get files of each type accordingly

#~ tells awk to do a RegularExpression match /..../ is a Regular expression.
#Within the RE is the alphabet and the special character ^.
#^ causes the RE to match from the start (as opposed to matching anywhere in the line).

elif [ $Task_num -eq 7 ] #if user entered to perform task 7
then
        echo -e "Enter the directory you want parse"
        read directry
	echo "Directory entered was $directry" >> $log
        list_of_files=$(ls --block-size=M -laS /lib/ | awk  '$1 ~ /^d/' | awk ' {print $9, $5}')
        echo -e "Following files are in the directory with respective size in MBs and sorted in decending order\n$list_of_files"
	echo -e "$list_of_files " $(date) >> $log

else
	echo "You have entered an inValid Number"
fi

echo "-------------------------------------------------" >> $log


