$script_dir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$custom_exec_dir = "C:\exec_bin"
if (!(Test-Path $custom_exec_dir)) {
		New-Item -ItemType Directory -Path $custom_exec_dir
}

& $script_dir\parts\drivers.ps1
& $script_dir\init.ps1

winget install -e --id OBSProject.OBSStudio
winget install -e --id Valve.Steam
winget install -e --id EpicGames.EpicGamesLauncher
winget install -e --id Nvidia.Broadcast
winget install -e --id PlayStation.DualSenseFWUpdater
winget install -e --id LINE.LINE
winget install -e --id BlenderFoundation.Blender
winget install -e --id UnityTechnologies.UnityHub
winget install -e --id VirtualDesktop.Streamer
winget install -e --id REALiX.HWiNFO
winget install -e --id Parsec.Parsec

& $script_dir\parts\optional.ps1
