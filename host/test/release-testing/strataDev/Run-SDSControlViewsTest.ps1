# This test is semi automated as it requires someone to look at the UI for proper rendering

# squence of test:
#   1. Run Strata Dev Studio.
#   2. Start the python script `zmq-client.py`. 
#   3. Close every thing.

# Optional -StrataPath command line argument, otherwise use the default intallation path.
[CmdletBinding()]
param (
    [string]$StrataPath = "$($Env:Programfiles)\ON Semiconductor\Strata Developer Studio\Strata Developer Studio.exe",
    [string]$PythonScriptPath = "$($PSScriptRoot)\control-view-test.py"
)

# Import the test function
. "$($PSScriptRoot)\Test-SDSControlViews.ps1"

# Determine the python command based on OS. osx will execute python 2 by default and here we need to use python3.
# on win, python3 is not in the path by default, as a result we'll need to use python3 for osx and python for win
# If ($IsWindows -eq $true) {
If ($Env:OS -eq "Windows_NT") {
    $PythonExec = 'python'
}
Else {
    $PythonExec = 'python3'
}

# Utility function to print the exit code an a pattern for the end of the script.
function Exit-TestScript {
    param (
        [Parameter(Mandatory = $true)][int]$ScriptExitCode
    )
    if ($ScriptExitCode -eq 0) {
        write-host "Test finished Successfully. Existting..." -ForegroundColor Green
    }
    else {
        write-host "Test failed. Terminating" $ScriptExitCode -ForegroundColor red
    }
    write-host "================================================================================"
    write-host "================================================================================"
    exit $ScriptExitCode
}

# function to check if python and pyzmq are installed, if both were found it will return True,
function Test-PythonExist {
    Try {
        Write-Host "Looking for python..."
        If ((Start-Process $PythonExec --version -Wait -WindowStyle Hidden -PassThru).ExitCode -Eq 0) {
            Write-Host "Python found." -ForegroundColor Green
            Write-Host "Looking for pyzmq..."
            If ((Start-Process $PythonExec '-c "import zmq"' -WindowStyle Hidden -Wait -PassThru).ExitCode -Eq 0) {
                Write-Host "pyzmq found." -ForegroundColor Green
            }
            Else {
                Write-Host "pyzmq not found. aborting..." -ForegroundColor red
                Return $false
            }
        } 
        Else {           
            Write-Host "Python not found. aborting..." -ForegroundColor red
            Return $false
        }  
    }
    Catch [System.InvalidOperationException] {
        Write-Host "Python not found. aborting..." -ForegroundColor red
        Return $false
    }
    Return $true
}

# This functin is to check if Strata Developer studio Exist
function Test-StrataExist {

    # Convert the path if using unix env.
    If ( $Env:OS -ne "Windows_NT" -and (( $StrataPath = Convert-path $StrataPath) -eq $false )) {
        return $false
    }
    
    Write-Host "Looking for Strata Developer Studio in" $StrataPath
    If (Test-Path -Path $StrataPath) {
        Write-Host "Strata Developer Studio found." -ForegroundColor Green
        Return $true
    }
    Else {
        Write-Host "Strta Developer Studio not found. aborting..." -ForegroundColor red
        Return $false 
    }
}

# check python tools.
if ( (Test-PythonExist) -eq $false ) {
    Exit-TestScript -ScriptExitCode -1
}

# verify Strata path.
if ( (Test-StrataExist) -Eq $false) {
    Exit-TestScript -ScriptExitCode -1
}

# Call the test function
if ( (Test-StrataControlView -PythonScriptPath $PythonScriptPath -StrataPath $StrataPath) -Eq $false) {
    Exit-TestScript -ScriptExitCode -1
}

# Test successfull!
Exit-TestScript -ScriptExitCode 0
