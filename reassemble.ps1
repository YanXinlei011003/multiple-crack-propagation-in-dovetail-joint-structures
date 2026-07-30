[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ArchiveName,

    [string]$AssetDirectory = '.',

    [string]$OutputPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$assetRoot = (Resolve-Path -LiteralPath $AssetDirectory).Path
$parts = @(
    Get-ChildItem -LiteralPath $assetRoot -File -Filter "$ArchiveName.part*" |
        Sort-Object Name
)

if ($parts.Count -eq 0) {
    throw "No parts found for '$ArchiveName' in '$assetRoot'."
}

for ($index = 0; $index -lt $parts.Count; $index++) {
    $expectedSuffix = '.part{0:D2}' -f ($index + 1)
    if (-not $parts[$index].Name.EndsWith($expectedSuffix, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Missing or out-of-sequence part. Expected suffix '$expectedSuffix'."
    }
}

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $OutputPath = Join-Path $assetRoot $ArchiveName
} elseif (-not [System.IO.Path]::IsPathRooted($OutputPath)) {
    $OutputPath = Join-Path (Get-Location) $OutputPath
}

if (Test-Path -LiteralPath $OutputPath) {
    throw "Output already exists: $OutputPath"
}

$output = [System.IO.File]::Create($OutputPath)
$buffer = New-Object byte[] (8MB)

try {
    foreach ($part in $parts) {
        Write-Host "Appending $($part.Name)..."
        $input = [System.IO.File]::OpenRead($part.FullName)
        try {
            while (($bytesRead = $input.Read($buffer, 0, $buffer.Length)) -gt 0) {
                $output.Write($buffer, 0, $bytesRead)
            }
        } finally {
            $input.Dispose()
        }
    }
    $output.Flush()
} finally {
    $output.Dispose()
}

Write-Host "Created: $OutputPath"
Get-FileHash -Algorithm SHA256 -LiteralPath $OutputPath
