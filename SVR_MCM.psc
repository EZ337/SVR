Scriptname SVR_MCM extends MCM_ConfigBase  
int Function getVersion()
  return 2
EndFunction

Event OnConfigInit()
  UpdateValsAll()
endEvent

event OnVersionUpdate(int a_version)
  if (a_version >= 2 && CurrentVersion < 2)
    OnConfigInit()
    debug.Notification("SVR: Updated to Version 2")
  endIf
endEvent

Event OnSettingChange(string a_ID)
  if a_ID == "fArmorRate2:Day2" ;Put this whole thing as a function
    svr_DR2.SetValue(GetModSettingFloat("fArmorRate2:Day2"))
    svr_PlayerDebuffPerk.SetNthEntryValue(8,0,(1 - svr_DR2.getValue()))
  elseif a_ID == "fHealResist2:Day2"
    svr_HE2.SetValue(GetModSettingFloat("fHealResist2:Day2"))
    svr_PlayerDebuffPerk.SetNthEntryValue(7,0,(1 - svr_HE2.getValue()))
  elseif a_ID == "fHealResist2b:Day2"
    svr_HE2b.SetValue(GetModSettingFloat("fHealResist2b:Day2"))
    svr_PlayerDebuffPerk.SetNthEntryValue(6,0,(1 - svr_HE2b.getValue()))
  elseif a_ID == "fArmorRate3:Day3"
    svr_DR3.SetValue(GetModSettingFloat("fArmorRate3:Day3"))
    svr_PlayerDebuffPerk.SetNthEntryValue(5,0,(1 - svr_DR3.getValue()))
  elseif a_ID == "fHealResist3:Day3"
    svr_HE3.SetValue(GetModSettingFloat("fHealResist3:Day3"))
    svr_PlayerDebuffPerk.SetNthEntryValue(4,0,(1 - svr_HE3.getValue()))
  elseif a_ID == "fHealResist3b:Day3"
    svr_HE3b.SetValue(GetModSettingFloat("fHealResist3b:Day3"))
    svr_PlayerDebuffPerk.SetNthEntryValue(3,0,(1 - svr_HE3b.getValue()))
  elseif a_ID == "fArmorRate4:Last6"
    svr_DR4.SetValue(GetModSettingFloat("fArmorRate4:Last6"))
    svr_PlayerDebuffPerk.SetNthEntryValue(2,0,(1 - svr_DR4.getValue()))
  elseif a_ID == "fHealResist4:Last6"
    svr_HE4.SetValue(GetModSettingFloat("fHealResist4:Last6"))
    svr_PlayerDebuffPerk.SetNthEntryValue(1,0,(1 - svr_HE4.getValue()))
  elseif a_ID == "fHealResist4b:Last6"
    svr_HE4b.SetValue(GetModSettingFloat("fHealResist4b:Last6"))
    svr_PlayerDebuffPerk.SetNthEntryValue(0,0,(1 - svr_HE4b.getValue()))
  elseif a_ID == "fHealthDamage6:Last6"
    svr_DamageHealthGV.SetValue(GetModSettingFloat("fHealthDamage6:Last6"))
    svr_DamageHealthSpell.SetNthEffectMagnitude(0,svr_DamageHealthGV.GetValue())
  elseif a_ID == "bRespawnPrompt:Debug"
    if GetModSettingBool("bRespawnPrompt:Debug") == 1
      svr_ReviveType.setValue(-1)
    Else
      svr_ReviveType.SetValue(GetModSettingInt("iDefaultRespawn:Debug"))
    endIf
  elseIf a_ID == "iDefaultRespawn:Debug"
    svr_ReviveType.SetValue(GetModSettingInt("iDefaultRespawn:Debug"))

  elseIf a_ID == "fDiseaseChance:Debug"
    svr_diseaseChance.SetValue(GetModSettingFloat("fDiseaseChance:Debug"))
  elseIf a_ID == "bDeathAltCompat:Debug"
    if GetModSettingBool("bDeathAltCompat:Debug") == 1
      svr_DeathAltCompat.setValue(1)
      SVR_QuestScript.Alias_essentialPlayer.Clear()
      svr_ReviveType.setValue(-1)
      SetModSettingBool("bRespawnPrompt:Debug", 1)
    Else
      svr_DeathAltCompat.SetValue(0)
      if playerRef.hasMagicEffect(DisDamageHealthVampire)
        SVR_QuestScript.alias_EssentialPlayer.forceRefto(PlayerRef)
      endIf
      UpdateValsAll()
    endIf
  ElseIf a_ID == "bUninstall:Debug"
    If getModSettingBool("bUninstall:Debug")
      Uninstall(True)
    else
      check = True
      UnInstallState = False
      svr_PlayerVampireQuest.start()
      SVR_QuestScript.Alias_Player.ForceRefIfEmpty(PlayerRef)
      UpdateValsAll()
    EndIf
  endIf
EndEvent

Event OnConfigClose()
  if playerRef.hasSpell(svr_PlayerDebuffSpell) || svr_PlayerVampireQuest.GetStage()>=20
      playerRef.RemoveSpell(svr_playerDebuffSpell)
      playerRef.AddSpell(svr_PlayerDebuffSpell,false)
  endIf

  if playerRef.hasSpell(svr_DamageHealthSpell) || svr_PlayerVampireQuest.GetStage() == 40
    playerRef.RemoveSpell(svr_DamageHealthSpell)
    playerRef.AddSpell(svr_DamageHealthSpell,false)
  endIf
  ConsitencyCheck()
endEvent

;Checks MCM values with ini and with global.
Function ConsitencyCheck()
  if check
    if svr_PlayerDebuffPerk.getNthEntryValue(8,0) !=  (1 - GetModSettingFloat("fArmorRate2:Day2"))
      debug.MessageBox("DR2 != MCM. Update all Values in MCM")
    endIf
    if svr_PlayerDebuffPerk.getNthEntryValue(7,0) != (1 - svr_HE2.getValue())
      debug.messagebox("HE2 != MCM Update all Values in MCM")
    endIf
    if svr_PlayerDebuffPerk.getNthEntryValue(6,0) != (1 - svr_HE2b.getValue())
      debug.messagebox("HE2b != MCM Update all Values in MCM")
    endIf
    if svr_PlayerDebuffPerk.getNthEntryValue(5,0) !=  (1 - svr_DR3.getValue())
        debug.MessageBox("DR3 != MCM Update all Values in MCM")
    endIf
    if svr_PlayerDebuffPerk.getNthEntryValue(4,0) != (1 - svr_HE3.getValue())
      debug.messagebox("HE3 != MCM Update all Values in MCM")
    endIf
    if svr_PlayerDebuffPerk.getNthEntryValue(3,0) != (1 - svr_HE3b.getValue())
      debug.messagebox("HE3b != MCM Update all Values in MCM")
    endIf
    if svr_PlayerDebuffPerk.getNthEntryValue(2,0) !=  (1 - svr_DR4.getValue())
      debug.MessageBox("DR4 != MCM Update all Values in MCM")
    endIf
    if svr_PlayerDebuffPerk.getNthEntryValue(1,0) != (1 - svr_HE4.getValue())
      debug.messagebox("HE4 != MCM Update all Values in MCM")
    endIf
    if svr_PlayerDebuffPerk.getNthEntryValue(0,0) != (1 - svr_HE4b.getValue())
      debug.messagebox("HE4b != MCM Update all Values in MCM")
    endIf
    if GetModSettingFloat("fDiseaseChance:Debug") != svr_diseaseChance.getValue()
      debug.MessageBox("Disease Chance does not match")
    endIf
    if !SVR_QuestScript.alias_DeathLoc.getRef()
      debug.Notification("SVR: Lost or No respawnpoint. Fixing...")
      if svr_DeathMarker
        SVR_QuestScript.Alias_DeathLoc.ForceRefTo(svr_deathMarker)
      else
        svr_DeathMarker = playerRef.placeatme(xMarkerHeading)
        SVR_QuestScript.Alias_DeathLoc.ForceRefTo(svr_DeathMarker)
        debug.Notification("Created a new one")
      endIf
    else
      svr_deathMarker = SVR_QuestScript.alias_DeathLoc.getRef()
    endIf
    if GetModSettingBool("bDeathAltCompat:Debug") != svr_DeathAltCompat.getValue()
      debug.messagebox("Death Compatibility ini does not match mcm. Update Values")
    ElseIf GetModSettingBool("bDeathAltCompat:Debug") == 0 && !SVR_QuestScript.Alias_essentialPlayer.GetActorRef() && PlayerRef.IsEssential()
      debug.Notification("SVR: Might want to activate Alternate Death Compatibility")
    endIf
    if GetModSettingBool("bUninstall:Debug")
      UnInstallState = 1
      If (svr_PlayerVampireQuest.IsRunning())
        svr_PlayerVampireQuest.stop()
      endIf
    Else
      UnInstallState = 0
      If (!svr_PlayerVampireQuest.IsRunning())
        svr_PlayerVampireQuest.Start()
      EndIf
    EndIf
  endIf
EndFunction

;Updates all MCM values and settings to match ini
Function UpdateValsAll(string sMessage = "")
  if sMessage ;I can't pass the values properly with MCM call it seems. It always evaluates to false
    debug.MessageBox(sMessage)
  endIf
  
  svr_DR2.SetValue(GetModSettingFloat("fArmorRate2:Day2"))
  svr_PlayerDebuffPerk.SetNthEntryValue(8,0,(1 - svr_DR2.getValue()))
  svr_HE2.SetValue(GetModSettingFloat("fHealResist2:Day2"))
  svr_PlayerDebuffPerk.SetNthEntryValue(7,0,(1 - svr_HE2.getValue()))
  svr_HE2b.SetValue(GetModSettingFloat("fHealResist2b:Day2"))
  svr_PlayerDebuffPerk.SetNthEntryValue(6,0,(1 - svr_HE2b.getValue()))
  svr_PlayerDebuffPerk.SetNthEntryValue(5,0,(1 - svr_DR3.getValue()))
  svr_PlayerDebuffPerk.SetNthEntryValue(4,0,(1 - svr_HE3.getValue()))
  svr_PlayerDebuffPerk.SetNthEntryValue(3,0,(1 - svr_HE3b.getValue()))
  svr_PlayerDebuffPerk.SetNthEntryValue(2,0,(1 - svr_DR4.getValue()))
  svr_PlayerDebuffPerk.SetNthEntryValue(1,0,(1 - svr_HE4.getValue()))
  svr_PlayerDebuffPerk.SetNthEntryValue(0,0,(1 - svr_HE4b.getValue()))
  svr_diseaseChance.SetValue(GetModSettingFloat("fDiseaseChance:Debug"))
  if GetModSettingBool("bDeathAltCompat:Debug") == 1
    svr_DeathAltCompat.setValue(1)
    SVR_QuestScript.Alias_essentialPlayer.Clear()
  Else
    svr_DeathAltCompat.SetValue(0)
    if playerRef.hasMagicEffect(DisDamageHealthVampire)
      SVR_QuestScript.alias_EssentialPlayer.forceRefto(PlayerRef)
    endIf
  endIf
  if GetModSettingBool("bRespawnPrompt:Debug") == 1
    svr_ReviveType.setValue(-1)
  Else
    svr_ReviveType.SetValue(GetModSettingInt("iDefaultRespawn:Debug"))
  endIf
  if UnInstallState
    Uninstall()
    DisDamageHealthVampire.ClearEffectFlag(0x00008000) ;Important but unecessary
  else
    DisDamageHealthVampire.SetEffectFlag(0x00008000) ;Hides effect from UI
  endif
EndFunction

;Manual Teleportation
Function SVR_Moveto()
  
  ;ShowMessage("Close menu to confirm")
  if svr_TP.getValue() == 0
    debug.MessageBox("No Valid Teleport")
  else
    debug.MessageBox("Leave the menu to confirm")
    int choice = svr_MovetoConfirm.show()
      if choice == 1
        svr_TP.setValue(0)
        playerRef.moveto(svr_deathMarker, abMatchRotation = false)
       endIf
  endIf
EndFunction

Function SVR_ContractDisease()
  svr_diseaseChance.SetValue(100)
  PlayerRef.AddSpell(DiseaseSanguinareVampiris)
  svr_diseaseChance.SetValue(GetModSettingFloat("fDiseaseChance:Debug"))
  debug.messagebox("Applying Disease...")
EndFunction

Function Uninstall(bool Verbose = False)
  SetModSettingBool("bUninstall:Debug", 1)
  SVR_QuestScript.Alias_DeathLoc.Clear()
  SVR_QuestScript.Alias_essentialPlayer.clear()
  ;PO3_Events_Alias.UnregisterForMagicEffectApplyEx(IncubationScript,DisDamageHealthVampire,true)
  svr_PlayerVampireQuest.stop()
  svr_DeathMarker.Delete() ;Marks for delete
  svr_DeathMarker = None ;Removes it from property
  PlayerRef.removeSpell(svr_DamageHealthSpell)
  playerRef.removeSpell(svr_playerDebuffSpell)
  DisDamageHealthVampire.ClearEffectFlag(0x00008000)
  check = False
  UnInstallState = True
  if verbose
    debug.messagebox("SVR: Ready for uninstall.")
  endIf
EndFunction

Function RestartMQ()
  ;debug.MessageBox("Restarting Quest Function")
  svr_PlayerVampireQuest.reset()
  While !svr_playerVampireQuest.IsRunning()
    utility.wait(3)
    svr_PlayerVampireQuest.start()
    SVR_QuestScript.Alias_DeathLoc.ForceRefIfEmpty(svr_DeathMarker)
    ;debug.MessageBox("Successfully restarted quest")
  EndWhile
EndFunction

Quest Property svr_PlayerVampireQuest Auto
SVR_PlayerVampireQuestScript Property SVR_QuestScript Auto
VampireDiseaseEffectScript Property DiseaseEffectScript Auto
SVR_IncubationMonitor Property IncubationScript Auto
ObjectReference Property svr_DeathMarker Auto
message Property svr_MovetoConfirm Auto
spell Property svr_DamageHealthSpell Auto
spell Property svr_PlayerDebuffSpell Auto
spell Property DiseaseSanguinareVampiris Auto
perk Property svr_PlayerDebuffPerk Auto
MagicEffect Property DisDamageHealthVampire Auto
GlobalVariable Property svr_TP Auto
GlobalVariable Property svr_DamageHealthGV Auto
GlobalVariable Property svr_DR2 Auto
GlobalVariable Property svr_HE2 Auto
GlobalVariable Property svr_HE2b Auto
GlobalVariable Property svr_DR3 Auto
GlobalVariable Property svr_HE3 Auto
GlobalVariable Property svr_HE3b Auto
GlobalVariable Property svr_DR4 Auto
GlobalVariable Property svr_HE4 Auto
GlobalVariable Property svr_HE4b Auto
GlobalVariable Property svr_ReviveType Auto
GlobalVariable Property svr_DeathAltCompat Auto
GlobalVariable Property svr_diseaseChance Auto
Actor Property PlayerRef Auto
Static Property xMarkerHeading Auto
bool Property check = True Auto
bool Property UnInstallState = False Auto
