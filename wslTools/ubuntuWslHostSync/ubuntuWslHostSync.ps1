#
# Powershell script for adding/removing/showing entries to the hosts file.
#
# Known limitations:
# - does not handle entries with comments afterwards ("<ip>    <host>    # comment")
#

$file = "C:\Windows\System32\drivers\etc\hosts"
$wsl_ip = (wsl -d ubuntu hostname -I).trim()
$data = @('add','localwsl.com',$wsl_ip)

function add-host([string]$filename, [string]$hostname, [string]$ip) {
    remove-host $filename $hostname
    $ip + "`t`t" + $hostname | Out-File -encoding ASCII -append $filename
}

function remove-host([string]$filename, [string]$hostname) {
    $c = Get-Content $filename
    $newLines = @()

    foreach ($line in $c) {
        $bits = [regex]::Split($line, "\t+")
        if ($bits.count -eq 2) {
            if ($bits[1] -ne $hostname) {
                $newLines += $line
            }
        } else {
            $newLines += $line
        }
    }

    # Write file
    Clear-Content $filename
    foreach ($line in $newLines) {
        $line | Out-File -encoding ASCII -append $filename
    }
}

function print-hosts([string]$filename) {
    $c = Get-Content $filename

    foreach ($line in $c) {
        $bits = [regex]::Split($line, "\t+")
        if ($bits.count -eq 2) {
            Write-Host $bits[0] `t`t $bits[1]
        }
    }
}

try {
    if ($data[0] -eq "add") {

        if ($data.count -lt 3) {
            throw "Not enough arguments for add."
        } else {
            add-host $file $data[1] $data[2]
        }

    } elseif ($data[0] -eq "remove") {

        if ($data.count -lt 2) {
            throw "Not enough arguments for remove."
        } else {
            remove-host $file $data[1]
        }

    } elseif ($data[0] -eq "show") {
        print-hosts $file
    } else {
        throw "Invalid operation '" + $data[0] + "' - must be one of 'add', 'remove', 'show'."
    }
} catch  {
    Write-Host $error[0]
    Write-Host "`nUsage: hosts add <ip> <hostname>`n       hosts remove <hostname>`n       hosts show"
}