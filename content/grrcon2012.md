Date: 2012-01-25
Title: GRR Con 2012 DFIR Challenge Part One
Category: Security
Tags: Security, DFIR



DFIR I hear you say? What on earth is it I hear you say? 

DFIR stands for 'Digital Forensics and Incident Response'. It is a subset of the IT Security discipline that deals mostly with the analysis of attacks by malware or hackers after the fact. It uses a number of different techniques and tools including pcap analysis, file system log analysis and any change or impact on the target operating system and network. Although there are too many tools to name in DFIR trade, the ones I will be exploring mostly in this pose are Wireshark, Volatility, Strings and Foremost.

So how did we get here?

Due to my recent interest in all things security I was testing a very popular memory analysis framework called 'Volatility'.  Volatility is an open source memory analysis tool written in Python and you can check it out [here](http://code.google.com/p/volatility). While checking out the project I discovered some sample memory images for testing the tool.  One in particular caught my eye, the [GrrCon forensic challenge ISO](http://t.co/m0JCvrnV).

This looked like a great opportunity not only because it had the words 'forensic challenge' in them but also because it came with a list of questions to test out your skills. I found the list of questions [here](http://michsec.org/wp-content/uploads/2012/10/GrrCON-Questions.txt)

So with what little experience I have, lets get stared.

**Question 1. How was the attack delivered?**

Lets start with taking inventory of what we have.  On the ISO we have a memory dump, a pcap file and a file system timeline. In all likely hood the attack came in via the network some how. So the first spot to look might be the pcap file. Having said that the attack could also have been delivered via USB which may show up on the file system timeline or the memory dump. But lets just start with the pcap file.

A very popular method for malware to find its one on a system is via a corrupt pdf, word doc, exe or zip file.  So my first step is to use the very useful 'strings' utility to see if these words exist in the file.  I do this by running the following command:
	
	>strings out.pcap | grep "pdf\|doc\|exe"

This results in something very interesting showing up:
	
	GET /tigers/BrandonInge/Diagnostics/swing-mechanics.doc.exe HTTP/1.1
	exporer.exe
	svchosts.exe
	exporer.exe

I am going to go out on a limb and say that the swing-mechanics.doc.exe looks extremely suspicious and is likely our culprit.

**Question 2. What time was the attack delivered?**

In order to check this we are going to fire up wireshark and apply a filter based on the http request uri above. We can do this by entering the following to the filter text box:
	
	http.request.uri contains "swing-mechanics"

Doing this brings up the full packet details and checking the packet arrival time results in this 

	APR 28, 2012 12:00:59.2562

**Question 3. What was the name of the file that dropped the backdoor?**

We have already uncovered this above. The filename was swing-mechanics.doc.exe

**Question 4. What is the IP address of the C2 server?**

First of all, what is a C2 server? A C2 server is a command and control server that malware uses to take directives and report information. Probably the best way to determine this is to browse the pcap log in wireshark around the time that the malware was delivered.

Previous to the file being delivered to the system only two IP's are mentioned 172.16.150.20 and 66.32.119.38 and after the file was delivered a new TCP connection was made to this address 221.54.197.32 This is likely our C2.

**Question 5. What type of backdoor is installed?** 

When I first looked at this I thought the best approach would be to pull out the exe from the pcap file using Wireshark. 

You can do this by right clicking on the HTTP GET for the swing-mechanics.exe and selecting follow TCP Stream. This will bring up a dialog box displaying the HTTP conversation between the clinet and the server. Since the client is the victim, we are only interested in what the server sent us (the malware itself). We can filter out the client traffic by selecting from the drop down box just the information from the server.

Once this is done select 'RAW' as the format and hit 'Save As'. I saved mine as 'malware.raw'. This will save just the data that came from the server i.e. swing-mechanics.doc.exe. note: When you look at the raw data you can also see the famous 'MZ' signifying the start of a .exe file.  

This binary file still includes a lot of the HTTP protocol information, in order to extract the exe from this file we can use a tool called 'foremost'. Foremost is a tool which was designed to extract certain file types from binary blobs of data. In this case it is an exe but it could also be something else, check the man pages for more details. To do this, run this command:
	
	>foremost -t exe malware.raw

Now that we have the exe we can run it through a malware analysis program. Lets use [Virus Total](www.virustotal.com) a free online virus analyzer.  The site seems to have determined it to be **Poisonivy** or some variant.

In the interest of keeping these posts digestible, I'll stick to five questions per post. We'll pick up with question six in the next post.

Read [Part Two](|filename|grrcon2012-2.md) here
