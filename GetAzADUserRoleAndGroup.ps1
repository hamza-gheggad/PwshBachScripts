Function Test-AzureADUserRoleAndGroup { 
    param ( 
    [Parameter(Mandatory=$true)] 
    $UserName 
    ) 
    $aad_User = Get-AzureADUser -Filter "userPrincipalName eq '$UserName'"
    if(!$aad_User){ 
        Write-Host "I am sorry, i can't find a user name $UserName. Are you sure its the correct user name?" -ForegroundColor Red 
    } else { 
        $aad_UserRolesAndGroups = Get-AzureADUserMembership -ObjectId $aad_User.ObjectId | Group-Object -Property ObjectType -AsHashTable
        $Roles = $aad_UserRolesAndGroups.Role | % { Get-AzureADDirectoryRole -ObjectId $_.ObjectId } 
        $Groups = $aad_UserRolesAndGroups.Group | % { Get-AzureADGroup -ObjectId $_.ObjectId } 
                  
        $obj = New-Object -TypeName psobject 
        $obj | Add-Member -MemberType NoteProperty -Name UserName -Value $UserName 
        $obj | Add-Member -MemberType NoteProperty -Name 'User ID' -Value $aad_User.ObjectId 
        $obj | Add-Member -MemberType NoteProperty -Name 'Role Name' -Value $Roles.DisplayName 
        $obj | Add-Member -MemberType NoteProperty -Name 'Group Name' -Value $($Groups | % {$_.DisplayName}) 
         
        Write-Output $obj 
    } 
} 
 
Function Get-AzureADUserRoleAndGroup(){ 
    BEGIN{} 
    PROCESS{ Test-AzureADUserRoleAndGroup -UserName $_ } 
    END{} 
}
