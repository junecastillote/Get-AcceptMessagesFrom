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

Get all accepted senders of a dynamic distribution group.

```PowerShell
.\Get-AcceptMessagesFrom.ps1 -InputObject (Get-DynamicDistributionGroup DDL1) -verbose
```

![Example 1](https://github.com/junecastillote/Get-AcceptMessagesFrom/blob/master/images/Example1.png)
