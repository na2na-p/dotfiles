winget install -e --id Amazon.AWSCLI
winget install -e --id Amazon.SessionManagerPlugin
winget install -e --id Microsoft.AzureCLI

# NOTE: Terraformはwinget未対応
$custom_exec_dir = "C:\exec_bin"
$tf_version="1.3.2"
$tf_zip="terraform_${tf_version}_windows_amd64.zip"
Invoke-WebRequest -Uri "https://releases.hashicorp.com/terraform/${tf_version}/${tf_zip}" -OutFile $tf_zip
Expand-Archive -Path $tf_zip -DestinationPath $custom_exec_dir
Remove-Item $tf_zip
$Env:Path += ";$custom_exec_dir"
