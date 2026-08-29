[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string] $Path,
    [string] $DynamicPath,
    [string] $StablePrefixMarker
)

$ErrorActionPreference = 'Stop'

function Get-Metrics([string] $FilePath) {
    $resolved = Resolve-Path -LiteralPath $FilePath
    $content = [System.IO.File]::ReadAllText($resolved)
    [pscustomobject]@{
        path = $FilePath
        bytes = [System.Text.Encoding]::UTF8.GetByteCount($content)
        characters = $content.Length
        lines = ($content -split "`r?`n").Count
        content = $content
    }
}

$main = Get-Metrics $Path
$result = [ordered]@{
    path = $main.path
    bytes = $main.bytes
    characters = $main.characters
    lines = $main.lines
    duplicate_line_candidates = @(
        $main.content -split "`r?`n" |
            ForEach-Object { $_.Trim() } |
            Where-Object { $_.Length -ge 20 } |
            Group-Object |
            Where-Object { $_.Count -gt 1 }
    ).Count
}

if ($DynamicPath) {
    $dynamic = Get-Metrics $DynamicPath
    $result.dynamic = [ordered]@{
        path = $dynamic.path
        bytes = $dynamic.bytes
        characters = $dynamic.characters
        lines = $dynamic.lines
    }
}

if ($StablePrefixMarker) {
    $index = $main.content.IndexOf($StablePrefixMarker, [System.StringComparison]::Ordinal)
    if ($index -lt 0) {
        throw "Stable prefix marker not found: $StablePrefixMarker"
    }
    $prefix = $main.content.Substring(0, $index)
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        $hash = $sha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($prefix))
    }
    finally {
        $sha.Dispose()
    }
    $result.stable_prefix = [ordered]@{
        marker = $StablePrefixMarker
        bytes = [System.Text.Encoding]::UTF8.GetByteCount($prefix)
        characters = $prefix.Length
        sha256 = ([System.BitConverter]::ToString($hash)).Replace('-', '').ToLowerInvariant()
    }
}

$result | ConvertTo-Json -Depth 4
