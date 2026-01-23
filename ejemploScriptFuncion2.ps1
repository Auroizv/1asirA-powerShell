#Conexión con otros equipos usando funciones
#Primero definimos la función e indicamos los parámetros 
#que va a recibir así como el tipo (en este caso una lista de strings)
Function Conexiones {
   Param(
	    [string[]]$servidores
   )
   foreach ($ip in $servidores) {
      $respuesta=Test-Connection $ip -count 1 -Quiet
      if ($respuesta -eq "true") {
         write-Host "$ip conexión establecida"
      } else {
         write-Host "$ip Error de conexión"
      }
   }
}
#Inicio 
clear-host
write-host "conexiones"
$servidores=Get-content ip-servidores.txt
#Llamamos a la función para que se ejecute su contenido
#Pasando como argumento la lista de servidores 
Conexiones $servidores
