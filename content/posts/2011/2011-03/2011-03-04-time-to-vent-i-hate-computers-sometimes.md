---
title: "Time to Vent: I hate computers, sometimes"
date: 2011-03-04
slug: time-to-vent-i-hate-computers-sometimes
excerpt: "First of all, I LOVE LOVE LOVE my Mac! I will NEVER buy another Windows PC. Nope. Replaced all our"
categories: ["Technology Corner"]
tags: ["Activity Monitor","Backup","Corrupt Backup","Mac Computer","Restore","Time Capsule","Time Machine"]
author: Stef
image: /images/2011/2011-03/2011-03-04-time-to-vent-i-hate-computers-sometimes-featured.png
published: true
---
![Time to Vent](/images/2011/2011-03/2011-03-04-time-to-vent-i-hate-computers-sometimes-img-1.png "Time to Vent")First of all, I LOVE LOVE LOVE my Mac! I will NEVER buy another Windows PC. Nope.

Replaced all our computers with Macs. My mom was sick of Vista and she now has a Mac. My sister-in-law bought a Mac a year ago. Wish my brother and sister-in-law (you know who you are) would buy one, too. 😉 Wish I could win the lottery and buy all my immediate family members (you, too Ma) Macs, but well… you have to buy a lottery ticket to win. LOL!

I’ve had my Macbook Pro for three years. My Mac is an appendage… I feel naked without it. 😳 When I first got it there was a defect on screen, but didn’t want to let go of it for a week… remember… it’s an appendage!

Well, my AppleCare (extended support) was ending so I knew I HAD to take it in… I took it in back in December, but was sick so I couldn’t take it back. They had ordered the replacement part and were going to fix it at the store. The most I’d be without would be 1-2 days… So last Saturday I took it to The Apple Store and sure enough they had to send it to the “depot” for repairs because the screen manufacturer is going out of business and the stores weren’t allowed to order parts.

Well… it got it back today! YIPEEEEE! The enclosed form stated that not only did they replace the screen, they replaced the top case, bottom case, keyboard and hard drive. Cool, right? Just wait…

I thought to myself, “replaced the hard drive”… No problem, you have your _[Time Capsule](http://www.apple.com/timecapsule/)_ with your _[Time Machine](http://www.apple.com/macosx/what-is-macosx/time-machine.html)_ backups on it… no worries… NOT. 😥

I tried THREE times to get the restore to work… 😡 it worked a week and a half ago when I did a test run… It gets to 2 minutes from being done and HANGS! What the heck!

Then when I tried to open the backup file (which I have done more times than I can think) it wouldn’t open! DANG DANG DANG!

I cried… _The Offspsring_ hugged me and said, “_I’m sorry, Mami._” Her hugs and kisses helped. She inspired me to go take yet another look. I logged into _Hubby’s_ computer and tried to do some investigation…

So I started comparing the backup (sparsebundle) files… A sparesbundle is a collection of files that Mac OS X puts it’s Time Machine backups into. _Hubby_ and _The Offspring’s_ are about less than 250GB in size…

Mine is 798.58GB! Yep, almost a terabyte. For those who aren’t sure what a terabyte is it is one trillion characters… in a nutshell… **it’s BIG**.

![](/images/2011/2011-03/2011-03-04-time-to-vent-i-hate-computers-sometimes-img-2.png "DiskActivity")It was quiet in the loft area and I heard what sounded like “hard disk activity”. So, I started looking around to see if it was actually doing something… sure enough… when I ran the Activity Monitor (found under Applications in the Utilities sub-folder) and click on the “Disk Activity” I saw something… a bouncing green line…

There _IS_ something going on… unfortunately it is VERY SLOW… After two hours it is only at 14.36 GB (a gigabype is a billion characters)… it has a _LONG_ way to go.

I have said my prayers… I hope I can figure out what is causing the problem… I have my suspicions… When I was preparing to take it in last Saturday I ran the backup and it was taking forever and I was going to miss my appointment (it has been two hours for 74MB) so I just “screw it” and shutdown my computer. For future reference… DO NOT DO WHAT I DID!!!!

I suspect there is a file inside the “sparsebundle” that is from the _partial backup_ and it just needs to be deleted. NOTE: do not do this if you don’t know what you are doing!

I will give you an update as soon as the file loads… it may be next year at this rate! LOL… NOT!

As my post title says, “I hate computers, sometimes.” Want to know something extremely ironic… I work in the _Information Technology_ (IT) department at my company… I’m surrounded by computers all day! To make it worse… they’re those ICKY Windows computers. LOL!!

_So, do you have any computer horror stories?_  
![signature](/images/Signature-Pink36ptFaceTransparent.png)