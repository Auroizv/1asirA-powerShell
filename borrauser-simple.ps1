#Borra usuarios locales leyendolos de un fichero de texto
$usu=get-content ejemplouser.txt
foreach ($u in $usu){
    read-host "Teclee SI si está seguro de borrar el usuario $u" $seguro
    if ($seguro -eq "SI") {
       remove-localUser $u
       write-output "Usuario $u borrado"
    }
}