######################################################################################
#THis is a bash script written for finding subdomains while doing bug bounty.
#Written by Divyanshu Diwakar
#######################################################################################
#!/bin/bash

if [ -z "$1"]
then 
      echo "usage : ./subdomains.sh comapny_name path_to_save_asn path_to_save_subdomains company_website_name "
else
      amass intel -org  $1 | cut -d ,  -f 1  >>$2

      asn_path=$2

      while IFS= read -r asn_no
      do
   
        echo "##############SubdomInaTor By SecTheBit###############"
        #whois -h whois.radb.net -- -i origin $asn_no | grep -Eo "([0-9.]+){4}/[0-9]+" | sort -u
        amass intel -asn $asn_no | grep "$1" >>$3
    
      done < "$asn_path"

      subdomains=$3

      while IFS= read -r subdomain
      do
 
      echo "##########Doing WHOis on the subdomains########"
      amass intel -whois -d subdomain

      done < "$subdomains"

      echo "############Gathering Subdomains from CERT.SH#############"
      curl -s https://crt.sh/?q\=%.$4\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u




fi
