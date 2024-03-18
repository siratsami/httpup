#!/bin/bash

echo "Usage: sudo ./httpup subdomains.txt"
echo "https://twitter.com/siratsami71"
echo ""

echo "Creating temporary resolver file"
echo 1.1.1.1 >> resolver.tmp
echo 8.8.8.8 >> resolver.tmp
echo ""

echo "Running massdns..."
sleep 1 && massdns -r resolver.tmp -t A $1 -w mdo.tmp
echo ""

echo "Extracting ip addresses of subdomains"
grep -A 1 ";; ANSWER SECTION" mdo.tmp | grep 'IN A ' | awk -F'A ' '{print $2}' | sort -u >> ips.tmp
awk '/IN CNAME/,/IN A/{print}' mdo.tmp | grep ' IN A ' | awk -F'A ' '{print $2}' | sort -u >> ips2.tmp
echo ""

echo "Scannig for 443,80 ports on ip addresses..."
sudo masscan -p 443,80 -iL ips.tmp -oL ipsms.tmp
sudo masscan -p 443,80 -iL ips2.tmp -oL ips2ms.tmp
cat ipsms.tmp | awk -F' ' '{print $4}' | awk -F' ' '{print $1}' | sort -u >> liveips.tmp
cat ips2ms.tmp | awk -F' ' '{print $4}' | sort -u >> liveips2.tmp
echo ""

echo "Searching for http subdomains..."
grep -A 1 "ANSWER SECTION" mdo.tmp | grep "IN A " | sort -u >> asubs.tmp
cat liveips.tmp | parallel -j 10 'grep " {}$" asubs.tmp' >> subs1.tmp
cat liveips2.tmp | parallel -j 10 'grep -B 10 " {}$" mdo.tmp | grep -A 1 ANSWER | grep CNAME' >> subs2.tmp
echo ""

echo "Saving the result..."
cat subs1.tmp subs2.tmp | awk -F'. ' '{print $1}' | sort -u >> httpsubdomains.txt
echo ""

rm *.tmp

echo "Done."
