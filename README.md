# bundletool-script

Build application to connected-devices by using bundletool.
Current version of bundletool: 1.15.1

## Before you use
Checkout the ```installation``` branch to get [installation.sh](https://github.com/dzungvu/bundletool-script/tree/installation) file. Then run the file to setup tool atomatically

Or run the manual setup

## Manual setup
- Checkout for the compatible branch (```linux```/```mac-arm```/```mac-x86_64/windows```)
- Unzip the modules and naming the extracted-file as ```modules``` in the same directory with ```modules.zip``` file:
  - mac: ```bundletool-script/jdk-17.0.7.jdk/Contents/Home/lib/modules.zip```
  - linux/windows: ```bundletool-script/jdk-17.0.7/lib/modules.zip```

## How it work
- Run the ```genApks.sh``` file
- If there was ```permission deined``` error, run ```chmod +x genApks.sh``` to allow this file run as a program
- After run success, it requires you to input the ```.aab``` or ```apks``` file.
- With ```.aab``` file, you will be required to have a keystore file for signing this aab. For this version, it's only looking for your debug keystore. If it could not find any keystore file, then stop working.
- With ```.apks``` file, it will automatical install the application to your device if only 1 device connects to PC. In case more than 1 device, you can select to install to all of your devices or pick 1 device from the list by passing the device's index
