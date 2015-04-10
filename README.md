#Squid TWRP tree for Moto E 3G (2015)
* Based off https://github.com/cybojenix/android_device_motorola_surnia
* Kernel headers taken from https://github.com/MotorolaMobilityLLC/kernel-msm/tree/lollipop%E2%80%945.0.2-release/include
* Kernel zImage and dt.img taken from stock otus boot.img for 5.0.2

##Dependencies:
(you probably don't need most of these)
````
sudo apt-get install bison build-essential curl flex git gnupg gperf libesd0-dev liblz4-tool libncurses5-dev libsdl1.2-dev libwxgtk2.8-dev libxml2 libxml2-utils lzop openjdk-6-jdk openjdk-6-jre pngcrush schedtool squashfs-tools xsltproc zip zlib1g-dev
sudo apt-get install g++-multilib gcc-multilib lib32ncurses5-dev lib32readline-gplv2-dev lib32z1-dev
````
You also need the repo tool for cloning Android source trees.

##Set up the repo:
````
mkdir ~/omni-twrp-tree
cd ~/omni-twrp-tree
repo init -u https://github.com/sultanqasim/twrp_recovery_manifest.git -b android-5.1
mkdir -p .repo/local_manifests
````

Create file .repo/local_manifests/styx.xml
````
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
    <project name="cybojenix/android_device_motorola_surnia" path="device/motorola/surnia" remote="github" revision="android-5.0" />
    <project name="sultanqasim/android_device_motorola_otus" path="device/motorola/otus" remote="github" revision="android-5.0" />
</manifest>
````

Now get the repo:
````
repo sync
````

##Building:
````
source build/envsetup.sh
lunch omni_otus-userdebug
make installclean
make -j10 recoveryimage
````
Replace omni_otus-userdebug with omni_surnia-userdebug if you want to build a surnia recovery instead.
