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

Get all accepted senders of all dynamic distribution groups. The output shows the groups as members (not expanded)

```PowerShell
.\Get-AcceptMessagesFrom.ps1 -InputObject (Get-DynamicDistributionGroup DDL1) -verbose
```

![](https://github.com/junecastillote/Get-AcceptMessagesFrom/blob/master/images/Example1.png)

![](https://github.com/junecastillote/Get-AcceptMessagesFrom/blob/master/images/Example1.png)

### Example 2

