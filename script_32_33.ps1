param(
[string]$fichero=".\usu.txt")
Start-Transcript -Path C:\Users\alum1asira\Desktop\log\$(get-date -format 'yyyy-MM-dd-hh-mm')genera_usuarios.log -Append

$usuario = Get-Content $fichero

function quitartildes {
    param([string]$usu)
    $usu = $usu -replace "á", "a" -replace "é", "e" -replace "í", "i" -replace "ó", "o" -replace "ú", "u"
    $usu = $usu -replace "Á", "A" -replace "É", "E" -replace "Í", "I" -replace "Ó", "O" -replace "Ú", "U"
    $usu = $usu -replace "Ñ", "N" -replace "ñ", "n"
    return $usu
}

foreach($usu in $usuario) {
    $sintildes = quitartildes $usu
    $contrasenia = convertto-securestring $sintildes -asplaintext -force
   
    # Crear el usuario
    new-localuser -name $sintildes -password $contrasenia
    add-localgroupmember -group usuarios -member $sintildes
    net user $sintildes /logonpasswordchg:yes

    
    $rutaBase = "C:\datos1\$sintildes"
    $subCarpetas = "apuntes", "iso", "bd", "lm", "tareas"
   
    foreach ($sub in $subCarpetas) {
        New-Item -Path "$rutaBase\$sub" -ItemType Directory -Force
    }

    # --- PUNTO 33: Configurar ACLs (Permisos) ---
    # 1. Obtener el ACL actual de la carpeta del usuario
    $acl = Get-Acl $rutaBase
   
    # 2. Bloquear herencia y eliminar permisos heredados ($true = bloquear, $false = no copiar antiguos)
    $acl.SetAccessRuleProtection($true,$true)

    $acl.access | ForEach-Object {
        if (($_.identityreference -like "*Administradores") -or ($_.identityreference -like "*SYSTEM"  )) {
            Write-Output "no se cambia la regla del $_.identityreference"
        } else {
            $acl.RemoveAccessRule($_)
        } 
    }
   
    # 3. Definir Control Total para Administradores y para el Usuario
    # $reglaAdmin = New-Object System.Security.AccessControl.FileSystemAccessRule("Administradores", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
    $reglaUsu   = New-Object System.Security.AccessControl.FileSystemAccessRule($sintildes, "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
   
    #$acl.AddAccessRule($reglaAdmin)
    $acl.AddAccessRule($reglaUsu)
   
    # 4. Aplicar los cambios a la carpeta
    Set-Acl $rutaBase $acl
}

stop-Transcript