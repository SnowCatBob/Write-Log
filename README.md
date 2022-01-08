# Write-Log
This function receives a string as an input and it writes it to a text file. It automatically ads the date and time when the line was written in the text file on each line.

## Parameters
### InputObject
[REQUIRED]

The string to be written to the file.

### LogPath
[REQUIRED]

The full path where the text file should be written. Ex. C:\temp\LogFile.log

### LogLevelInfo
[OPTIONAL]

Use this switch if you would like to add the word INFO in front of the line in the text file.

Cannot be used with -LogLevelWarning or/and -LogLevelError.

### LogLevelWarning
[OPTIONAL]

Use this switch if you would like to add the word WARNING in front of the line in the text file.

Cannot be used with -LogLevelInfo or/and -LogLevelError.

### LogLevelError
[OPTIONAL]

Use this switch if you would like to add the word ERROR in front of the line in the text file.

Cannot be used with -LogLevelInfo or/and -LogLevelWarning.

### OverWrite
[OPTIONAL]

Use this switch if you would like to overwrite the file specified in the -Path parameter.

# Usage

## Example 1
```powershell
Write-Log -InputObject "This is a string" -LogPath C:\temp\LogFile.log -OverWrite
```
The above example will replace the file C:\temp\LogFile.log if it exists and add the line of text "This is a string" along with the date and time when it was written:

```text
[2018-09-25 15:06:31] : This is a string
```

## Example 2
```powershell
Write-Log -InputObject "File not found!" -LogPath C:\temp\LogFile.log -LogLevelError
```
The above example will add the text "File not found!" to the file C:\temp\LogFile.log along with the date and time when it was written and the word "ERROR":

```text  
[2018-09-25 15:16:16] : INFO    : Checking if file exists
[2018-09-25 15:16:17] : WARNING : File was not found in primary location, searching secondary
[2018-09-25 15:16:18] : ERROR   : File not found!
```

##Example 3
```powershell
try
{
	Write-Log -InputObject "Checking if process exists" -LogPath C:\temp\LogFile.log -LogLevelInfo
	Get-Process -Name "xyz" -ErrorAction Stop
}
catch
{
	Write-Log -InputObject $_ -LogPath C:\temp\LogFile.log -LogLevelError
}
```
The above example will try to find the process xyz on the system and if it odes not it will write the error to the file C:\temp\LogFile.log along with the date and time when it was written and the word "ERROR":

```text
[2018-09-25 15:16:16] : INFO    : Checking if process exists
  [2018-09-25 15:16:16] : ERROR   : Cannot find a process with the name "xyz". Verify the process name and call the cmdlet again.
```

# Version
1.0

# License
[GNU General Public License V3](https://www.gnu.org/licenses/gpl-3.0.en.html)
