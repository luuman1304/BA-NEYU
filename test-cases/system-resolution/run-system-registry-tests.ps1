$ErrorActionPreference = 'Stop'

$repositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$registryPath = Join-Path $repositoryRoot 'knowledge\standards\system-registry.md'
$registryText = Get-Content -Raw -Encoding UTF8 -LiteralPath $registryPath

$rowPattern = '^\|\s*([A-Z0-9]+)\s*\|\s*([^|]+?)\s*\|\s*([^|]+?)\s*\|\s*`(\[[A-Z0-9]+\])`\s*\|\s*`([^`]+)`\s*\|\s*$'
$rows = @(
    foreach ($line in ($registryText -split "`r?`n")) {
        if ($line -match $rowPattern) {
            [pscustomobject]@{
                SystemKey = $matches[1].Trim()
                SystemName = $matches[2].Trim()
                Aliases = @($matches[3].Split(',') | ForEach-Object { $_.Trim() })
                JiraPattern = $matches[4].Trim()
                KnowledgePath = $matches[5].Trim()
            }
        }
    }
)

$failures = [System.Collections.Generic.List[string]]::new()

if ($rows.Count -ne 7) {
    $failures.Add("Expected 7 registry rows; found $($rows.Count).")
}

$expectedRows = @{
    LTX = @{ Name = 'Latam Express'; Aliases = @('LTX', 'Latam Express'); Pattern = '[LTX]'; Path = 'knowledge/systems/LTX' }
    TMS = @{ Name = 'Telesale Management System'; Aliases = @('TMS', 'Telesale', 'Telesale Management System'); Pattern = '[TMS]'; Path = 'knowledge/systems/TMS' }
    RMS = @{ Name = 'Rescue Management System'; Aliases = @('RMS', 'Rescue', 'Rescue Management System'); Pattern = '[RMS]'; Path = 'knowledge/systems/RMS' }
    WFO = @{ Name = 'Workforce Optimization'; Aliases = @('WFO', 'Workforce Optimization'); Pattern = '[WFO]'; Path = 'knowledge/systems/WFO' }
    WFM = @{ Name = 'Workforce Management System'; Aliases = @('WFM', 'Workforce Management System'); Pattern = '[WFM]'; Path = 'knowledge/systems/WFM' }
    AFS = @{ Name = 'Affscale'; Aliases = @('AFS', 'Affscale'); Pattern = '[AFS]'; Path = 'knowledge/systems/AFS' }
    AQM = @{ Name = 'Automated Quality Management'; Aliases = @('AQM', 'Automated Quality Management'); Pattern = '[AQM]'; Path = 'knowledge/systems/AQM' }
}

foreach ($key in $expectedRows.Keys) {
    $actual = $rows | Where-Object SystemKey -eq $key
    $expected = $expectedRows[$key]
    if ($null -eq $actual) {
        $failures.Add("Missing registry row: $key.")
        continue
    }
    if ($actual.SystemName -ne $expected.Name -or
        $actual.JiraPattern -ne $expected.Pattern -or
        $actual.KnowledgePath -ne $expected.Path -or
        (Compare-Object $actual.Aliases $expected.Aliases)) {
        $failures.Add("Registry row $key does not match the confirmed source of truth.")
    }
}

foreach ($property in 'SystemKey', 'JiraPattern', 'KnowledgePath') {
    $duplicates = @($rows | Group-Object -Property $property | Where-Object Count -gt 1)
    if ($duplicates.Count -gt 0) {
        $failures.Add("Duplicate $property values: $($duplicates.Name -join ', ').")
    }
}

foreach ($row in $rows) {
    $resolvedPath = Join-Path $repositoryRoot ($row.KnowledgePath -replace '/', '\')
    if (-not (Test-Path -LiteralPath $resolvedPath -PathType Container)) {
        $failures.Add("Missing knowledge path: $($row.KnowledgePath).")
    }
    foreach ($child in 'BRD', 'CR', 'Decisions', 'Specifications') {
        if (-not (Test-Path -LiteralPath (Join-Path $resolvedPath $child) -PathType Container)) {
            $failures.Add("Missing knowledge folder: $($row.KnowledgePath)/$child.")
        }
    }
}

$aliasIndex = @{}
foreach ($row in $rows) {
    foreach ($identifier in @($row.SystemKey, $row.SystemName) + $row.Aliases) {
        $normalized = $identifier.ToLowerInvariant()
        if ($aliasIndex.ContainsKey($normalized) -and $aliasIndex[$normalized].SystemKey -ne $row.SystemKey) {
            $failures.Add("Identifier '$identifier' resolves to multiple systems.")
        } else {
            $aliasIndex[$normalized] = $row
        }
    }
}

function Resolve-System([string] $InputValue) {
    $normalized = $InputValue.Trim().ToLowerInvariant()
    if ($aliasIndex.ContainsKey($normalized)) {
        return $aliasIndex[$normalized]
    }
    return $null
}

foreach ($row in $rows) {
    foreach ($identifier in @($row.SystemKey, $row.SystemName) + $row.Aliases) {
        foreach ($caseVariant in $identifier.ToLowerInvariant(), $identifier.ToUpperInvariant()) {
            $resolved = Resolve-System $caseVariant
            if ($null -eq $resolved -or $resolved.SystemKey -ne $row.SystemKey) {
                $failures.Add("Case-insensitive resolution failed for '$caseVariant'.")
            }
        }
    }
}

$tests = @(
    @{ Id = 'TC-SYS-001'; Input = 'Latam Express'; Key = 'LTX'; Name = 'Latam Express'; Pattern = '[LTX]' },
    @{ Id = 'TC-SYS-002'; Input = 'Telesale Management System'; Key = 'TMS'; Name = 'Telesale Management System'; Pattern = '[TMS]' },
    @{ Id = 'TC-SYS-003'; Input = 'Rescue Management System'; Key = 'RMS'; Name = 'Rescue Management System'; Pattern = '[RMS]' },
    @{ Id = 'TC-SYS-004'; Input = 'Workforce Optimization'; Key = 'WFO'; Name = 'Workforce Optimization'; Pattern = '[WFO]' },
    @{ Id = 'TC-SYS-005'; Input = 'Workforce Management System'; Key = 'WFM'; Name = 'Workforce Management System'; Pattern = '[WFM]' },
    @{ Id = 'TC-SYS-006'; Input = 'Affscale'; Key = 'AFS'; Name = 'Affscale'; Pattern = '[AFS]' },
    @{ Id = 'TC-SYS-007'; Input = 'Automated Quality Management'; Key = 'AQM'; Name = 'Automated Quality Management'; Pattern = '[AQM]' },
    @{ Id = 'TC-SYS-008'; Input = 'ABC'; Key = 'UNKNOWN_SYSTEM_KEY'; Name = $null; Pattern = $null },
    @{ Id = 'TC-SYS-009'; Input = 'TMS'; Key = 'TMS'; Name = 'Telesale Management System'; Pattern = '[TMS]' },
    @{ Id = 'TC-SYS-010'; Input = 'WFO'; Key = 'WFO'; Name = 'Workforce Optimization'; Pattern = '[WFO]' },
    @{ Id = 'TC-SYS-011'; Input = 'WFM'; Key = 'WFM'; Name = 'Workforce Management System'; Pattern = '[WFM]' }
)

foreach ($test in $tests) {
    $resolved = Resolve-System $test.Input
    $actualKey = if ($null -eq $resolved) { 'UNKNOWN_SYSTEM_KEY' } else { $resolved.SystemKey }
    $passed = $actualKey -eq $test.Key
    if ($passed -and $null -ne $resolved) {
        $passed = $resolved.SystemName -eq $test.Name -and $resolved.JiraPattern -eq $test.Pattern
    }
    if (-not $passed) {
        $failures.Add("$($test.Id) failed for '$($test.Input)'.")
        Write-Output "$($test.Id): FAIL"
    } else {
        Write-Output "$($test.Id): PASS"
    }
}

$outdatedPattern = 'WFO\s*(?:=|\||->|\u2192)\s*Workforce Management System|Workforce Management System[^\r\n]*(?:AMBIGUOUS_SYSTEM)|AMBIGUOUS_SYSTEM[^\r\n]*Workforce Management System'
$textFiles = Get-ChildItem -LiteralPath $repositoryRoot -Recurse -Force -File | Where-Object {
    $_.Extension -in '.md', '.txt', '.json', '.yaml', '.yml', '.ps1', '.py' -and
    $_.FullName -ne $PSCommandPath -and
    $_.FullName -notlike "*\outputs\*"
}
foreach ($file in $textFiles) {
    $content = Get-Content -Raw -Encoding UTF8 -LiteralPath $file.FullName
    if ($content -match $outdatedPattern) {
        $failures.Add("Outdated WFO/WFM mapping found in $($file.FullName).")
    }
}

$sourceDiscoveryPath = Join-Path $repositoryRoot '.claude\skills\ba-source-discovery\SKILL.md'
$currentStatePath = Join-Path $repositoryRoot '.claude\skills\ba-current-state-analyzer\SKILL.md'
$sourceDiscoveryText = Get-Content -Raw -Encoding UTF8 -LiteralPath $sourceDiscoveryPath
$currentStateText = Get-Content -Raw -Encoding UTF8 -LiteralPath $currentStatePath

$sourceDiscoveryChecks = @(
    '../../../knowledge/standards/system-registry.md',
    'case-insensitive matching',
    'resolved registry Jira Summary Pattern',
    'CROSS_SYSTEM_SUPPORTING_SOURCE',
    '`SELECTED` Jira, Confluence, and Local sources'
)
foreach ($requiredText in $sourceDiscoveryChecks) {
    if (-not $sourceDiscoveryText.Contains($requiredText)) {
        $failures.Add("Source Discovery integration is missing: $requiredText.")
    }
}

if (-not $currentStateText.Contains('knowledge/standards/system-registry.md') -or
    -not $currentStateText.Contains('Do not independently guess aliases') -or
    -not $currentStateText.Contains('selected Jira, Confluence, and Local source lists')) {
    $failures.Add('Current State Analyzer does not preserve registry-resolved system identity and channel-separated selected sources.')
}

foreach ($skillPath in $sourceDiscoveryPath, $currentStatePath) {
    $skillText = Get-Content -Raw -Encoding UTF8 -LiteralPath $skillPath
    if ($skillText -notmatch '^---\r?\nname:\s*[a-z0-9-]+\r?\ndescription:\s*.+?\r?\n---') {
        $failures.Add("Invalid skill frontmatter: $skillPath.")
    }
}

if ($failures.Count -gt 0) {
    Write-Output 'SYSTEM_REGISTRY: FAIL'
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Output 'SYSTEM_REGISTRY: PASS'
Write-Output 'KNOWLEDGE_PATHS: PASS'
Write-Output 'ALIASES: PASS'
Write-Output 'OUTDATED_WFO_MAPPING: PASS'
Write-Output 'SOURCE_DISCOVERY_INTEGRATION: PASS'
