#!/bin/bash
#             _____  ______            __ _   
#       /\   |  __ \|  ____|          / _| |  
#      /  \  | |__) | |__   ___  ___ | |_| |_ 
#     / /\ \ |  _  /|  __| / __|/ _ \|  _| __|
#    / ____ \| | \ \| |____\__ \ (_) | | | |_ 
#   /_/    \_\_|  \_\______|___/\___/|_|  \__|
#                   | |     | |               
#    _   _ _ __   __| | __ _| |_ ___ _ __     
#   | | | | '_ \ / _` |/ _` | __/ _ \ '__|    
#   | |_| | |_) | (_| | (_| | ||  __/ |       
#    \__,_| .__/ \__,_|\__,_|\__\___|_|       
#         | |                                 
#         |_|                                 
#
#   by xanda
#   https://github.com/xanda/AREsoft-updater
#
# version: 0.1
# release date: 25 August 2012
# changelogs:
#   * 0.1 - 25 August 2012 - Initial release
#
# WTFPL - Do What The Fuck You Want To Public License
# ===================================================
# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The Fuck You Want
# To Public License, Version 2, as published by Sam Hocevar. See
# http://sam.zoy.org/wtfpl/COPYING for more details.


#========
# Header
#========

echo ""
echo "AREsoft-updater v0.1 by xanda"
echo "https://github.com/xanda/AREsoft-updater"
echo ""
echo ""



#================
# Check for curl
#================

whichCurl=`which curl`

if [ "$whichCurl" != "/usr/bin/curl" ];
then
   echo "===============ERROR================"
   echo " ERROR! curl is not installed"
   echo " Please install curl by typing:"
   echo "    sudo apt-get install curl" 
   echo "===============DONE=================" && exit 1
fi



#===================
# Update androguard
#===================

echo "===================================="
echo "Checking androguard for new update"
cd ~/tools/androguard/
hg pull && hg update
echo "===============DONE================="
echo ""



#=====================
# Update apkinspector
#=====================

echo "===================================="
echo "Checking apkinspector for new update"
echo "kindly ignore 'No such file or directory' warning"
cd ~/tools/apkinspector/
isGit=`ls .git | wc -l`
if [ "$isGit" == "0" ];
then
   echo "Migrating to the new Git repo"
   cd ~/tools/
   rm -rf apkinspector/
   git clone https://code.google.com/p/apkinspector/
fi
cd ~/tools/apkinspector/
git pull
echo "===============DONE================="
echo ""



#=====================
# Update AXMLPrinter2
#=====================

echo "===================================="
echo "Checking AXMLPrinter2 for new update"
cd ~/tools/axmlprinter
md5AXMLPrinter2_local=`sha1sum AXMLPrinter2.jar | cut -d ' ' -f 1`
md5AXMLPrinter2_remote=`curl -s "http://code.google.com/p/android4me/downloads/detail?name=AXMLPrinter2.jar" | grep SHA1 | cut -d ' ' -f 7`

if [ "$md5AXMLPrinter2_local" != "$md5AXMLPrinter2_remote" ];
then
   echo "Update found! Updating..."
   rm AXMLPrinter2.jar
   wget http://android4me.googlecode.com/files/AXMLPrinter2.jar
fi
echo "===============DONE================="
echo ""



#================
# Update apktool
#================

echo "===================================="
echo "Checking apktool for new update"
cd ~/tools/apktool
currentApktool=`java -jar apktool.jar | grep "Apktool v" | cut -d ' ' -f 2 | sed 's/v//g'`

newerApktool=`curl -s http://code.google.com/p/android-apktool/downloads/list | grep apktool | grep -v -E '\-install\-' | grep 'android-apktool.googlecode.com/files' | cut -d '"' -f 2 | sed 's/\/\///g' | grep -v $currentApktool`

if [ "$newerApktool" != "" ];
then
   echo "Update found! Updating..."
   rm apktool.jar
   wget $newerApktool
   tar xjf *.tar.bz2
   rm *.tar.bz2
fi
echo "===============DONE================="
echo ""



#============
# Update ded
#============

echo "===================================="
echo "Checking ded for new update"
cd ~/tools/ded
latestDed=`curl -s http://siis.cse.psu.edu/ded/downloads.html | grep 'downloads/linux/ded-' | grep -v launcher | cut -d '"' -f 2 | cut -d '/' -f 3`

#get jasmin latest version
latestJasmin=`curl -s http://siis.cse.psu.edu/ded/downloads.html | grep 'downloads/jasminclasses-' | cut -d '"' -f 2 | cut -d '/' -f 2`

Ded=`ls $latestDed`
Jasmin=`ls $latestJasmin`

if [ "$Ded" != "$latestDed" ];
then
   echo "Update found! Updating ded..."
   delDED=`ls | grep ded- | grep -v ded-script`
   rm $delDED
   dedURLs=`curl -s http://siis.cse.psu.edu/ded/downloads.html | grep -E 'ded-|ded-launcher-' | grep -v -E 'Mac|ded-script' | cut -d '"' -f 2 | sed 's/downloads/http:\/\/siis.cse.psu.edu\/ded\/downloads/g'`
   wget $dedURLs
fi

if [ "$Jasmin" != "$latestJasmin" ];
then
   echo "Update found! Updating jasminclasses..."
   rm jasminclasses-*
   jasminURL=`curl -s http://siis.cse.psu.edu/ded/downloads.html | grep -E 'jasminclasses' | cut -d '"' -f 2 | sed 's/downloads/http:\/\/siis.cse.psu.edu\/ded\/downloads/g'`
   wget $jasminURL
fi
echo "===============DONE================="
echo ""



#===============
# Update dex2jar
#===============

echo "===================================="
echo "Checking dex2jar for new update"
cd ~/tools/dex2jar/
latestdex2jarURL=`curl -s http://code.google.com/p/dex2jar/downloads/list | grep "dex2jar.googlecode.com" | grep -v ".zip" | cut -d '"' -f 2 | sed 's/\/\///g'`
latestdex2jar=`echo $latestdex2jarURL | cut -d '-' -f 2 | sed 's/.tar.gz//g'`
localdex2jar=`bash d2j-dex2jar.sh | grep version | cut -d ',' -f 2 | cut -d '-' -f 2`
if [ "$localdex2jar" != "$latestdex2jar" ];
then
   echo "Update found! Updating..."
   cd ..
   rm -rf dex2jar
   wget $latestdex2jarURL
   tar xfz dex2jar*.tar.gz
   rm dex2jar*.tar.gz
   mv dex2jar-* dex2jar
fi
echo "===============DONE================="
echo ""



#==============================
# Update Droidbox & APIMonitor
#==============================

echo "===================================="
echo "Checking Droidbox for new update"
echo "Unable to detect local installed version of Droidbox and APIMonitor."
read -p "Update anyway? (y/n)"
[[ "$REPLY" == [yY] ]] && {
   latestDroidboxURL=`curl -s https://code.google.com/p/droidbox/downloads/list | grep "droidbox.googlecode.com" | grep DroidBox | cut -d '"' -f 2 | sed 's/\/\///g' | head -1`
   latestAPIMonitorURL=`curl -s https://code.google.com/p/droidbox/downloads/list | grep "droidbox.googlecode.com" | grep APIMonitor | cut -d '"' -f 2 | sed 's/\/\///g' | head -1`

   cd ~/tools/
   rm -rf droidbox

   wget $latestDroidboxURL
   tar xfz DroidBox*.tar.gz
   rm DroidBox*.tar.gz
   mv DroidBox* droidbox

   wget $latestAPIMonitorURL
   tar xfz APIMonitor*.tar.gz
   rm APIMonitor*.tar.gz
   mv APIMonitor* droidbox/
}
echo "===============DONE================="
echo ""



#==============
# Update smali
#==============

echo "===================================="
echo "Checking smali for new update"
cd ~/tools/smali
localsmali=`java -jar smali*.jar -v | grep smali | cut -d ' ' -f 2`
latestsmali=`curl -s http://code.google.com/p/smali/downloads/list | grep smali.googlecode.com | grep .jar | cut -d '"' -f 2 | head -1 | cut -d '-' -f 2 | sed 's/.jar//g'`
latestsmaliURL=`curl -s http://code.google.com/p/smali/downloads/list | grep smali.googlecode.com | cut -d '"' -f 2 | sed 's/\/\///g'`

if [ "$localsmali" != "$latestsmali" ];
then
   echo "Update found! Updating..."
   rm *
   wget $latestsmaliURL
fi
echo "===============DONE================="
echo ""



#==============================
# Check PATH for platform-tools
#==============================

pathPlatformTools=`cat /home/android/.bashrc | grep platform-tools`
if [ "$pathPlatformTools" == "" ];
then
   echo "===================================="
   echo "Android SDK platform-tools is not in yout PATH"
   echo "Patching your .batchrc ..."
   echo "export PATH=\${PATH}:/home/android/tools/android/android-sdk-linux_x86/platform-tools" >> /home/android/.bashrc
   echo "===============DONE================="
   echo ""
fi
