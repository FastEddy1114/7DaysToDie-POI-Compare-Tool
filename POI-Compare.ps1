# Created 12-28-2021, Completed 12-30-2021
# This script is used to compare the vanilla POIs in 7 Days to Die to your RWG world to see which POIs have actually been placed into your world
# Tested and working on Windows running PowerShell 7
# PowerShell 7 can be obtained from here https://github.com/powershell/powershell

# Uncomment the two lines below if you would like to hardcode your 7 Days to Die folder paths and not have to enter them each time the compare script is ran, If only hard coding the 7DaysRootInstallPath then be sure to comment out the corresonding line for the same varible in the lower dynamic section on line 14

# $7DaysRootInstallPath = "C:\SteamServers\7DaysToDie"; # Modify this path to the root of your 7 Days to Die install folder, to not include a trailing \

# $7DaysRWGPOIs = Get-Content -Path "C:\SteamServers\7DaysToDie\Data\Worlds\GeneratedWorlds\Navika County\prefabs.xml"; # Modify this path to point to the prefabs.xml file within your custom RWG world folder

# Comment the six lines below out if you are using the hard coded method above

$7DaysRootInstallPath = Read-Host -Prompt "`n`tEnter the absolute path to the root of your 7 Days to Die install folder, do not include trailing \`n`n`tExample: C:\Program Files (x86)\Steam\steamapps\common\7 Days To Die`n`t";

Clear-Host;

$7DaysRWGPOIs = Read-Host -Prompt "`n`tEnter the absolute path to your custom RWG world folder, do not include trailing \`n`n`tIn the folder you specify here you should be able to see a prefabs.xml file`n`n`tIf you do you have the right folder path`n`n`tExample: C:\Program Files (x86)\Steam\steamapps\common\7 Days To Die\Data\Worlds\Navezgane`n`t";

Clear-Host

$7DaysRWGPOIs = $7DaysRWGPOIs + "\prefabs.xml"

$7DaysRWGPOIs = Get-Content -Path $7DaysRWGPOIs;

#Do not modify below this line

$7DaysPOIs = "\Data\Prefabs\POIs\*";

$7DaysFullPOIPath = $7DaysRootInstallPath + $7DaysPOIs;

$AllPOIxmls = Get-ChildItem -Path $7DaysFullPOIPath -Include "*.xml";

foreach ($file in $AllPOIxmls) {
    $TempData = Get-Content -Path $file;
    foreach ($part in $TempData) {
        if ($part -match "DifficultyTier") {
            $DT = $part;
            $DT = -split $DT;
            foreach ($subpart in $DT) {
                if ($subpart -match "value=") {
                    $DTv = $subpart;
                    $DTv = $DTv.Trim("value=");
                    $DTv = $DTv.Trim('"');
                    $AllDTs = $file.Name.Trim(".xml") + " " + "Tier=" + $DTv + ":" + $AllDTs;
                }
            }
        }
    }
}

$AllDTs = $AllDTs -split (":") | Sort-Object -Unique;

foreach ($apoiwt in $AllDTs) {
    $2LipoiDT = -split $apoiwt;
    $Tier = $2LipoiDT[1];
    if ($Tier -match "0") {
        $aTier0s++;
    }
    if ($Tier -match "1") {
        $aTier1s++;
    }
    if ($Tier -match "2") {
        $aTier2s++;
    }
    if ($Tier -match "3") {
        $aTier3s++;
    }
    if ($Tier -match "4") {
        $aTier4s++;
    }
    if ($Tier -match "5") {
        $aTier5s++;
    }
}

$RWGpoiContents = -split $7DaysRWGPOIs;

foreach ($part in $RWGpoiContents) {
    if ($part -match "name=" ) {
        $RWGpoiNames = $part + " " + $RWGpoiNames
    }
}

$RWGpoiNames = -split $RWGpoiNames;

$RWGpoiNames = $RWGpoiNames | ForEach-Object -Process { $_.Trim("name=") } | ForEach-Object -Process { $_.Trim('"') } | Sort-Object -Unique;

foreach ($poiwt in $AllDTs) {
    $2LpoiDT = -split $poiwt;
    $PName = $2LpoiDT[0];
    if ($PName -ne "") {
        $RPName = Select-String -InputObject $RWGpoiNames -Pattern $PName -SimpleMatch -NoEmphasis -Quiet;
    }
    if ($RPName -eq $true) {
        $RWGpoiNDTeq = $PName + " " + $2LpoiDT[1] + ":" + $RWGpoiNDTeq;
    }
    if ($null -eq $RPName) { # line may need updated if Select-String -Quiet is fixed to properly output $false instead of incorect $null when -Pattern is not found
        $RWGpoiNDTne = $PName + " " + $2LpoiDT[1] + ":" + $RWGpoiNDTne;
    }
}

$RWGpoiNDTeq = $RWGpoiNDTeq -split (":") | Sort-Object -Unique;

$RWGpoiNDTne = $RWGpoiNDTne -split (":") | Sort-Object -Unique;

foreach ($ipoiwt in $RWGpoiNDTeq) {
    $2LipoiDT = -split $ipoiwt;
    $Tier = $2LipoiDT[1];
    if ($Tier -match "0") {
        $iTier0s++;
    }
    if ($Tier -match "1") {
        $iTier1s++;
    }
    if ($Tier -match "2") {
        $iTier2s++;
    }
    if ($Tier -match "3") {
        $iTier3s++;
    }
    if ($Tier -match "4") {
        $iTier4s++;
    }
    if ($Tier -match "5") {
        $iTier5s++;
    }
}

foreach ($mpoiwt in $RWGpoiNDTne) {
    $2LmpoiDT = -split $mpoiwt;
    $Tier = $2LmpoiDT[1];
    if ($Tier -match "0") {
        $mTier0s++;
    }
    if ($Tier -match "1") {
        $mTier1s++;
    }
    if ($Tier -match "2") {
        $mTier2s++;
    }
    if ($Tier -match "3") {
        $mTier3s++;
    }
    if ($Tier -match "4") {
        $mTier4s++;
    }
    if ($Tier -match "5") {
        $mTier5s++;
    }
}

function ListPOIsInRWG {
    Write-Host -Object "`n`tThe following POIs are in your RWG world:`n" -BackgroundColor Black -ForegroundColor Green;
    Out-Host -InputObject $RWGpoiNDTeq -Paging;
    Write-Host -Object "`n`tYou have the following totals of unique POIs in your RWG world:`n`n`tTier 0 = $iTier0s`n`tTier 1 = $iTier1s`n`tTier 2 = $iTier2s`n`tTier 3 = $iTier3s`n`tTier 4 = $iTier4s`n`tTier 5 = $iTier5s" -BackgroundColor Black -ForegroundColor Green;
    Write-Host -Object "`n`tTotal unique POIs in 7 Days to Die Prefabs\POIs folder:`n`n`tTier 0 = $aTier0s`n`tTier 1 = $aTier1s`n`tTier 2 = $aTier2s`n`tTier 3 = $aTier3s`n`tTier 4 = $aTier4s`n`tTier 5 = $aTier5s" -BackgroundColor Black -ForegroundColor Green;
}

function OutputPOIsInRWG {
    $UserLocation = Read-Host -Prompt "`n`tOutputting Included POI results:`n`n`tEnter the absolute path to where you would like the file saved without trailing \`n`t";
    $UserFileName = Read-Host -Prompt "`n`tEnter the name of the file (without file extension), file will be saved as .txt`n`n`tThe file will be opened with your default text editor after it is saved`n`t";
    $FullPath = $UserLocation + "\" + $UserFileName + ".txt";
    $RWGpoiNDTeq | Out-File -FilePath $FullPath;
    Add-Content -Path $FullPath -Value "`nThe above are all POIs in your RWG world";
    Add-Content -Path $FullPath -Value "`n`tYou have the following totals of unique POIs in your RWG world:`n`n`tTier 0 = $iTier0s`n`tTier 1 = $iTier1s`n`tTier 2 = $iTier2s`n`tTier 3 = $iTier3s`n`tTier 4 = $iTier4s`n`tTier 5 = $iTier5s";
    Add-Content -Path $FullPath -Value "`n`tTotal unique POIs in 7 Days to Die Prefabs\POIs folder:`n`n`tTier 0 = $aTier0s`n`tTier 1 = $aTier1s`n`tTier 2 = $aTier2s`n`tTier 3 = $aTier3s`n`tTier 4 = $aTier4s`n`tTier 5 = $aTier5s";
    Invoke-Item -Path $FullPath;
}

function ListPOIsNotInRWG {
    Write-Host -Object "`n`tThe following POIs are missing from your RWG world:`n" -BackgroundColor Black -ForegroundColor Red;
    Out-Host -InputObject $RWGpoiNDTne -Paging;
    Write-Host -Object "`n`tYou have the following totals of unique POIs missing from your RWG world:`n`n`tTier 0 = $mTier0s`n`tTier 1 = $mTier1s`n`tTier 2 = $mTier2s`n`tTier 3 = $mTier3s`n`tTier 4 = $mTier4s`n`tTier 5 = $mTier5s" -BackgroundColor Black -ForegroundColor Red;
    Write-Host -Object "`n`tTotal unique POIs in 7 Days to Die Prefabs\POIs folder:`n`n`tTier 0 = $aTier0s`n`tTier 1 = $aTier1s`n`tTier 2 = $aTier2s`n`tTier 3 = $aTier3s`n`tTier 4 = $aTier4s`n`tTier 5 = $aTier5s" -BackgroundColor Black -ForegroundColor Green;
}

function OutputPOIsNotInRWG {
    $UserLocation = Read-Host -Prompt "`n`tOutputting Missing POI results:`n`n`tEnter the absolute path to where you would like the file saved without trailing \`n`t";
    $UserFileName = Read-Host -Prompt "`n`tEnter the name of the file (without file extension), file will be saved as .txt`n`n`tThe file will be opened with your default text editor after it is saved`n`t";
    $FullPath = $UserLocation + "\" + $UserFileName + ".txt";
    $RWGpoiNDTne | Out-File -FilePath $FullPath;
    Add-Content -Path $FullPath -Value "`nThe above are all POIs missing from your RWG world";
    Add-Content -Path $FullPath -Value "`n`tYou have the following totals of unique POIs missing from your RWG world:`n`n`tTier 0 = $mTier0s`n`tTier 1 = $mTier1s`n`tTier 2 = $mTier2s`n`tTier 3 = $mTier3s`n`tTier 4 = $mTier4s`n`tTier 5 = $mTier5s";
    Add-Content -Path $FullPath -Value "`n`tTotal unique POIs in 7 Days to Die Prefabs\POIs folder:`n`n`tTier 0 = $aTier0s`n`tTier 1 = $aTier1s`n`tTier 2 = $aTier2s`n`tTier 3 = $aTier3s`n`tTier 4 = $aTier4s`n`tTier 5 = $aTier5s";
    Invoke-Item -Path $FullPath;
}

# Menu creation in Do/While block
Do {
    Write-Host -Object "_" -BackgroundColor Black -ForegroundColor Black
    Write-Host -Object "_" -BackgroundColor Black -ForegroundColor Black
    Write-Host -Object "    *********************************************************************************************************" -BackgroundColor Black -ForegroundColor Green
    Write-Host -Object "    *                                     7 Days to Die POI Compare                                         *" -BackgroundColor Black -ForegroundColor Green
    Write-Host -Object "    *                                                                                                       *" -BackgroundColor Black -ForegroundColor Green
    Write-Host -Object "    *                               Select your choice from the menu below                                  *" -BackgroundColor Black -ForegroundColor Green
    Write-Host -Object "    *            This compare tool looks at the vanilla POI prefabs folder to make its comparisons          *" -BackgroundColor Black -ForegroundColor Green
    Write-Host -Object "    *                         To compare a second world please use 5 to exit the tool                       *" -BackgroundColor Black -ForegroundColor Green
    Write-Host -Object "    *                then relaunch the script to make sure the variables are regenerated each time          *" -BackgroundColor Black -ForegroundColor Green
    Write-Host -Object "    *                                                                                                       *" -BackgroundColor Black -ForegroundColor Green
    Write-Host -Object "    *   1 = List all POIs in your RWG world                                                                 *" -BackgroundColor Black -ForegroundColor Green
    Write-Host -Object "    *   2 = Output POIs in your RWG world results to file                                                   *" -BackgroundColor Black -ForegroundColor DarkYellow
    Write-Host -Object "    *   3 = List all POIs that are missing from your RWG world                                              *" -BackgroundColor Black -ForegroundColor Red
    Write-Host -Object "    *   4 = Output POIs missing from your RWG world results to file                                         *" -BackgroundColor Black -ForegroundColor DarkYellow
    Write-Host -Object "    *   5 = Exit tool                                                                                       *" -BackgroundColor Black -ForegroundColor Green
    Write-Host -Object "    *                                                                                                       *" -BackgroundColor Black -ForegroundColor Green
    Write-Host -Object "    *********************************************************************************************************" -BackgroundColor Black -ForegroundColor Green
    $Global:MenuOption = Read-Host -Prompt "    Enter your menu selection here"
    Clear-Host # Moved to after the menu display rather than before so that any output errors from running the functions can be viewed before the screen is cleared to regenerate the menu

    if ($MenuOption -in 1,2,3,4,5 ) {
    switch ($MenuOption) {
        1 { ListPOIsInRWG }
        2 { OutputPOIsInRWG }
        3 { ListPOIsNotInRWG }
        4 { OutputPOIsNotInRWG }
        5 { Write-Host -Object "`n`t**** You have closed the 7 Days to Die POI compare tool ****`n" -BackgroundColor Black -ForegroundColor DarkYellow }
        Default {}
    }
}
    else {
        Write-Host -Object "`n`t**** ERROR: Your entry of $MenuOption is invalid. Options 1, 2, 3, 4, or 5 are the only valid selections, please try again. ****`n" -BackgroundColor Black -ForegroundColor Red
    }

} while ( $MenuOption -ne 5 )