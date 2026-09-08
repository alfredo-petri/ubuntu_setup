# Baixa e instala a fonte MesloLGS NF direto do repositório oficial
# (romkatv/powerlevel10k-media) para todos os usuários do Windows.
# Rode este script em um PowerShell como Administrador.

$ErrorActionPreference = "Stop"
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}

$names = @("Regular", "Bold", "Italic", "Bold Italic")
$base = "https://github.com/romkatv/powerlevel10k-media/raw/master"
$tmp = Join-Path $env:TEMP "MesloLGS-NF"
New-Item -ItemType Directory -Force -Path $tmp | Out-Null

$shell = New-Object -ComObject Shell.Application
$fontsFolder = $shell.Namespace(0x14) # CSIDL_FONTS

foreach ($name in $names) {
    $fileName = "MesloLGS NF $name.ttf"
    $urlName = [uri]::EscapeDataString($fileName)
    $dest = Join-Path $tmp $fileName
    Write-Host "Baixando $fileName..."
    Invoke-WebRequest "$base/$urlName" -OutFile $dest
    Write-Host "Instalando $fileName..."
    $fontsFolder.CopyHere($dest, 0x10)
}

Write-Host ""
Write-Host "Fonte MesloLGS NF instalada. Selecione 'MesloLGS NF' nas"
Write-Host "preferencias de fonte do Windows Terminal (ou outro emulador)."
