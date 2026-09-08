# Baixa e instala a fonte MesloLGS NF direto do repositório oficial
# (romkatv/powerlevel10k-media) para todos os usuários do Windows.
# Rode este script em um PowerShell como Administrador.

$ErrorActionPreference = "Stop"

$fonts = @(
  "MesloLGS%20NF%20Regular.ttf",
  "MesloLGS%20NF%20Bold.ttf",
  "MesloLGS%20NF%20Italic.ttf",
  "MesloLGS%20NF%20Bold%20Italic.ttf"
)
$base = "https://github.com/romkatv/powerlevel10k-media/raw/master"
$tmp = Join-Path $env:TEMP "MesloLGS-NF"
New-Item -ItemType Directory -Force -Path $tmp | Out-Null

$shell = New-Object -ComObject Shell.Application
$fontsFolder = $shell.Namespace(0x14) # CSIDL_FONTS

foreach ($f in $fonts) {
    $dest = Join-Path $tmp $f
    Write-Host "Baixando $f..."
    Invoke-WebRequest "$base/$f" -OutFile $dest
    Write-Host "Instalando $f..."
    $fontsFolder.CopyHere($dest, 0x10)
}

Write-Host ""
Write-Host "Fonte MesloLGS NF instalada. Selecione 'MesloLGS NF' nas"
Write-Host "preferências de fonte do Windows Terminal (ou outro emulador)."
