Start-Transcript -Path C:\Users\alum1asira\Documents\GitHub\1asirA-powerShell\log\Creauser-simple.log -append
#Crea usuarios locales leyendolos de un fichero de texto
$usu=get-content ejemplouser.txt
foreach ($u in $usu){

   $contrasenia=ConvertTo-SecureString $u -asplaintext -force
   New-LocalUser $u -password $contrasenia
   # Para que pueda iniciar sesión debemos incluirlo en un grupo con "Derecho de inicio de sesión local"
   # Mirando las directivas de seguridad podemos averiguar cuales son esos grupos
   Add-localGroupMember -group usuarios -member $u
} 
Stop-Transcript