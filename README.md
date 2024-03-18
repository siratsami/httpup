# httpup
Fastest tool to check hosts/subdomains for http

# What is httpup?
After finding subdomains and hosts, hackers needs to know which subdomain supports http and can be browsed through browsers, there's many tools to perform this action, but they are very slow and has many false positives due to lack of interent speed and timeouts, I have created this automated bash script which called httpup to find http supported hosts/subdomains as quick as possible.

## How does it work?
1. Resolving all subdomains/hosts with massdns
2. Extracting ip addresses of subdomains which have A and CNAME records
3. Scanning for 443,80 ports on ip addresses
4. Finding subdomains which belongs to the ip addresses which supports 443,80 ports

While this may sound incredible since we are using multiple tools and ways, but its actually much faster than any other tools such as httpx, it also has 0 misses and you won't get rate limited since we do not send any actual http request to the subdomains and hosts itself.

# Requirements
1. Massdns
2. Masscan
3. Parallel
4. Sudo permission (since masscan requires sudo)

Tested only on KaliLinux.

# Usage
1. `chmod +x httpup`
2. `sudo ./httpup subdomains.txt`
3. Final result will be saved as `httpsubdomains.txt`

Demo video https://youtu.be/UBxlM1_O8aM
