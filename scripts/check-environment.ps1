#requires -Version 5.1
[CmdletBinding()]
param(
    [string]$XamppRoot = 'E:\xampp',
    [switch]$CheckLocalServices,
    [string]$ReportDirectory
)
$ErrorActionPreference = 'Stop'
$results = New-Object 'System.Collections.Generic.List[object]'
function Add-Result($Name, $Status, $Detail, $Advice = '') {
    $results.Add([pscustomobject]@{ Name=$Name; Status=$Status; Detail=$Detail; Advice=$Advice })
    $color = switch ($Status) { 'PASS' {'Green'} 'WARN' {'Yellow'} 'FAIL' {'Red'} default {'Gray'} }
    Write-Host ('[{0}] {1}: {2}' -f $Status,$Name,$Detail) -ForegroundColor $color
}
function Invoke-Probe([string]$Command, [string[]]$Arguments) {
    # Windows PowerShell 5.1 may wrap native stderr as ErrorRecord.
    # Native stderr is not itself a failed exit status.
    $ErrorActionPreference = 'Continue'
    $PSNativeCommandUseErrorActionPreference = $false
    try {
        $cmd = Get-Command $Command -CommandType Application -ErrorAction Stop | Select-Object -First 1
        # Native commands update the global automatic variable; do not shadow it locally.
        $global:LASTEXITCODE = $null
        $raw = @(& $cmd.Source @Arguments 2>&1)
        $exitCode = $global:LASTEXITCODE
        $output = @($raw | ForEach-Object { ([string]$_).Trim() } | Where-Object { $_ })
        [pscustomobject]@{ Ok=($null -ne $exitCode -and $exitCode -eq 0); ExitCode=$exitCode; Lines=$output }
    } catch {
        [pscustomobject]@{ Ok=$false; ExitCode=$null; Lines=@($_.Exception.Message) }
    }
}
function Test-Tool($Name, $Command, [string[]]$Arguments, $Optional=$false) {
    $probe = Invoke-Probe $Command $Arguments
    if ($probe.Ok) { Add-Result $Name PASS ($probe.Lines | Select-Object -First 1) }
    elseif ($Optional) { Add-Result $Name SKIP 'Not available or unable to run' 'Install only if needed.' }
    else { Add-Result $Name FAIL 'Not available or unable to run' 'Check installation, PATH and terminal restart.' }
}
function Test-Run($Name,$Command,[string[]]$Arguments,$Expected) {
    $probe = Invoke-Probe $Command $Arguments
    if ($probe.Ok -and ($probe.Lines -contains $Expected)) { Add-Result $Name PASS $Expected }
    else { Add-Result $Name FAIL 'Runtime test failed' 'Check the runtime installation and PATH.' }
}
Write-Host 'Windows Development Environment Check | v1.1.0-preview.3'
Add-Result 'PowerShell' PASS $PSVersionTable.PSVersion.ToString()
$policy = Get-ExecutionPolicy
if ($policy -in @('Restricted','AllSigned')) { Add-Result 'Execution policy' WARN "$policy" 'Use npm.cmd or consult your administrator; do not bypass organization policy.' }
else { Add-Result 'Execution policy' PASS "$policy" }
Test-Tool Python python.exe @('--version')
Test-Tool pip python.exe @('-c','import pip; print(pip.__version__)')
Test-Run 'Python runtime' python.exe @('-c',"print('Python OK')") 'Python OK'
Test-Tool 'Node.js' node.exe @('--version')
Test-Tool npm npm.cmd @('--version')
Test-Tool npx npx.cmd @('--version')
Test-Run 'Node runtime' node.exe @('-e',"console.log('Node OK')") 'Node OK'
Test-Tool Git git.exe @('--version')
Test-Tool 'Git Credential Manager' git.exe @('credential-manager','--version')
foreach ($key in @('user.name','user.email','init.defaultBranch')) {
    $probe = Invoke-Probe git.exe @('config','--global','--get',$key)
    if ($probe.Ok -and ($probe.Lines -join '').Trim()) { Add-Result "Git $key" PASS 'Configured (value hidden)' }
    else { Add-Result "Git $key" WARN 'Not configured globally' 'Review the Git configuration guide.' }
}
Test-Tool 'VS Code' code.cmd @('--version')
$manifest = Join-Path $PSScriptRoot '..\configs\vscode\extensions.txt'
$extensions = Invoke-Probe code.cmd @('--list-extensions')
if ($extensions.Ok -and (Test-Path -LiteralPath $manifest -PathType Leaf)) {
    $expected = @(Get-Content -LiteralPath $manifest | ForEach-Object { $_.Trim() } | Where-Object { $_ -and -not $_.StartsWith('#') })
    foreach ($id in $expected) {
        if ($extensions.Lines -contains $id) { Add-Result "Extension $id" PASS 'Installed' }
        else { Add-Result "Extension $id" WARN 'Missing' 'Install if needed from VS Code Marketplace.' }
    }
} else { Add-Result 'VS Code extensions' SKIP 'CLI or extension manifest unavailable' }
Test-Tool PHP php.exe @('-v')
Test-Run 'PHP runtime' php.exe @('-r',"echo 'PHP OK';") 'PHP OK'
$modules = Invoke-Probe php.exe @('-m')
if ($modules.Ok) {
    foreach ($module in @('mysqli','pdo_mysql','pdo_sqlite','sqlite3','curl','mbstring','openssl','gd','intl','zip','fileinfo','dom','SimpleXML','exif')) {
        if ($modules.Lines -contains $module) { Add-Result "PHP module $module" PASS 'Loaded (CLI)' }
        else { Add-Result "PHP module $module" WARN 'Not loaded (CLI)' 'Check php.ini and matching DLLs; verify Apache separately.' }
    }
} else { Add-Result 'PHP modules' SKIP 'PHP CLI unavailable' }
Test-Tool 'MariaDB client' mysql.exe @('--version')
Test-Tool 'Database dump client' mysqldump.exe @('--version')
if (Test-Path -LiteralPath $XamppRoot -PathType Container) {
    Add-Result 'XAMPP directory' PASS 'Directory found'
    $httpd = Join-Path $XamppRoot 'apache\bin\httpd.exe'
    $conf = Join-Path $XamppRoot 'apache\conf\httpd.conf'
    if ((Test-Path -LiteralPath $httpd -PathType Leaf) -and (Test-Path -LiteralPath $conf -PathType Leaf)) {
        $serverRoot = Join-Path $XamppRoot 'apache'
        $apache = Invoke-Probe $httpd @('-d',$serverRoot,'-f',$conf,'-t')
        $diagnostic = ($apache.Lines -join ' | ')
        if (-not $diagnostic) { $diagnostic = 'No diagnostic output' }
        if ($apache.Ok) { Add-Result 'Apache configuration' PASS ("Exit 0: $diagnostic") }
        else { Add-Result 'Apache configuration' WARN ("Exit $(if ($null -eq $apache.ExitCode) { "unknown" } else { $apache.ExitCode }): $diagnostic") 'Run httpd.exe -t manually and inspect paths.' }
    } else { Add-Result 'Apache configuration' WARN 'Executable or configuration missing' }
} else { Add-Result 'XAMPP directory' WARN 'Directory not found at supplied root' 'Pass -XamppRoot with the actual directory.' }
if ($CheckLocalServices) {
    foreach ($entry in @(@('Apache HTTP',80),@('MariaDB TCP',3306))) {
        $client = New-Object System.Net.Sockets.TcpClient
        try {
            $task = $client.ConnectAsync('127.0.0.1',[int]$entry[1])
            if ($task.Wait(1500) -and $client.Connected) { Add-Result $entry[0] PASS "Local port $($entry[1]) accepts TCP (service identity not verified)" }
            else { Add-Result $entry[0] WARN "Local port $($entry[1]) unavailable" 'Start service or check custom port.' }
        } catch { Add-Result $entry[0] WARN "Local port $($entry[1]) unavailable" 'Start service or check custom port.' }
        finally { $client.Dispose() }
    }
} else { Add-Result 'Local service ports' SKIP 'Use -CheckLocalServices to check default ports 80 and 3306.' }
Add-Result 'GitHub authentication / actual push' SKIP 'Requires separate manual verification.'
Add-Result 'Web PHP / WordPress' SKIP 'Requires separate browser and project verification.'
Add-Result Codex SKIP 'Optional; not required for baseline.'
$summary = [ordered]@{}
foreach ($state in @('PASS','WARN','FAIL','SKIP')) { $summary[$state] = @($results | Where-Object Status -eq $state).Count }
Write-Host ("Summary: PASS={0} WARN={1} FAIL={2} SKIP={3}" -f $summary.PASS,$summary.WARN,$summary.FAIL,$summary.SKIP)
if ($ReportDirectory) {
    $dir = New-Item -ItemType Directory -Path $ReportDirectory -Force
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss-fff'
    $report = [ordered]@{ Version='1.1.0-preview.3'; GeneratedAt=(Get-Date).ToString('o'); Summary=$summary; Results=@($results.ToArray()) }
    $report | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $dir.FullName "environment-$stamp.json") -Encoding UTF8
    $md = @('# Environment check', '', "Generated: $($report.GeneratedAt)", '', '| Check | Status | Detail | Advice |', '|---|---|---|---|')
    foreach ($item in $results) {
        $cells = @($item.Name,$item.Status,$item.Detail,$item.Advice) | ForEach-Object { ([string]$_).Replace('|','\|').Replace("`r",' ').Replace("`n",' ') }
        $md += '| ' + ($cells -join ' | ') + ' |'
    }
    $md | Set-Content -LiteralPath (Join-Path $dir.FullName "environment-$stamp.md") -Encoding UTF8
    Write-Host 'Reports saved locally. Review before sharing.'
}
if ($summary.FAIL -gt 0) { exit 1 }
exit 0
