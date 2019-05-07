Function Split-FLAC
{
    param(
        [Parameter(Mandatory)][string]$CueFile,
        #If not specified, it will be assumed the .flac has the same name as the .cue.
        [string]$FLACFile
    )

    $CueFile = ($CueFile | Resolve-Path ).Path

    if (!$FLACFile)
    {
        $FLACFile = $CueFile -replace ".cue",".flac"
    }

    $CueFile

    & 'C:\Program Files (x86)\MeGUI\tools\shntool\shntool.exe' split -f $CueFile -o 'flac flac --output-name=%f -' -t '%n - %t' $FLACFile
}

Function Convert-FLACToMP3
{
    param([Parameter(Mandatory=$true)][string[]]$File, [int]$Bitrate = 320, [switch]$KeepInput = $False)

    $inputfiles = $File | Resolve-Path

    $inputfiles | %{
        $newname = $_.Path -replace "\.flac",".mp3"

        & "C:\Program Files (x86)\MeGUI\tools\ffmpeg\ffmpeg.exe" -i "$($_.Path)" -ab ($Bitrate.ToString() + "k") "$newname"

        if (($LastExitCode -eq 0) -and ($KeepInput -eq $False))
        {
	        Remove-Item $_
        }
    }
}

Function Extract-AudioAsAC3
{
    [cmdletbinding(SupportsShouldProcess)]
    param([Parameter(Mandatory=$true)][System.IO.FileInfo]$file, [Parameter(Mandatory=$true)][int]$track)

    [Array]$params = $file.fullname, ([String]$track + ':'), "$($file.fullname).ac3", "-384", "-core", "-progressnumbers"
    if ($PSCmdlet.ShouldProcess($file, "Transcode audio"))
    {
	    & 'C:\Program Files (x86)\MeGUI\tools\eac3to\eac3to.exe' $params
	    Remove-Item -LiteralPath "$file - Log.txt"
    }
}