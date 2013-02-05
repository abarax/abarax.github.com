Date: 2013-01-22
Title: PUSH EBP  MOV ESP,EBP
Category: Blog
Tags: blogging

# About me #

Hi, I'm Leigh and this is my blog. I am a professional programmer, enthusiast hiker, serial hobbyist and avid gamer.  This is a place for me to document things I've learned or am interested in, explore new ideas, write-up interesting case studies, side-projects and hopefully much more.

# Why a blog? #

Over the last few years I have engaged in a number of extra-curricular activities, beyond my regular work duties.  This usually involves late nights filled with reading, coding and even soldering. Up until now I had never thought to share these endeavors but I feel like it could be a great opportunity to share and learn new things as well as meet like-minded people.

# What to expect #

As a self-professed serial hobbyist you can expect that the topics I blog about will be as diverse as they are - hopefully, interesting.  For the most part they will involve topics related to programming, security, data analysis, algorithms, arduino and many others.

Without further adieu, I thought I'd leave you with a morsel of knowledge I have picked up durting the last year, that might help beginners. A topic I have been researching heavily lately is that of Information Security. Specifically I have been researching reverse engineering, malware analysis and software exploitation.  You may have noticed the title of this introductory blog post looks a bit strange: 

	push ebp
	mov  esp, ebp

It looks strange because it is a snippet of Assembly language, but not just any assembly language, it is the standard entrance for a function that many compilers will generate. This is useful knowledge when using an assembler debugger such as OllyDbg, WinDbg or GDB to identify program or function entry points.

As an example, the following C code snippet:

	void foo()
	{
	  int bar;
	}

will begin with the following Assembly code:

	_foo
	  push ebp
	  mov  esp, ebp
	  sub  esp, 4

_note: The sub esp, 4 line will allocate space on the stack for the 'bar' variable._

This piece of assembly follows the form _opcode destination, source_

One of the things that can be confusing with this concept, is that this will not always be the case. Depending on your operating system, the architecture, the compiler used and even the flags passed in to the compiler the assembly code could also look like this:

	push %ebp
	move %ebp, %esp
	sub  0x04, %esp

This is typical of the AT&T syntax used in GNU AS and will be used on Unix-like systems. It follows the format _opcode source, destination_


An absolutely amazing resource for more information on this (and much more) is located in this free [wiki book](https://en.wikibooks.org/wiki/X86_Disassembly/Functions_and_Stack_Frames)


