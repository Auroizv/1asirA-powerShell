write-output "Hola hoy es dia $((get-date).day)" 
write-output "Mi sistema operativo es $((get-computerinfo).windowsproductname)" 
write-output "Información del sistema" 
$version=Get-CimInstance Win32_OperatingSystem
write-output "Tu versión del sistema operativo es $version.caption"
get-computerinfo | more