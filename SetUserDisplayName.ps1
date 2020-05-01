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
      
    }
  }
