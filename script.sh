#!/bin/bash

# Display a banner using figlet with colors
echo -e "\e[1;33m"
figlet "Scan Script"
echo -e "\e[0m"

# Get the IP address from the user
ip="$1"
if [ -z "$ip" ]; then
    echo "Usage: $0 <IP_ADDRESS>"
    exit 1
fi

# Perform the nmap scan and save the output to a temporary file
temp_output=$(mktemp)
nmap -p- "$ip" --min-rate=5000 -oN "$temp_output"

# Check if the temporary output file exists
if [ ! -f "$temp_output" ]; then
    echo "Temporary output file does not exist."
    exit 1
fi

# Extract port numbers from the temporary output file
port_numbers=$(grep -oP '^\d+(?=/)' "$temp_output" | tr '\n' ',' | sed 's/,$//')

# Remove the temporary output file
rm "$temp_output"

# Check if port numbers were found
if [ -z "$port_numbers" ]; then
    echo "No open ports found."
    exit 1
fi

# Perform a detailed nmap scan on the extracted ports
nmap -p"$port_numbers" "$ip" -A -oN scan_results.txt

echo "Detailed scan results saved to scan_results.txt"

# Perform a UDP scan on the target
nmap -sU -sC -sV -F -open "$ip" -oN udp_scan_results.txt

cat scan_results.txt
cat udp_scan_results.txt