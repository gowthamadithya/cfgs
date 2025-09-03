function prompt {
    $loc = $executionContext.SessionState.Path.CurrentLocation;
    $time = Get-Date -Format "HH:mm:ss"

    $out = ""
    if ($loc.Provider.Name -eq "FileSystem") {
        $out += "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\"
    }

    $out += "PS $loc$('>' * ($nestedPromptLevel + 1)) ";

    return $time + "-" + $out
}
