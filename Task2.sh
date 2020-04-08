
today=`date +%Y-%m-%d.%H:%M:%S` #get current Date Time
dir=logs/$today  #directory where logs will be stored
log=${dir}_log_file.txt #adding date at start of each log file to create sperate log file for each execution

echo "Program was executed at datetime " $(date) >> $log # >> $log will store the line in log file defined above
echo "-------------------------------------------------" >> $log
echo "-------------------------------------------------"

Avl_Mem=$(grep MemTotal /proc/meminfo | awk '{print $2/1024/1024}')  #search for MemTotal in /proc/memunfo file and the convert the value in 2nd column corresponding to memtotal to GB and printing it


echo "The Total Available Memory is $Avl_Mem GBs"
echo "The Total Available Memory is $Avl_Mem GBs " >> $log
echo "-------------------------------------------------" >> $log
echo "-------------------------------------------------"
Avl_CPUs=$(grep -c ^processor /proc/cpuinfo) #get information from cpuinfo file search (use grep) for line starts with(use ^) processor and count lines (using -c)
echo "The Total Available CPUs are $Avl_CPUs"
echo "The Total Available CPUs are $Avl_CPUs" >> $log
echo "-------------------------------------------------" >> $log
echo "-------------------------------------------------"

Avl_Stor=$(df -m | awk 'NR>1 {print "Total Storage Space in Mount " $6 " is " $4 "MBs"}') #used -m on df to show storage space in mbs
echo -e "The Total Available Storage for each mount is the followings\n$Avl_Stor"
echo -e "The Total Available Storage for each mount is the followings\n$Avl_Stor " >> $log
echo "-------------------------------------------------" >> $log
echo "-------------------------------------------------"

Listen_ports=$(sudo netstat -lntup | awk '{print $4, $NF}')
#Ports with state listen had programid in column 7 and ports without any state had programid in column 6, I used NF which takes last column
echo -e "List of listening ports with their program ID and Name\n$Listen_ports"
echo '$Listen_ports' >> $log
echo "-------------------------------------------------"

user_proc=$(ps -Ao user,uid,comm,pid,pcpu --sort=-pcpu|awk '$1 == "root"' | head -n 6 ) #get  process status with column mentioned sperated by , then sort them by pcpu (% CPU been used) in decending order and use head to get top 5. header will be moved down when its sorted
echo "${user_proc}"
echo "${user_proc}" >> $log
echo "-------------------------------------------------" >> $log
echo "-------------------------------------------------"



echo $pat >> $log
list_of_files=$(ls --block-size=M -laS | awk  '$1 ~ /^[-,b,c,l,n,d,p,s]/' | awk ' {print $9, $5}')  #it will also work if you remove the regular expression, it is just to get valid files and in case you want to include to exclude some type (details are mentioned below)
#--block-size=M will show file size in MBs, a in -laS is for getting all files including files starting with . and S is to sort them by file size
echo -e "Following files are in the directory with respective size in MBs and sorted in decending order\n$list_of_files"
echo -e "$list_of_files " >> $log
echo "-------------------------------------------------" >> $log
echo "-------------------------------------------------"
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

list_of_files=$(ls --block-size=M -laS /lib/ | awk  '$1 ~ /^d/' | awk ' {print $9, $5}') #will only get files with type starting with d i.e for folders/directories
echo -e "Following files are in the directory with respective size in MBs and sorted in decending order\n$list_of_files"
echo -e "$list_of_files ">> $log

echo "-------------------------------------------------" >> $log
echo "-------------------------------------------------"

