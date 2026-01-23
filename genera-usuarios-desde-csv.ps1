# Este script lee un fichero csv con el formato nombre;apellidos;fecha-nacimiento
# Por ejemplo: Juan;Pérez Cruz;12-03-2000
# Y genera un fichero con los nombres de los usuarios formados por:
# Primera letra del nombre+3 primeras letras del primer apellido+dia nacimiento+mes nacimiento
# Atención: Guarda el script con formato UTF8-BOM para que lea bien los caracteres acentuados contenidos en este script

$archivoOriginal = "usuarios.csv"
$archivoOriginalUTF8 = "usuarios-2.csv"
$archivoSalida = "matricula.txt"
clear-content $archivoSalida
# Convertir el archivo que contiene los usuarios a UTF-8 sin BOM
Get-Content $archivoOriginal | Set-Content $archivoOriginalUTF8 -Encoding utf8

# Función sencilla para quitar tildes
function QuitarTildes {
    param(
	   [string]$texto
    )
    $texto = ($texto).replace("á","a").replace("é","e").replace("í","i").replace("ó","o").replace("ú","u")
    $texto = ($texto).replace("Á","A").replace("É","E").replace("Í","I").replace("Ó","O").replace("Ú","U")
    $texto = $texto -replace "ñ","n" -replace "Ñ","N"
    #Devuelve el texto sin tildes y sin ñ
    return $texto
}

# Leer archivo UTF-8
$usuarios = Import-Csv $archivoOriginalUTF8 -Delimiter ";"
foreach ($u in $usuarios) {
   # Limpiar nombre y apellidos de espacios al inicio o al final y quitar tildes
   $nombre = QuitarTildes $u.nombre.Trim()
   $apellidos = QuitarTildes $u.apellidos.Trim()
   $fechaNacimiento = $u.'fecha-nacimiento'.Trim()

   $apellido1 = ($apellidos -split " ")[0]
   $dia = $fechaNacimiento.Substring(0,2)
   $mes = $fechaNacimiento.Substring(3,2)
   $usuario = ($nombre.Substring(0,1) + $apellido1.Substring(0,[Math]::Min(3,$apellido1.Length)) + $dia + $mes).ToLower()
   write-output $usuario >> $archivoSalida
}
