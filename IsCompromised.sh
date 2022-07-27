#!/bin/bash

CompromisedWC=$(cat /home/Compromised.txt | wc -l)
CompromisedUniq=$(cat /home/Compromised.txt | sort | uniq)
CurlWC=$(curl 'https://api.amp.cisco.com/v1/computers?group_guid=GROUPID' -u 'ClientID:Key' | jq \
| grep 'external\|hostname\|is_compromised' | paste - - - | column -t -s$'\t' | grep true | sort | uniq | wc -l )

if [[ $CompromisedWC -eq 0 ]] && [[ $CurlWC -gt 0 ]]; then

cp /home/Sendmail.txt /home/Sendmailtemp.txt
echo "Subject: Indication of Compromise" >> /home/Sendmailtemp.txt
echo >> /home/Sendmailtemp.txt

curl 'https://api.amp.cisco.com/v1/computers?group_guid=GROUPID' -u 'ClientID:Key' | jq \
| grep 'external\|hostname\|is_compromised' | paste - - - | column -t -s$'\t' | grep true >> /home/Compromised.txt
cat /home/Compromised.txt >> /home/Sendmailtemp.txt
sudo cat /home/Sendmailtemp.txt | ssmtp user@email.com
rm /home/Sendmailtemp.txt

else
CurlAPI=$(curl 'https://api.amp.cisco.com/v1/computers?group_guid=GROUPID' -u 'ClientID:Key' | jq \
| grep 'external\|hostname\|is_compromised' | paste - - - | column -t -s$'\t' | grep true | sort | uniq )

if [[ "$CompromisedUniq" != "$CurlAPI" ]]; then

cp /home/Sendmail.txt /home/Sendmailtemp.txt
echo "Subject: Indication of Compromise" >> /home/Sendmailtemp.txt
echo >> /home/Sendmailtemp.txt

curl 'https://api.amp.cisco.com/v1/computers?group_guid=GROUPID' -u 'ClientID:Key' | jq \
| grep 'external\|hostname\|is_compromised' | paste - - - | column -t -s$'\t' | grep true >> /home/Compromised.txt
cat /home/Compromised.txt | sort | uniq >> /home/Sendmailtemp.txt
sudo cat /home/Sendmailtemp.txt | ssmtp user@email.com
rm /home/Sendmailtemp.txt

fi
fi





