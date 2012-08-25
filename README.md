AREsoft-updater
===============

Updater script for Android Reverse Engineering Software belongs to ARE VM from the Honeynet Project

The Android Reverse Engineering (A.R.E.) Virtual Machine, combines the latest Android malware analysis tools in a readily accessible toolbox.

Tools currently found on A.R.E. are:

* Androguard
* Android sdk/ndk
* APKInspector
* Apktool
* Axmlprinter
* Ded
* Dex2jar
* DroidBox
* Jad
* Smali/Baksmali

A github repo created by the A.R.E maintainer ( https://github.com/hannoL/AREsoft ) for easy installation and update, however the rapid development of each individual project does not sync with the update of the A.R.E github repo. This is why AREsoft-updater was created.

AREsoft-updater will check for the latest available version of each individual project/tool listed above and compare it with the local (installed) version in A.R.E. If newer version is available, AREsoft-updater will automatically download and install the update for your A.R.E

AREsoft-updater will require curl to work. Kindly install curl in your A.R.E virtual machine by typing sudo apt-get install curl

AREsoft-updater is released under WTFPL (Do What The Fuck You Want To Public License) http://sam.zoy.org/wtfpl/