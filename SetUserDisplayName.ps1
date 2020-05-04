Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction "SilentlyContinue" | Out-Null

  ErrorActionPreference = "Stop"
  if ($Verbose -eq $null)
  {
    $Verbose = $false
  }
  
  #Ensure the SPTimerService is started on each Application Server
  foreach($server in (get-spserver | Where {$_.Role -eq "Application"}) )
  {
    Write-Host "Starting SPTimerService on each Application Server:
    $server.Name
    $service = Get-WmiObject -computer $server.Name Win32_Service -Filter "Name='SPTimerV4'"
    $service.InvokeMethod('StopService',$Null)
    start-sleep -s 5
    $service.InvokeMethod('StartService',$Null)
    start-sleep -s 5
    $service.State
  }
  
  Function UpdateDisplayName($path)
  {
    $site = Get-SPSite $path
    foreach($web in $site.AllWebs)
    {
      try{
        $user = Get-SPUser -Identity "i:0#.w|Test-Domain|JohnDoe" -Web $web
        #set the user display name
        Set-SPUser -Identity "i:0#.w|Test-Domain|JohnDoe" -DisplayName "Doe, John H." -Web $web
      }
      catch
      {
        #move on to the next website
      }
      $site.Dispose()
    }
  }
[xml]$s = Get-Content UpgradeSites.xml
Write-Host " "
Write-Host " "

foreach ($SiteCollection in $s.Upgrade.SiteCollections.SiteCollection)
{
  $SCName = $SiteCollection.getAttribute("Name")
  Echo $SCName
  $WebApp = $SiteCollection.getAttribute("HostHeaderWebApplication")
  Echo $webApp
  $SiteURL = $SiteCollection.getAttribute("URL")
  Echo $SiteURL
  
  $FullSCURLPath = $WebApp + $SiteURL
  Echo "Name: $SCName -URL $FullSCURLPath"
  
  UpdateDisplayName($FullSCURLPath)
}
