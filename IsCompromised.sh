#!/bin/bash

CompromisedWC=$(cat /home/Compromised.txt | wc -l)
CompromisedUniq=$(cat /home/Compromised.txt | sort | uniq)

if [[ $CompromisedWC -eq "0" ]]; then
cp /home/Sendmail.txt /home/Sendmailtemp.txt
curl 'https://api.amp.cisco.com/v1/computers' -u 'ClientID:KEY' | jq | grep 'external\|hostname\|is_compromised' \
| paste - - - | column -t -s$'\t' | grep true >> /home/Compromised.txt
cat /home/Compromised.txt >> /home/Sendmailtemp.txt
sudo cat /home/Sendmailtemp.txt | ssmtp user@email.com
rm /home/Sendmailtemp.txt
else

Compromised=$(curl 'https://api.amp.cisco.com/v1/computers' -u 'ClientID:KEY' | jq | grep 'external\|hostname\|is_compromised' \
| paste - - - | column -t -s$'\t' | grep true | sort | uniq )

if [[ "$Compromised" != "$CompromisedUniq" ]]; then

cp /home/Sendmail.txt /home/Sendmailtemp.txt
curl 'https://api.amp.cisco.com/v1/computers' -u 'ClientID:Key' | jq | grep 'external\|hostname\|is_compromised' \
| paste - - - | column -t -s$'\t' | grep true >> /home/Compromised.txt
cat /home/Compromised.txt | sort | uniq >> /home/Sendmailtemp.txt
sudo cat /home/Sendmailtemp.txt | ssmtp user@email.com
rm /home/Sendmailtemp.txt

fi
fi
