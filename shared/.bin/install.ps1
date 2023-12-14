function Test-IsAdmin {
	$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
	return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-IsAdmin)) {
	Write-Host "This script requires Administrator privileges. Please run it as Administrator." -ForegroundColor Red
	exit
}

# メイン処理
function New-AppDataSymbolicLink {
	Write-Host "Backup old .emacs.d directory..."
	$backupDir = Join-Path $HOME ".dotbackup"
	if (-not (Test-Path $backupDir)) {
		Write-Host "$backupDir not found. Auto Making it"
		New-Item -ItemType Directory -Path $backupDir
	}

	# Gitリポジトリのルートディレクトリを取得
	$gitRoot = Invoke-Expression 'git rev-parse --show-toplevel'
	# 表示
	$emacsDir = Join-Path $gitRoot "\shared\.emacs.d"
	$appDataDir = $env:APPDATA

	$linkPath = Join-Path $appDataDir ".emacs.d"
	if ((Get-Item $linkPath -ErrorAction SilentlyContinue).Attributes -match 'ReparsePoint') {
		Remove-Item $linkPath -Force
	}
	if (Test-Path $linkPath) {
		Move-Item $linkPath $backupDir
	}
	New-Item -ItemType SymbolicLink -Path $linkPath -Target $emacsDir
	Write-Host "Link created for .emacs.d at $linkPath"
}

# 引数解析
foreach ($arg in $args) {
	switch ($arg) {
		"--debug" {
			Set-PSDebug -Trace 2
		}
		"--help" {
			Show-Help
			exit
		}
		"-h" {
			Show-Help
			exit
		}
	}
}

# メイン処理
New-AppDataSymbolicLink
Write-Host -ForegroundColor Cyan "Install completed!!!!"
