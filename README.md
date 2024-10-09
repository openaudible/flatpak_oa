# flatpak_oa
Building a flatpak for OpenAudible

This is the script that will build a flatpak for openaudible. It is in progress.

To test, run ./test.sh which gets the latest version of OpenAudible. 

OpenAudible uses sound (for audiobook player), dbus (for desktop app stuff using Eclipse SWT), and libwebkit2gtk-4.1-0.

Needs testing, checks for best practices, naming convention (with version or without?), updating instructions for when the version changes.

Also looking for submission guidance for different software repos. 

I would like this to work as a github action or via Docker so I can run remotely after a build has been released. 

I also have a snap build that needs fixing..  
