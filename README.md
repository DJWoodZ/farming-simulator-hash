Farming Simulator Hash (getFileMD5)
===================================

This PowerShell script outputs the hash of a given file using the same algorithm as the GIANTS `getFileMD5()` function.

Usage
-----

```powershell
.\getFileMD5.ps1 <FilePath> [<CustomBaseName>] [-Debug]
```

* `<FilePath>`: The path to the file to hash.
* `<CustomBaseName>`: Optional. A custom base name to use instead of the file base name.
* `-Debug`: Optional. Enable debug information output.

Algorithm
---------

The algorithm is as follows:

1. Read the contents of the file.
2. Concatenate the file contents with the derived or provided base name (file name without extension).
3. Compute the MD5 hash of the concatenated data.

Example Usage
-------------

```powershell
.\getFileMD5.ps1 'file.zip'
```

```powershell
.\getFileMD5.ps1 'file.zip' 'My_Base_Name'
```

```powershell
.\getFileMD5.ps1 'file.zip' -Debug
```

```powershell
.\getFileMD5.ps1 'file.zip' 'My_Base_Name' -Debug
```

```powershell
.\getFileMD5.ps1 'C:\path\to\your\file.zip'
```

```powershell
.\getFileMD5.ps1 'C:\path\to\your\file.zip' 'My_Base_Name'
```

```powershell
.\getFileMD5.ps1 'C:\path\to\your\file.zip' -Debug
```

```powershell
.\getFileMD5.ps1 'C:\path\to\your\file.zip' 'My_Base_Name' -Debug
```