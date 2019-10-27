
<#PSScriptInfo

.VERSION 1.0.0

.GUID c7d3eeae-4307-4737-a36a-c7b1f14c197b

.AUTHOR june.castillote@gmail.com

.COMPANYNAME LazyExchangeAdmin.com

.COPYRIGHT june.castillote@gmail.com

.TAGS

.LICENSEURI

.PROJECTURI https://github.com/junecastillote/Get-ExoAcceptMailFrom

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


.PRIVATEDATA

#>

#Requires -Version 5.1

<#

.DESCRIPTION
 Get Exchange Online AcceptMessagesOnlyFromSendersOrMembers details

#>
[cmdletbinding()]
Param(
    [parameter(Mandatory, Position = 0)]
    [ValidateNotNullOrEmpty()]
    $InputObject,

    [parameter()]
    [switch]$ExpandGroups,

    [parameter()]
    [boolean]$Unique = $true
)

## Check if input is valid. Exit if not.
if (($InputObject | Get-Member).Name -notcontains 'AcceptMessagesOnlyFromSendersOrMembers') {
    Write-Output 'InputObject is not valid. Valid objects are mailbox, distribution group and dynamic distribution group'
    break
}

## Function to recursively list group members (nested)
Function Get-MembersRecursive {
    param (
        [parameter()]
        [string]$groupName
    )
    $groupMembers = @()
    $group = Get-Group $groupName -ErrorAction SilentlyContinue
    foreach ($groupMember in $group.Members) {
        $memberObj = Get-Recipient $groupMember -ErrorAction SilentlyContinue

        if ($memberObj) {
            if ($memberObj.count -gt 1) {
                $memberObj = Get-Recipient -Filter ('Name -eq ' + "'$($groupMember)'")
            }
            if ($memberObj.RecipientTypeDetails -match 'group') {
                $groupMembers += (Get-MembersRecursive $groupMember)
            }
            else {
                #$memberObj | Add-Member -MemberType NoteProperty -Name # SenderMemberOf -Value $groupName
                $groupMembers += $memberObj
            }
        }

    }
    $groupMembers = $groupMembers | Sort-Object -Property Name -Unique
    return $groupMembers
}

$finalResult = @()
$i = 1
foreach ($object in $InputObject) {
    Write-Verbose "($i of $($InputObject.count)) | $($object.Name)"
    if ($object.AcceptMessagesOnlyFromSendersOrMembers) {
        foreach ($member in $object.AcceptMessagesOnlyFromSendersOrMembers ) {
            $sender = Get-Recipient $member  -ErrorAction SilentlyContinue

            if ($sender.count -gt 1) {
                $sender = Get-Recipient -Filter ('Name -eq ' + "'$($member)'")
            }

            if ($sender) {
                $objClass = $sender.ObjectClass[-1]

                ## If sender is not a group
                if ($objClass -ne 'group') {
                    Write-Verbose "> [$($objClass)] | $($sender.Name)"

                    $properties = [ordered]@{
                        GroupName      = $object.Name
                        GroupEmail     = $object.PrimarySMTPAddress
                        SenderName     = $sender.Name
                        SenderType     = $sender.RecipientTypeDetails
                        SenderEmail    = $sender.PrimarySMTPAddress
                        SenderJobTitle = $sender.Title
                        # SenderPermission = 'Direct'
                        # SenderMemberOf   = ''
                    }
                    $finalResult += (New-Object psobject -Property $properties)
                }
                ## if Sender is a Group
                elseif ($objClass -eq 'group') {
                    Write-Verbose "> [$($objClass)] | $($sender.Name)"

                    if (!$ExpandGroups) {
                        ## add the group to the collection

                        $properties = [ordered]@{
                            GroupName      = $object.Name
                            GroupEmail     = $object.PrimarySMTPAddress
                            SenderName     = $sender.Name
                            SenderType     = $sender.RecipientTypeDetails
                            SenderEmail    = $sender.PrimarySMTPAddress
                            SenderJobTitle = 'Not Applicable'
                            # SenderPermission = 'Direct'
                            # SenderMemberOf   = 'Not Applicable'
                        }
                        $finalResult += (New-Object psobject -Property $properties)
                    }


                    if ($ExpandGroups) {
                        ## Get recursive group membership
                        $groupMembers = Get-MembersRecursive $sender.Name

                        ## Add each group member to the collection
                        foreach ($groupMember in $groupMembers) {
                            $objClass = $groupMember.ObjectClass[-1]
                            Write-Verbose "     > [$($objClass)] | $($groupMember.Name)"
                            $properties = [ordered]@{
                                GroupName      = $object.Name
                                GroupEmail     = $object.PrimarySMTPAddress
                                SenderName     = $groupMember.Name
                                SenderType     = $groupMember.RecipientTypeDetails
                                # SenderPermission = 'Inherited'
                                SenderEmail    = $groupMember.PrimarySMTPAddress
                                SenderJobTitle = $groupMember.Title
                                # SenderMemberOf   = $groupMember.# SenderMemberOf
                            }
                            $finalResult += (New-Object psobject -Property $properties)
                        }
                    }
                }
            }
        }
    }
    ## increment counter
    $i = $i + 1
}

if ($Unique) {
    $finalResult = $finalResult | Sort-Object -Property SenderName -Unique
}
else {
    $finalResult = $finalResult | Sort-Object -Property SenderName
}

return $finalResult