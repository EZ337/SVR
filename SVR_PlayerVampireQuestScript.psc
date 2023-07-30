;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 40
Scriptname SVR_PlayerVampireQuestScript Extends Quest Hidden

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY essentialPlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_essentialPlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY DeathLoc
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_DeathLoc Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_37
Function Fragment_37()
;BEGIN CODE
playerRef.removespell(svr_damageHealthSpell)
playerRef.removeSpell(svr_playerDebuffSpell)
svr_daysPast.setValue(0)
alias_essentialPlayer.clear()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_33
Function Fragment_33()
;BEGIN CODE
;Last 6 hours to Night time of transformation
;debug.notification("stage 40")
svr_dayspast.setValue(3)
playerRef.addspell(svr_damageHealthSpell, false)
playerRef.removeSpell(svr_playerDebuffSpell)
playerRef.addspell(svr_playerDebuffSpell, false)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_34
Function Fragment_34()
;BEGIN CODE
;player died while incubating

If svr_ReviveType.GetValue() == 2 ;Player chose Death
    setStage(200)
else
playerRef.removespell(svr_damageHealthSpell)
SleepyTimeFadeIn.applyCrossfade(10)
utility.wait(5)
playerRef.pushActorAway(PlayerRef,1)
svr_daysPast.setValue(3.5);Paralyze the player. Simulate Death. Used by DebuffSpell
;playerRef.DoCombatSpellApply(svr_DeathPacifySpell, playerRef);Calms all Aggression

utility.wait(10)
;PlayerRef.ForceRemoveRagdollFromWorld();Precaution for MoveTo
alias_DeathLoc.TryTomoveto(playerRef) ;Used to allow manual reteleportation.
svr_TP.setValue(1)
setStage(110)     ;Revive options
endIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_30
Function Fragment_30()
;BEGIN CODE
;Contracted Vampirism. This is day 0-1

if svr_DeathAltCompat.getValue() == 0 ;Alternate death Compatibility check
     Alias_essentialPlayer.ForceRefTo(Game.GetPlayer())
endIf

playerRef.addspell(svr_playerDebuffSpell, false)

;/
if Alias_essentialPlayer.getActorRef() == Game.GetPlayer()
     debug.notification("Player is now essential")
endIf
/;
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_38
Function Fragment_38()
;BEGIN CODE
;Force allow Teleportation
svr_TP.setValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_32
Function Fragment_32()
;BEGIN CODE
;Final Day of Vampirism. Day 3-Last 6 hours
;debug.notification("stage 30 fragment")

svr_dayspast.setvalue(2)
playerRef.removeSpell(svr_playerDebuffSpell)
playerRef.addspell(svr_playerDebuffSpell, false)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_36
Function Fragment_36()
;BEGIN CODE
;Player fully transforms into Vampire
;debug.notification("Aborting process...")
alias_EssentialPlayer.clear()
playerRef.removespell(svr_damageHealthSpell)
playerRef.removeSpell(svr_playerDebuffSpell)
svr_shrineSpawn.setValue(-1)
svr_MCMScript.RestartMQ()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_35
Function Fragment_35()
;BEGIN CODE
if svr_ReviveType.getValue() == -1
     svr_shrineSpawn.setValue(SVR_InitRespawnMSB.show())
endIf

If svr_ReviveType.GetValue() == 2 || svr_shrineSpawn.getValue() == 2 ;Player chose Death
     setStage(200)

elseif svr_ReviveType.getValue() == 0 || svr_shrineSpawn.getValue() == 0 ;0 = Respawn at Shrine
     SVR_RespawnQuest.Start()    ;Handles Player teleportation
     Location loc =Game.GetPlayer().GetCurrentLocation()
     if (!loc)
     ; Debug.notification("No loc")
          PlayerLocationValue.SetValue(0)
     elseif (!PlayerLocationValue)
          ;Debug.notification("No player val")
     Else
          PlayerLocationValue.SetValue(1)
     endIf

     if (SVR_RespawnQuest.Start() == false)
          Debug.notification("Failed " + PlayerLocationValue.GetValue() + ". Cannot move player. Not a bug.")
     else
          Location loc1 = (SVR_RespawnQuest.GetAliasByName("PlayerAssumedLocation") as LocationAlias).GetLocation();
          ;Debug.MessageBox("Success, " + loc1.GetName())
     endIf
;elseIf svr_ReviveType.GetValue() == 1 || svr_shrineSpawn.getValue() == 1 ;Revive on Spot  

endIf

If svr_ReviveType.GetValue() != 2 || svr_shrineSpawn.getValue() != 2 
     playerRef.restoreav("health",100000);
     playerRef.DoCombatSpellApply(svr_DeathPacifySpell, playerRef);Calms all Aggression
     utility.wait(5)
     PlayerVampireQuest.VampireChange(playerRef)
     setStage(200)
endIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_31
Function Fragment_31()
;BEGIN CODE
;Second Day of Vampirism. Day 1-2
;debug.notification("stage 20 fragment")

svr_DaysPast.setValue(1.0)
;playerRef.addspell(svr_playerDebuffSpell, false)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment


GlobalVariable Property svr_shrineSpawn Auto
GlobalVariable Property svr_DaysPast  Auto  

GlobalVariable Property svr_damageHealthGV  Auto  

Actor Property PlayerRef  Auto  

PlayerVampireQuestScript Property PlayerVampireQuest Auto

SPELL Property svr_DeathPacifySpell  Auto  

ImageSpaceModifier Property SleepyTimeFadeIn  Auto  

ImageSpaceModifier Property FadeToBlackHoldImod  Auto  

Quest Property SVR_RespawnQuest  Auto  

GlobalVariable Property PlayerLocationValue  Auto  

Message Property SVR_InitRespawnMSB  Auto
Message Property svr_MovetoConfirm Auto  

STATIC Property XMarkerHeading  Auto  

SPELL Property SVR_DamageHealthSpell  Auto  

SPELL Property SVR_PlayerDebuffSpell  Auto  

GlobalVariable Property svr_ReviveType  Auto  
{Whether to prompt for respawn and type of respawn}

GlobalVariable Property svr_TP  Auto  

GlobalVariable Property svr_DeathAltCompat  Auto  

SVR_MCM Property SVR_MCMScript  Auto  
