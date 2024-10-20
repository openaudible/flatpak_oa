# flatpak_oa
Building a flatpak for OpenAudible

This is the script that will build a flatpak for openaudible. It is in progress.

To test, run ./test.sh which gets the latest version (or beta) 

Current issues: 
* The scalable .svg image does not appear to work-- (tested on Mint.) Added the 512x512.png image and that works.
* running flatpak install OpenAudible*.flatpak asks for a password. Not sure why, but obviously would prefer no password.
* Need to gpg-sign
* Check build arguments -- make sure we know what they do (repo flag?) 
* Need to test and if it makes sense, upload to one or more repositories

OpenAudible uses sound (for audiobook player), dbus (for desktop app stuff using Eclipse SWT), and libwebkit2gtk-4.1-0.

Needs testing, checks for best practices, naming convention (with version or without?), updating instructions for when the version changes.

Also looking for submission guidance for different software repos. 

I would like this to work as a github action or via Docker so I can run remotely after a build has been released. 

I also have a snap build that needs fixing..  
