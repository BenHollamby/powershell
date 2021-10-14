<#
1.
OU = PFO'''' for NZ staff
OU = PFO''''''''''' for contracters 
OU = PFO''' for aussies

2.
Permissions from x

3.
Normal User = first four letters of lastname and first letter of firstname, all one word
Contractor = first four letters of lastname, underscore, first letter of firstname

4.
User must change password at next login

5.
office
department
Title
company      same as description
Description same as company
manager
email
webpage

6.
Distribution groups that are listed.

7.
Proxy addresses to include
SMTP:Firstname.Lastname@swarm.com
smtp:username@swarm.com
smtp:Firstname.Lastname@swarm.co.nz
smtp:username@swarm.co.nz

8.
AD attributes
c NZ|AU
co New Zealand | Australia
countryCode 554 | 036 (nz - aus respectively)

9. 
license with M365

10. 
Add user to intune_app_build group

11.
Confirm mailbox in EO
Set datetime and region

12.
Onprem mail server session
Enable-mailuser -identity user@swarm.com -externalemailaddress user@swarm.onmicrosoft.com
Enable-remoteMailbox "Firstname Lastname" -remoteroutingaddress username@swarm.mail.onmicrosoft.com
Confirm?

13. 
Send notification. Thinking just open a text file that helpdesk can copy and paste for now. 
Once confirmed working well, automate the notification to Grant.

Sequence
Name
Title
Office | Country
Department
Manager
work | mobile
Employment Type
Copy user

#>