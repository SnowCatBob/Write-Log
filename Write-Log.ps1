<#
.SYNOPSIS
  Writes the given string to a text file. Automatically ads the date and time to each line written in the file.
.DESCRIPTION
  This function receives a string as an input and it writes it to a text file (.log). It automatically ads the date and time when the line was written in the text file on each line.
.PARAMETER InputObject
  [REQUIRED]
  The string to be written to the file.
.PARAMETER LogPath
  [REQUIRED]
  The full path where the text file should be written. Ex. C:\temp\LogFile.log
.PARAMETER LogLevelInfo
  [OPTIONAL]
  Use this switch if you would like to add the word INFO in front of the line in the text file.
  Cannot be used with -LogLevelWarning or/and -LogLevelError.
.PARAMETER LogLevelWarning
  [OPTIONAL]
  Use this switch if you would like to add the word WARNING in front of the line in the text file.
  Cannot be used with -LogLevelInfo or/and -LogLevelError.
.PARAMETER LogLevelError
  [OPTIONAL]
  Use this switch if you would like to add the word ERROR in front of the line in the text file.
  Cannot be used with -LogLevelInfo or/and -LogLevelWarning.
.PARAMETER OverWrite
  [OPTIONAL]
  Use this switch if you would like to overwrite the file specified in the -Path parameter.
.INPUTS
  A string.
.OUTPUTS
  A txt file containing the string.
.NOTES
  Version:        1.0
  Author:         SnowCatBob
  Project location: https://github.com/SnowCatBob/Write-Log
.EXAMPLE
  Write-Log -InputObject "This is a string" -LogPath C:\temp\LogFile.log -OverWrite
  The above example will replace the file C:\temp\LogFile.log if it exists and add the line of text "This is a string" along with the date and time when it was written:
  
  [2018-09-25 15:06:31] : This is a string
  
.EXAMPLE
  Write-Log -InputObject "File not found!" -LogPath C:\temp\LogFile.log -LogLevelError
  The above example will add the text "File not found!" to the file C:\temp\LogFile.log along with the date and time when it was written and the word "ERROR":
  
  [2018-09-25 15:16:16] : INFO    : Checking if file exists
  [2018-09-25 15:16:17] : WARNING : File was not found in primary location, searching secondary
  [2018-09-25 15:16:18] : ERROR   : File not found!
  
.EXAMPLE
  try {
	Write-Log -InputObject "Checking if process exists" -LogPath C:\temp\LogFile.log -LogLevelInfo
	Get-Process -Name "xyz" -ErrorAction Stop
  }
  catch {
	Write-Log -InputObject $_ -LogPath C:\temp\LogFile.log -LogLevelError
  }
  The above example will try to find the process xyz on the system and if it odes not it will write the error to the file C:\temp\LogFile.log along with the date and time when it was written and the word "ERROR":
  
  [2018-09-25 15:16:16] : INFO    : Checking if process exists
  [2018-09-25 15:16:16] : ERROR   : Cannot find a process with the name "xyz". Verify the process name and call the cmdlet again.
#>
Function Write-Log
{
	Param(
		[parameter(Mandatory=$True)] [String] $InputObject,
		[parameter(Mandatory=$True)] [String] $LogPath,
		[switch] $LogLevelInfo,
		[switch] $LogLevelWarning,
		[switch] $LogLevelError,
		[switch] $OverWrite
	)
	if($LogLevelInfo -and $LogLevelWarning -and $LogLevelError)
	{
		Write-Warning "You cannot specify 3 logging levels for a log line (INFO, WARNING and ERROR). Using UNKNOWN for this log line."
		$InputObject = "UNKNOWN : $InputObject"
	}
	if($LogLevelInfo -and $LogLevelWarning)
	{
		Write-Warning "You cannot specify 2 logging levels for a log line (INFO and WARNING). Using UNKNOWN for this log line."
		$InputObject = "UNKNOWN : $InputObject"
	}
	elseif($LogLevelWarning -and $LogLevelError)
	{
		Write-Warning "You cannot specify 2 logging levels for a log line (WARNING and ERROR). Using UNKNOWN for this log line."
		$InputObject = "UNKNOWN : $InputObject"
	}
	elseif($LogLevelInfo -and $LogLevelError)
	{
		Write-Warning "You cannot specify 2 logging levels for a log line (INFO and ERROR). Using UNKNOWN for this log line."
		$InputObject = "UNKNOWN : $InputObject"
	}
	elseif($LogLevelInfo)
	{
		$InputObject = "INFO    : $InputObject"
	}
	elseif($LogLevelWarning)
	{
		$InputObject = "WARNING : $InputObject"
	}
	elseif($LogLevelError)
	{
		$InputObject = "ERROR   : $InputObject"
	}
	$LogTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
	$LogLine = "[$LogTime] : $InputObject"
	if($OverWrite)
	{
		$LogLine | Out-File -FilePath $LogPath
	}
	else
	{
		$LogLine | Out-File -FilePath $LogPath -Append
	}
}