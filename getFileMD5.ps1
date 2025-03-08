# Copyright 2025 DJ WoodZ
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the “Software”), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Farming Simulator Hash (getFileMD5)
#
# This PowerShell script outputs the hash of a given file using the same
# algorithm as the GIANTS getFileMD5() function.
#
# https://github.com/DJWoodZ/farming-simulator-hash

param (
  [string]$FilePath,
  [string]$CustomBaseName,
  [switch]$Debug
)

# Check if no arguments are provided
if (-not $FilePath) {
  # Display help text
  Write-Host "getFileMD5.ps1"
  Write-Host
  Write-Host "Outputs the hash of a given file using the same algorithm as the GIANTS `getFileMD5()` function."
  Write-Host
  Write-Host "Usage: .\getFileMD5.ps1 <FilePath> [<CustomBaseName>] [-Debug]"
  Write-Host
  Write-Host "<FilePath>         : The path to the file to hash."
  Write-Host "<CustomBaseName>   : Optional. A custom base name to use instead of the file base name."
  Write-Host "-Debug             : Optional. Enable debug information output."
  Write-Host
  Write-Host "Examples:"
  Write-Host " .\getFileMD5.ps1 'file.zip'"
  Write-Host " .\getFileMD5.ps1 'file.zip' 'My_Base_Name'"
  Write-Host " .\getFileMD5.ps1 'C:\path\to\your\file.zip' -Debug"
  Write-Host " .\getFileMD5.ps1 'C:\path\to\your\file.zip' 'My_Base_Name' -Debug"
  exit
}

# Resolve relative path to full path
$FullPath = Resolve-Path $FilePath

# Check if the file exists
if (-Not (Test-Path $FullPath)) {
  Write-Host "The specified file does not exist: $FullPath"
  exit 1
}

# Get base name if a custom base name is not provided
if (-not $CustomBaseName) {
  $FileInfo = Get-Item $FullPath
  $CustomBaseName = [System.IO.Path]::GetFileNameWithoutExtension($FileInfo.Name)
}

# Debug output for base name
if ($Debug) {
  Write-Host "Base Name    : '$CustomBaseName'"
}

# Convert the base name to bytes using UTF-8 encoding
$BaseNameBytes = [System.Text.Encoding]::UTF8.GetBytes($CustomBaseName)

# Create the MD5 hash objects
$MD5File = [System.Security.Cryptography.MD5]::Create()
$MD5GIANTS = [System.Security.Cryptography.MD5]::Create()

# Read the file in chunks and compute the hash
$BufferSize = 4096
$buffer = New-Object byte[] $BufferSize
$stream = [System.IO.File]::OpenRead($FullPath)

# Initialize a byte count variable
$totalBytesRead = 0

try {
  while (($readCount = $stream.Read($buffer, 0, $BufferSize)) -gt 0) {
    $MD5File.TransformBlock($buffer, 0, $readCount, $null, 0) > $null
    $MD5GIANTS.TransformBlock($buffer, 0, $readCount, $null, 0) > $null
    # Accumulate the byte count
    $totalBytesRead += $readCount
  }
}
catch {
  Write-Error "An error occurred while reading the file: $_"
  exit 1
}
finally {
  $stream.Close()
}

# Finalize the hash computations
$MD5File.TransformFinalBlock($buffer, 0, 0) > $null
$MD5GIANTS.TransformFinalBlock($BaseNameBytes, 0, $BaseNameBytes.Length) > $null

# Convert the byte arrays to hex strings
$MD5FileHash = -join ($MD5File.Hash | ForEach-Object { "{0:x2}" -f $_ })
$MD5GIANTSHash = -join ($MD5GIANTS.Hash | ForEach-Object { "{0:x2}" -f $_ })

# Dispose of the MD5 objects
$MD5File.Dispose()
$MD5GIANTS.Dispose()

# Output the hash and extra detail based on Debug switch
if ($Debug) {
  Write-Host "File Bytes   : $totalBytesRead"
  Write-Host "MD5 (File)   : $MD5FileHash"
  Write-Host "MD5 (GIANTS) : $MD5GIANTSHash"
} else {
  Write-Host $MD5GIANTSHash
}
