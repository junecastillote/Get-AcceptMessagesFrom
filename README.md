# Get-ExoAcceptMailFrom

Get Exchange Online `AcceptMessagesOnlyFromSendersOrMembers` details

```PowerShell
Get-AcceptMessagesFrom.ps1 [-InputObject] <Object> [-ExpandGroups] [-Unique <bool>] [<CommonParameters>]
```

## Requirements

1. PowerShell 5.1
2. Established Remote PowerShell Session with Exchange Online (or On-Prem)

## How to use

### Example 1

Get all accepted senders of all dynamic distribution groups. Groups are shows but and not expanded.

```PowerShell
.\Get-AcceptMessagesFrom.ps1 -InputObject (Get-DynamicDistributionGroup DDL1) -verbose
```

![Example 1](https://github.com/junecastillote/Get-AcceptMessagesFrom/blob/master/images/Example1.png)

### Example 2

Get all accepted senders of all dynamic distribution groups. Groups are expanded and only shows their members.

```PowerShell
.\Get-AcceptMessagesFrom.ps1 -InputObject (Get-DynamicDistributionGroup) -Verbose -ExpandGroups | Format-Table
```

![Example 2](https://github.com/junecastillote/Get-AcceptMessagesFrom/blob/master/images/Example2.png)

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

* RecipientName
* RecipientEmail
* SenderName
* SenderEmail
* SenderType
* SenderJobTitle
