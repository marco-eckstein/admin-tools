#region Definitions

# https://tortoisegit.org/docs/tortoisegit/tgit-dug-settings.html#tgit-dug-settings-progs

$diffTools =
@(
[pscustomobject]@{
    # See http://kdiff3.sourceforge.net/doc/documentation.html
    name="KDiff3";
    defaultPath="C:\Program Files\KDiff3\kdiff3.exe";
    diffArguments="%base %mine --L1 %bname --L2 %yname";
    mergeArguments="%mine %base %theirs --L1 %yname --L2 %bname --L3 %tname --output %merged"
},
[pscustomobject]@{
    # See https://sourcegear.com/diffmerge/webhelp/sec__clargs__diff.html
    # See https://sourcegear.com/diffmerge/webhelp/sec__clargs__merge.html
    name="DiffMerge";
    defaultPath="C:\Program Files\SourceGear\Common\DiffMerge\sgdm.exe";
    diffArguments="/title1=%bname /title2=%yname %base %mine";
    mergeArguments="/merge /caption=%mname /result=%merged /title1=%yname /title2=%bname /title3=%tname %mine %base %theirs"
}
)

$BaseKey = "HKCU:\SOFTWARE\TortoiseGit"
$ContextMenuEntriesDefault = 1030
$ContextMenuEntrieshighDefault = 20
$ContextMenuExtEntriesLowDefault = 40000000
$ContextMenuExtEntriesHighDefault = 12000

function Set-TortoiseGitDiffTool {
    param ([string]$toolName)

    Set-TortoiseGitTool "Diff" $toolName
}

function Set-TortoiseGitMergeTool {
    param ([string]$toolName)

    Set-TortoiseGitTool "Merge" $toolName
}

function Set-TortoiseGitTool {
    param ([string]$toolType, [string]$toolName)

    if ($toolName -eq "TortoiseGitMerge") {
        $Value = Get-ItemPropertyValue $BaseKey $toolType
        if (-not $Value.StartsWith("#")) {
            $Value = "#" + $Value
        }
    } else {
        $diffTool = @($diffTools | Where-Object { $_.name -eq $toolName })
        if ($toolType -eq "Diff") {
            $arguments = $diffTool.diffArguments
        } else {
            $arguments = $diffTool.mergeArguments
        }
        $Value = $diffTool.defaultPath + " " + $arguments
    }
    echo "Setting $BaseKey.$toolType = $Value"
    Set-ItemProperty $BaseKey $toolType $Value
}

#endregion

#region Configuration

Set-TortoiseGitDiffTool "TortoiseGitMerge"
Set-TortoiseGitMergeTool "DiffMerge"
Set-ItemProperty $BaseKey "ContextMenuEntries" 130406
Set-ItemProperty $BaseKey "ContextMenuEntrieshigh" 20020
Set-ItemProperty $BaseKey "ContextMenuExtEntriesLow" $ContextMenuExtEntriesLowDefault
Set-ItemProperty $BaseKey "ContextMenuExtEntriesHigh" $ContextMenuExtEntriesHighDefault
Set-ItemProperty "$BaseKey\StatusColumns" "logloglist" 1f1
Set-ItemProperty "$BaseKey\StatusColumns" "logloglist_Order" "000102030405060809070A0B0C0D"

#endregion
