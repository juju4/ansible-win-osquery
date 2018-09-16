# https://blogs.technet.microsoft.com/ashleymcglone/2013/08/28/powershell-get-winevent-xml-madness-getting-details-from-event-logs/
# Grab the events from a DC
$Events = Get-WinEvent -FilterHashtable @{Logname='osquery';Id=2}

# Parse out the event message data
ForEach ($Event in $Events) {
    # Convert the event to XML
    $eventXML = [xml]$Event.ToXml()
    # Iterate through each one of the XML message properties
    For ($i=0; $i -lt $eventXML.Event.EventData.Data.Count; $i++) {
        # Append these as object properties
        Add-Member -InputObject $Event -MemberType NoteProperty -Force `
            -Name  $eventXML.Event.EventData.Data[$i].name `
            -Value $eventXML.Event.EventData.Data[$i].'#text'
    }
}

$Event1 = Get-WinEvent -FilterHashtable @{Logname='osquery';Id=2} -MaxEvents 1
$Event1 | Format-List *
$Event1.Properties
$Event1XML = [xml]$Event1.ToXml()
$Event1XML.Event.EventData.Data

# View the results with your favorite output method
$Events | Export-Csv c:\osquery-events.csv
$Events
