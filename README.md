# DNS-List-Resolver
A script to resolve a very long list of domain names
NOTE: You can change the script and record type based on what you are searching for (A, CNAME, MX, etc...)

create a script in your home directory and paste the contents below: dnsresolve.sh
create a dns.txt file in the same home directory as your script and paste your domain list from a spreadsheet
chmod 700 on dnsresolve.sh
run script in the home/current directory using the following syntax:    
        ./script-name [OPTIONS] [INPUT-FILE]

         EXAMPLE: ./dnsresolve.sh -vamf example.txt
         Option -v   will add verbosity to the script and output
         Option -a   will specify A-RECORDS for a given domain
         Option -m   will specify MX-RECORDS for email
         Option -f   (REQUIRED) specify the input file as the argument
