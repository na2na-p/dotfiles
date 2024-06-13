winget install -e --id CoreyButler.NVMforWindows

# nvmを使用可能に
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

nvm install latest
corepack enable yarn
