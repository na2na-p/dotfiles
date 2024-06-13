# 注意事項

`Set-ExecutionPolicy RemoteSigned`を事前に叩いておくこと  
家で使うなら home.ps1 だけ叩けばいいはず
重すぎるものは optional に切り出し

下記は事前にやっておきたい気持ちがある

```ps1
winget install -e --id Git.Git
winget install Microsoft.PowerShell --accept-package-agreements --accept-source-agreements
winget install Microsoft.WindowsTerminal --accept-package-agreements --accept-source-agreements
```
