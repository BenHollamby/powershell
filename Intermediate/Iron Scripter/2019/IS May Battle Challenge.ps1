<#
Background Scenario
Your organization needs to deploy IIS based web servers on demand and in a timely manner. To that end, you need to develop an automation process. The process can be manually initiated but when finished the end result should be a Windows 2016 Server (or newer) running with the following configuration items:

Default IIS installation
SSL enabled for default site with a self-signed certificate. A test certificate will suffice.
Windows Internal Database installed.
Network Load Balancing installed (although it does not need to be configured for this exercise).
PowerShell v2.0 support should *not* be installed.
Application event log set to 4GB and configured to not overwrite.
A constrained JEA endpoint for members of the IISAdmin team. The endpoint should only provide access to:
The WebAdministration module
Access to the IIS PSDrive
The ability to view and restart IIS related services
The ability to view, start and terminate IIS related processes
The ability to create new app pools and identities
Requirements
Your finished project should be able to:

Quickly deploy a server configuration that meets the stated objectives
Include a JEA endpoint meeting the stated objectives
Spin up a virtual machine to test the process as part of a continuous integration or release pipeline
It should create a unified and end-to-end text log of their entire process with timestamps.
A suite of Pester tests for unit testing your solution
Bonus points for infrastructure Pester tests or validation tests.
Grading Criteria
Knowing how to write an effective Pester test is becoming a must-have PowerShell skill. As such, your submission should have as many Pester tests as possible to validate your code. Depending on your faction, you may want to write your Pester tests first as part of a TDD effort.

You need to have code to spin up and down a virtual machine using the technology of your choice such as Docker, Hyper-V, Azure, VMWare or even OpenStack.

The remaining grade will be based on how well your overall code structure meets your faction’s philosophy.
#>