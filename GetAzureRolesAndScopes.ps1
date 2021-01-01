Import-Module AzureAD
$proxyString ="http://myproxy:myport"
$proxyUri = new-object System.Uri($proxyString)
[System.Net.WebRequest]::DefaultWebProxy =
new-object System.Net.WebProxy ($proxyUri, $true)
$secret ="00000000"
$tenantId="0000000000"
$applicationId="0000000000"
$passwd = ConvertTo-SecureString $secret -AsPlainText -Force
$pscredential = New-Object System.Management.Automation.PSCredential($applicationId, $passwd)

Connect-AzAccount -ServicePrincipal -Credential $pscredential -TenantId $tenantId 


$results = @()
$sub_Name = Get-AzSubscription
foreach($sub in $sub_Name) {
set-azcontext -Subscription $sub.Name 
$roles = Get-AzRoleAssignment
    foreach($role in $roles){
    if(($role.ObjectType -eq "User")){

       if ($role.Scope.IndexOf("subscriptions") -ne -1) {
                $Scope = $role.Scope.Substring($role.Scope.IndexOf("subscriptions"))
                }
       elseif ($role.Scope.IndexOf("managementGroups") -ne -1) {
                $Scope = $role.Scope.Substring($role.Scope.IndexOf("managementGroups"))
                }
       else {
                $Scope = $role.Scope
                }
        
       $colonnes = @{            
                Name = $role.SignInName             
                Role = $role.RoleDefinitionName                 
                Subscription = $sub.Name 
                Scope = $Scope
                
                
               
        }                           
        $results += New-Object PSObject -Property $colonnes 
    }
}
}

$results | Export-Csv -Path C:\gheggadha\results.csv -NoTypeInformation
