$dados = @{
    Hostname = $env:COMPUTERNAME
    Username = $env:USERNAME
    OS = (Get-CimInstance Win32_OperatingSystem).Caption
    Version = (Get-CimInstance Win32_OperatingSystem).Version
    Uptime = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
    CPU = (Get-CimInstance Win32_Processor).Name
    RAM_GB = [math]::Round((Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB, 2)
    Disk_GB = [math]::Round(((Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'").Size) / 1GB, 2)
    IP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike '169.*'} | Select-Object -First 1).IPAddress
}

$json = $dados | ConvertTo-Json -Depth 3

Invoke-RestMethod -Uri "http://your_flask_ip/receber" `
    -Method POST `
    -Body $json `
    -ContentType "application/json"
