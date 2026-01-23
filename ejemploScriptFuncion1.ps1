#Conexión con otros equipos usando funciones
#Primero definimos la función e indicamos los 
# parámetros que va a recibir así como su tipo (en este caso string)
Function Conexiones {
   Param(
	[string]$servidor
   )
   $respuesta=Test-Connection $servidor -count 1 -Quiet
      if ($respuesta -eq "true") {
         write-Host "$servidor conexión establecida"
      } else {
         write-Host "$servidor Error de conexión"
      }
   
}
#Inicio 
clear-host
write-host "conexiones"
$servidores=Get-content ip-servidores.txt

foreach ($ip in $servidores) {
    #Llamamos a la función para que se ejecute su contenido
    #Pasando como argumento la IP de un servidor
    Conexiones $ip
}
