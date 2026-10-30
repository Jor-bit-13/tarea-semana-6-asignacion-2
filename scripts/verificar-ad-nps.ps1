# Verificación de solo lectura de AD DS + NPS. Ejecutar en Windows Server.
Import-Module ActiveDirectory
"NET-NIVEL-0","NET-NIVEL-5","NET-NIVEL-10" | ForEach-Object {
    Write-Host "=== Grupo: $_ ==="
    Get-ADGroupMember -Identity $_ | Select-Object Name,SamAccountName
}
Get-ADUser -Filter "SamAccountName -like 'usuario*'" | Select-Object Name,Enabled
Get-NpsRadiusClient | Select-Object Name,Address,Enabled
Get-Service -Name IAS
Get-NetUDPEndpoint -LocalPort 1812,1813 | Select-Object LocalAddress,LocalPort
