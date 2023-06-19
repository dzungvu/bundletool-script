#!/bin/bash

# Text color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No color

auto=0

# Function to display script usage
show_help() {
  echo -e "${GREEN}Usage: scriptname [options]${NC}"
  echo -e "${GREEN}Options:${NC}"
  echo -e "${GREEN}  -h, --help		Display this help message${NC}"
  echo -e "${GREEN}  -i, --info		Get tool's info${NC}"
}
	
# Function main()
main() {
	if [ $1="auto" ]
	then
		auto=1
	else
		auto=0
	fi
	
	read -p "Please enter path to aab/apks file: " origin_file_path
	# Trim and remove single quote characters
	file_path=$(echo "$origin_file_path" | xargs | sed "s/'//g")
	if [[ "$file_path" == *.aab* ]]
	then
		processAabFile "$file_path"
	else
		if [[ "$file_path" == *.apks* ]]
		then
			processApksFile "$file_path"
		else
			echo -e "${RED}Can not recognize file extension. Make sure your input file ended with .aab or apks${NC}"
		fi
	fi
}

processAabFile() {
	file_path=$1
	echo "file path = $file_path"

	# Extract the directory path and base name of the file
	dir_path=$(dirname "$file_path")
	base_name=$(basename "$file_path")

	# New file extension: apks
	new_extension="apks"

	# Change the file extension
	new_file_name="${base_name%.*}.$new_extension"
	new_file_path="$dir_path/$new_file_name"

	# Check and delete if the target output file exist
	if [ -f "$new_file_path" ]; then
		echo "Output file already existed, process delete old file"
		rm -f "$new_file_path"
		echo "File deleted: $new_file_path"
	else
		echo "Continue processing"
	fi
			

	java -jar bundletool-all-1.15.1.jar build-apks --bundle="$file_path" --output="$new_file_path"
	
	processApksFile "$new_file_path"
}


processApksFile() {
	new_file_path=$1
	# Get a list of connected devices
	device_list=$(adb devices | grep -v List | grep -v -e '^[[:space:]]*$' | cut -f 1)

	# Get the size of the device_list
	device_count=$(echo "$device_list" | wc -l)
	if [ -z "$device_list" ]
	then 
		echo -e "${YELLOW}No device was found, make sure you have connected your devices!${NC}"
		echo "If there was an error, try the bellow instruction:"
		echo "adb kill-server > hit enter"
		echo "adb start-server > hit enter"
		exit 0
	else
		echo "$device_count device(s) were found, continue processing"
	fi
	
	if [ $device_count -gt 1 ]
	then
		echo "There are more than one connected devices."
		
		# Check for auto install or manual select devices
		if [ $auto -eq 0 ]
		then
			read -p "Do you want to install on all devices? (Y/n) " is_install_all
		else
			echo "Auto install on all devices"
			is_install_all="y"
		fi

		if [ -z "$is_install_all" ] || [ $(echo "$is_install_all" | tr '[:upper:]' '[:lower:]') = "y" ]
		then
			# Loop through the device list and install AABs
			for device in $device_list
			do
				echo "Installing AAB on device: $device"
				java -jar bundletool-all-1.15.1.jar install-apks --apks="$new_file_path" --device-id="$device"
			done
		else
			declare -A device_map

			echo "Please enter index of the device: "
			iter=0
			for device in $device_list
			do
				device_map[$iter]=$device
				echo "($iter): $device"
				iter=$(expr $iter + 1)
			done

			read -p "Select device index: " device_index
			device_id=${device_map[$device_index]}

			echo "Device index: $device_index - id: $device_id"

			java -jar bundletool-all-1.15.1.jar install-apks --apks="$new_file_path" --device-id="$device_id"

		fi
	else
		java -jar bundletool-all-1.15.1.jar install-apks --apks="$new_file_path"
	fi


	echo "End process"
	read -p "Press any key to exit" key
	exit 0
}

show_info() {
	echo " _______________________________ "
	echo "|   Install APK from AAB File   |"
	echo "|             v_1.0.0           |"
	echo "|        dungvt31@fpt.com       |"
	echo "|_______________________________|"
	

}

# Parse command-line options
if [ $# -eq 0 ]
then
	main
else
	echo "..."
fi

while [ $# -gt 0 ]
do
  case "$1" in
    -h|--help)
      show_help
      exit 0
      ;;
    -i|--info)
      # Handle option i
      show_info
      ;;
		-a|--auto)
			main "auto"
			;;
    *)
      echo "Unknown option: $1"
      show_help
      exit 1
      ;;
  esac
  shift
done

# Run the main function if no-argument was passed


