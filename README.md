# Get-AcceptMessagesFrom

![](https://github.com/junecastillote/Get-AcceptMessagesFrom/blob/master/images/header1.png)

When you need to export a list of accepted senders of any particular Exchange recipient object like a Distribution Group, Dynamic Distribution Group, Mailbox and Contact, usually you can use these commands:

```PowerShell
Get-DistributionGroup <GROUP> |
    Select-Object -ExpandProperty AcceptMessagesOnlyFromSendersOrMembers
```

But the `AcceptMessagesOnlyFromSendersOrMembers` property only contains the names, like you see in the screenshot below.

![](https://github.com/junecastillote/Get-AcceptMessagesFrom/blob/master/images/intro1.png)

This script expands the output by getting other properties of the sender object like email, name and title.
You can also modify this scrip to add more properties to be returned as needed.

Output can be exported to CSV, HTML, JSON, XML etc. using the standard PowerShell commands.

## Links

- [Repo: Get-AcceptMessagesFrom on GitHub](https://github.com/junecastillote/Get-AcceptMessagesFrom)
- [Site: Generate a Report of Exchange Recipients Accepted Senders List](https://lazyexchangeadmin.com/generate-a-report-of-exchange-recipients-accepted-senders/)

## Syntax

```PowerShell
Get-AcceptMessagesFrom.ps1
    [-InputObject] <Object>
    [-ExpandGroups]
    [-Unique <bool>]
    [<CommonParameters>]
```

## Requirements

- PowerShell 5.1
- Established Remote PowerShell Session with Exchange Online (or On-Prem)

## How to use

### Example 1

Get all accepted senders of all dynamic distribution groups. Groups are shows but and not expanded.

```PowerShell
.\Get-AcceptMessagesFrom.ps1 -InputObject (Get-DynamicDistributionGroup DDL1) -verbose
```

![](https://github.com/junecastillote/Get-AcceptMessagesFrom/blob/master/images/Example1.png)

### Example 2

Get all accepted senders of all dynamic distribution groups. Groups are expanded and only shows their members.

```PowerShell
.\Get-AcceptMessagesFrom.ps1 -InputObject (Get-DynamicDistributionGroup) -Verbose -ExpandGroups | Format-Table
```

![](https://github.com/junecastillote/Get-AcceptMessagesFrom/blob/master/images/Example2.png)

## Parameters

### -InputObject

Exchange Recipient Objects (Mailbox, Groups, Contacts)

```yaml
Type: Object
Required: True
Default value: None
Accept pipeline input: False
```

### -ExpandGroups

Switch to instruct the script to expand members that are groups (recursive)

```yaml
Type: Switch
Required: False
Default value: None
Accept pipeline input: False
```

### -Unique

Boolean value whether or not to return unique values only. For example, a sender may be a member of nested groups and may appear more than once. By default, only unique values are returned.

```yaml
Type: Boolean
Required: False
Default value: True
Accept pipeline input: False
```

## Properties

- RecipientName
- RecipientEmail
- SenderName
- SenderEmail
- SenderType
- SenderJobTitle
