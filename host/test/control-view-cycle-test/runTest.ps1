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

# update the path so they are formatted based on host OS, (win vs. unix)
$StrataPath = Convert-path $StrataPath
$PythonScriptPath = Convert-path $PythonScriptPath

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
    write-host "============================================================================================================================================"
    write-host "============================================================================================================================================"
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

# This functin is to check if Strata Develoiper studio Exist
function Test-StrataExist {
    Write-Host "Looking for Strata Developer Studio in" $StrataPath
    if (Test-Path -Path $StrataPath) {
        Write-Host "Strata Developer Studio found." -ForegroundColor Green
        Return $true
    }
    else {
        Write-Host "Strta Developer Studio not found. aborting..." -ForegroundColor red
        Return $false 
    }
}

# Function to run the test, it will return True if the test was successful 
function Test-StrataControlView {
    # check if the python script exesit.
    Write-Host "Looking for the test script " $PythonScriptPath
    if (Test-Path -Path $PythonScriptPath) {
        write-host "Script Found" -ForegroundColor Green
        
        write-host "Starting Strata Developer Studio..."
        $strataDev = Start-Process $StrataPath -PassThru | Out-Null     # Hide output.
        
        write-host "Starting python test script..."
        write-host "############################################################################################################################################"
        $pythonScript = Start-Process $PythonExec $PythonScriptPath -NoNewWindow -PassThru -wait
        write-host "############################################################################################################################################"
        
        Write-Host "Python test script is done."

        Write-Host "Checking if Strata Developer Studio is still running."
        if ($strataDev.HasExited -eq $false) {
            Write-Host "Strata Developer Studio is running. Killing Strata Developer Studio..."
            stop-process $strataDev.id
        }
        else {
            # Strta is not running. it could bea crash!
            Write-Host "Strata developer Studio is not running. It might crashed during the test. Aborting..." -ForegroundColor Yellow
            return $false
        }
        

        if ($pythonScript.ExitCode -eq 0) {
            # Test Successful
            Write-Host "Test Successful." -ForegroundColor Green
            return $true
        }
        else {
            Write-Host "Test failed." -ForegroundColor red
            Write-Host "Exit Code =" $pythonScript.ExitCode -ForegroundColor red
            return $false
        }
    }
    else {
        return $false
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

# verify Strata path.
if ( (Test-StrataControlView) -Eq $false) {
    Exit-TestScript -ScriptExitCode -1
}

# Test successfull!
Exit-TestScript -ScriptExitCode 0
