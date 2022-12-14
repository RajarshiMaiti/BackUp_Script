Import-Module Lync
# $File = Get-Date -format ((Get-Culture).DateTimeFormat.ShortDatePattern)
$date=get-date -format "yyyy.MM.dd"
#cd "<Drive>:\Lync_Backup"
$folder_path="<Drive>:\Lync_Backup"
$folder_name="Lync_Backup_$date"
$file=$folder_path + "\" + $folder_name
md $file

# Export-CsUserData #
Export-CsUserData -PoolFqdn "<Pool1 FQDN>" -FileName "$file\UserData_EMEA.zip"
Export-CsUserData -PoolFqdn "<Pool2 FQDN>" -FileName "$file\UserData_APAC.zip"

#Topology Backup
(Get-CsTopology -AsXml).ToString() > "$file\Topology.xml"
 
#Dial-Plan Backup
Get-CsDialPlan | Export-Clixml -path "$file\Dial_Plans.xml"

#Voice-Policy Backup
Get-CsVoicePolicy | Export-Clixml -path "$file\Voice_Policies.xml"

#Voice-Route Backup
Get-CsVoiceRoute | Export-Clixml -path "$file\Voice_Routes.xml"

#PSTN-Usage Backup
Get-CsPstnUsage | Export-Clixml -path "$file\PSTN_Usages.xml"

#Voice-Configuration Backup
Get-CsVoiceConfiguration | Export-Clixml -path "$file\Voice_Configuration.xml"

#Trunk-Configuration Backup
Get-CsTrunkConfiguration | Export-Clixml -path "$file\Trunk_Configuration.xml"

# Export-CsRgsConfiguration #
Export-CsRgsConfiguration -Source "ApplicationServer:<Pool1 FQDN>" -FileName "$file\Rgs_EMEA.zip"
Export-CsRgsConfiguration -Source "ApplicationServer:<Pool2 FQDN>" -FileName "$file\Rgs_APAC.zip"

# Export-CsConfiguration #
Export-CsConfiguration -FileName "$file\Lync_Configuration.zip"

# Export-CsLisConfiguration #
Export-CsLisConfiguration -FileName "$file\LIS_Configuration.bak"

# Export-CsPersistentChatData #
Export-CsPersistentChatData -DBInstance "<Sql Server FQDN>" -FileName "$file\PChat.zip"


# Remove Backups older then 7 days
 
# set min age of files
$max_days = "-7"
  
# get the current date
$curr_date = Get-Date
 
# determine how far back we go based on current date
$del_date = $curr_date.AddDays($max_days)
 
# delete the files
Get-ChildItem $folder_path -Recurse | Where-Object { $_.LastWriteTime -lt $del_date } | Remove-Item -Recurse