Function Send-Zabbix {
    <#
        .SYNOPSIS
            Writes a custom message to zabbix server.
            In order to work the parent function should have a key in zabbix under "Template Misc Notifications"
    
        .PARAMETER  Message
            The message to be shown in zabbix

        .PARAMETER  Key
            Should be the name of the function. can be generated using $MyInvocation.InvocationName
    
        .EXAMPLE
            PS C:\> Send-Zabbix -Message "Please Run the script again" -Key $MyInvocation.InvocationName
    
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Message,

        [Parameter(Position=1, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Key,

        [Parameter(Position=2, Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Hostname = "Misc Notifications"
    )

    $ZabSenderPath = "C:\Zabbix\bin\win64"
    $ZabbixIP = "CCHHAANNGGEETTHHIISS"

    # Gets the server IP address to a variable
    $IP = (Invoke-WebRequest icanhazip.com).content

    # Sends the alert
    &"$ZabSenderPath\zabbix_sender.exe" -z $ZabbixIP -s "$Hostname" -k $Key -o "$IP : $Message"

    Switch ($LASTEXITCODE){
        2 {throw "Zabbix Sender ERROR: Data was sent, but processing failed. Maybe bad key?"}
        1 {throw "Zabbix Sender ERROR: Sent failed. please check."}
        0 {Write-Log "$Message - Sent to $ZabbixIP"}
    }      
}