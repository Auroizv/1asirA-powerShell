#Conexión con otros equipos. Ejemplo de uso de variables. Ejemplo de foreach para recorrer las líneas de un fichero
#El fichero ip-servidores.txt tendrá una ip por línea
clear-host
write-host "conexiones"
$servidores=Get-content ip-servidores.txt
foreach ($ip in $servidores) {
   $respuesta=Test-Connection $ip -count 1 -Quiet
   if ($respuesta -eq "true") {
      write-Host "$ip conexión establecida"
   } else {
      write-Host "$ip Error de conexión"
   }
}
