Date: 2012-01-26
Title: GSS Con 2012 DFIR Challenge Part Two
Category: Security
Tags: Security, DFIR, Wireshark


Lets jump straight in and pick up where we left off with question six.

**Question 6. What is the mutex the backdoor is using?**

First of all, what is a mutex? If you have had any computer science or programming experience you may have heard about a mutex. Mutex stands for mutual exclusion and in the context of malware or executables in general it is a mechanism for ensuring that only one version of the program can be running at once.

Since the entire point of doing this challenge was to learn about the volatility framework lets attempt to use it to solve this question.  The docs for [Volatility](https://code.google.com/p/volatility/wiki/CommandReference22) are quite well written, doing a quick find on the page for 'mutex' points us in the direction of the 'handles' command and the 'mutantscan' command.

Running the command:

	>python vol.py -f memdump.img mutantscan --silent

This shows up a number of mutants which is going to be hard to sift through. I could google the name of each one to figure out where it came from.  Lets try the other command:

	>python vol.py -f memdump.img handles -t Mutant

There are too many entries here to filter down as well.  But this command does provide process ID's so the key will be determining which process the malware is running in.

Lets have a look at some other Volatility commands and see if we can't determine which one is hosting the malware. Browsing through the numerous commands and taking in to account the information we already know about. We do know the command and control server IP and there is a command under the networking category called 'connections'. Lets try that.

	>python vol.py -f memdump.img connections

This results in the following:

	 Offset(V)  Local Address             Remote Address            Pid  
	---------- ------------------------- ------------------------- ------
	0x8201ce68 172.16.150.20:1365        172.16.150.10:139              4
	0x82018e00 172.16.150.20:1424        221.54.197.32:443           1096

This at least lets us know the process id that the malware is hiding in. Lets check out what process that is by running the 'pslist' command.

	>python vol.py -f memdump.img pslist | grep 1096

It's 'explorer.exe'!! Lets use that to filter one of the other commands to find the mutex. The -p flag will filter the handles command by process id.

	>python vol.py -f memdump.img handles -t Mutant -p 1096

This reduces our list considerably, 13 in fact. A quick google of each of these reveals that the malware is using the mutant **')!VoqA.I4'**. Looking over the google results, I realise I could have just googled the malware 'poison ivy' to determine this fact.  Fortunately for us we garnered a lot of new information during this process.

**Question 7. Where is the backdoor placed on the filesystem?**

This one sounds tricky. We have a pcap, a memory image and a file system timeline. I would say the whereabouts of the backdoor will either be in the memory image or the file system timeline.

Looking through the Volatility command docs I don't see much I can use to find this, I tried memdump and handles to no avail. Lets try the memory image. I got stuck here for a while, a grep for the swing-mechanics doc showed up nothing until I used the -i flag to make the search case insensitive. Looking below this entry, in the compromised.timeline, I noticed something strange a file called svchosts.exe. 

After staring at the pslists and psscans for a while this stuck out because the file listed in all those process commands is called 'svchost.exe', in fact googling for 'svchosts.exe' refused to show results for anything but 'svchost'. What confirms it for sure though is the 'Entry Type' column of the 'compromised.timeline'. It reads 'm..b' which means that the file was both born and modified at this time, a little strange for what is a windows system process which should have been born when the OS was installed.

After this I see a lot of network related utilities being used which does seem odd. Finally after this a directory called 'c:/WINDOWS/system32/systems' is created and a total of four .exe files are created and added to this directory.

It looks like the 'svchosts.exe' is the malware, hopefully this is enough to answer question 7.


**Question 8. What process name and process id is the backdoor running in?**

Luckily we found this out earlier when determining the mutex.  We used the Volatility tool to uncover this and the answer is 'explorer.exe' and 1096.

**Question 9. What additional tools do you believe were placed on the machine?**

I believe the answer to this I determined in question 7. The additional tools were 'g.exe', 'p.exe', 'r.exe' and 'sysmon.exe'.  To determine exactly what these tools do would require further analysis but my hunch is that they are copies of the malware itself or utilities that it uses.. This could be confirmed using hashes but we need a way to get the files.

**Question 10. What directory was created to place the newly dropped tools?**

We also found this our earlier, it is 'c:/WINDOWS/system32/systems'

Well we have made it to the half way point, stay tuned for the next installment.
