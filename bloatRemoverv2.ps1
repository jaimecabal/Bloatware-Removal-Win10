# Script to check which apps come naturally with Win10
# Author: Jaime Cabal
# Source:
# [TRON Script]()
# +
# [This commment on reddit](https://www.reddit.com/r/sysadmin/comments/6l0lb5/powershell_script_to_remove_default_apps_from/djq7h8t?utm_source=share&utm_medium=web2x)
# This script does not let you remove all apps, as Windows has made some apps essential to the OS
# PowerShell Version: 5.1

$AppsList = 
    '07AF453C.IndexCards',
    '2414FC7A.Viber',
    '2FE3CB00.PicsArt-PhotoStudio',
    '41038Axilesoft.ACGMediaPlayer',
    '46928bounde.EclipseManager',
    '4DF9E0F8.Netflix',
    '64885BlueEdge.OneCalendar',
    '6Wunderkinder.Wunderlist',
    '7458BE2C.WorldofTanksBlitz',
    '7EE7776C.LinkedInforWindows',
    '8075Queenloft.BlendCollagePhotoEditor',
    '828B5831.HiddenCityMysteryofShadows',
    '89006A2E.AutodeskSketchBook',
    '9E2F88E3.Twitter',
    'A278AB0D.DisneyMagicKingdoms',
    'A278AB0D.DragonManiaLegends',
    'A278AB0D.MarchofEmpires',
    'ActiproSoftwareLLC.562882FEEB491',
    'AdobeSystemsIncorporated.AdobePhotoshopExpress',
    'CAF9E577.Plex',
    'ClearChannelRadioDigital.iHeartRadio',
    'D52A8D61.FarmVille2CountryEscape',
    'DB6EA5DB.CyberLinkMediaSuiteEssentials',
    'D5EA27b7.Duolingo-LearnLanguagesforFree',
    'DolbyLaboratories.DolbyAccess',
    'Drawboard.DrawboardPDF',
    'Facebook.317180B0BB486',
    'Facebook.Facebook',
    'Facebook.InstagramBeta',
    'flaregamesGmbH.RoyalRevolt2',
    'Flipboard.Flipboard',
    'GAMELOFTSA.Asphalt8Airborne',
    'KeeperSecurityInc.Keeper',
    'king.com.BubbleWitch3Saga',
    'king.com.CandyCrushFriends',
    'king.com.CandyCrushSaga',
    'NORDCURRENT.COOKINGFEVER',
    'Microsoft.3DBuilder',
    'Microsoft.Advertising.Xaml',
    'Microsoft.AgeCastles',
    'Microsoft.BingFinance',
    'Microsoft.BingFoodAndDrink',
    'Microsoft.BingHealthAndFitness',
    'Microsoft.BingNews',
    'Microsoft.BingMaps',
    'Microsoft.BingTranslator',
    'Microsoft.BingTravel',
    'Microsoft.BingSports',
    'Microsoft.BingWeather',
    'Microsoft.Getstarted',
    'Microsoft.GetHelp',
    'Microsoft.HelpAndTips',
    'Microsoft.Office.OneNote',
    'Microsoft.People',
    'Microsoft.Messaging',
    'Microsoft.MicrosoftJackpot',
    'Microsoft.MicrosoftJigsaw',
    'Microsoft.MicrosoftMahjong',
    'Microsoft.MicrosoftOfficeHub',
    'Microsoft.MicrosoftSolitaireCollection',
    'Microsoft.MicrosoftStickyNotes',
    'Microsoft.MicrosoftSudoku',
    'Microsoft.MinecraftUWP',
    'Microsoft.Windows.Photos', 
    'Microsoft.WindowsCamera',
    'microsoft.windowscommunicationsapps', 
    'Microsoft.WindowsPhone',
    'Microsoft.WindowsSoundRecorder',
    'Microsoft.WindowsFeedbackHub',
    'Microsoft.XboxApp',
    'Microsoft.XboxGameOverlay',
    'Microsoft.XboxGamingOverlay',
    'Microsoft.XboxIdentityProvider',
    'Microsoft.XboxSpeechToTextOverlay',
    'Microsoft.YourPhone',
    'Microsoft.ZuneMusic',
    'Microsoft.ZuneVideo'

    $appExist=@()
    $appNotExist=@()
    $provisionAppExist=@()
    $provisionAppNotExist=@()
    $appInstalled=@()
    $appsProvisioned=@()
    #Make a file to store the installed programs before the removal
    if (Test-Path -Path .\installedApps.txt) {
        Remove-Item .\installedApps.txt
        New-Item -path . -name "installedApps.txt" -itemtype "file"
    }
    else{   
        New-Item -path . -name "installedApps.txt" -itemtype "file"
    }
    
    Add-Content "Apps on the system" -Path .\installedApps.txt
    ForEach ($App in $AppsList){
        $PackageFullName = (Get-AppxPackage $App).PackageFullName
        if ($PackageFullName){
            $appExist = $appExist + $PackageFullName
            $appInstalled = $appInstalled + $PackageFullName
            Add-Content $PackageFullName -Path .\installedApps.txt
        }
        else{
            $appNotExist = $appNotExist + $App
        }
    }

    Add-Content "Provisioned Apps on the system" -Path .\installedApps.txt
    ForEach ($App in $AppsList){
        $ProPackageFullName = (Get-AppxProvisionedPackage -online | Where-Object {$_.Displayname -eq $App}).PackageName
        if ($ProPackageFullName){
            $provisionAppExist = $provisionAppExist + $ProPackageFullName
            $appsProvisioned = $appsProvisioned + $PackageFullName
            Add-Content $ProPackageFullName -Path .\installedApps.txt
        }
        else{
            $provisionAppNotExist = $provisionAppNotExist + $App
        }
    }
    ForEach ($App in $appInstalled){
        $PackageFullName = (Get-AppxPackage $App).PackageFullName
        Remove-AppxPackage -package $PackageFullName -AllUsers
    }
    ForEach ($App in $appsProvisioned){
        $ProPackageFullName = (Get-AppxProvisionedPackage -online | where {$_.Displayname -eq $App}).PackageName
        Remove-AppxProvisionedPackage -online -packagename $ProPackageFullName
    }