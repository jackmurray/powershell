Function Remove-MkvTitle
{
    [cmdletbinding(SupportsShouldProcess)]
    param([Parameter(ValueFromPipeline)][System.IO.FileInfo[]]$Files)

    Process
    {
        if ($PSCmdlet.ShouldProcess($Files.FullName, "Strip Title"))
        {
            & "C:\Program Files (x86)\megui\tools\mkvmerge\mkvpropedit.exe" --delete title $Files.FullName
        }
    }
}
