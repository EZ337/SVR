Scriptname SVR_IncubationMonitor extends ReferenceAlias  
{Monitors player incubation period once affected with Sanguinare Vampiris.
Starts the entire mod really.}
import PO3_Events_Alias

Event OnPlayerLoadGame()
    ;debug.MessageBox("OnGameLoad")
    int i = 0
    While (i < svr_applicacbleDiseaseList.GetSize())
        MagicEffect currEffect = svr_applicacbleDiseaseList.GetAt(i) as MagicEffect;
        currEffect.SetEffectFlag(0x00008000) ;Hides effect from UI
        i += 1
    EndWhile
    SVR_MCMScript.UpdateValsAll()
    SVR_MCMScript.ConsitencyCheck()
endEvent


Event OnInit()
    svr_DaysPast.SetValue(0.0);Monitor days since incubation. For changes at the different stages
    currDisease = None

    ;Loop through FormList and register for every disease
    int i = 0
    While (i < svr_applicacbleDiseaseList.GetSize())
        MagicEffect currEffect = svr_applicacbleDiseaseList.GetAt(i) as MagicEffect;
        currEffect.SetEffectFlag(0x00008000)   ; Hide effect from UI flag
        RegisterForMagicEffectApplyEx(self, currEffect, True)
        
        if PlayerRef.hasMagicEffect(currEffect)
            debug.notification("SVR: Player already has Disease. Assuming day 2+ effects.")
            svr_PlayerVampireQuest.setStage(10)
            RegisterForSingleUpdateGameTime(24)
            svr_PlayerVampireQuest.SetStage(20)
            VampireChangeTimer = GameDaysPassed.GetValue() + 2
        endIf

        i += 1
    EndWhile

endEvent

;***********************************************************
;		Set up. We just Contracted Vamprisim
;***********************************************************
Event OnMagicEffectApplyEx(ObjectReference akCaster, MagicEffect akEffect, Form akSource, bool abApplied)
	if (abApplied && currDisease == None) 
        currDisease = akEffect
        
		RegisterForSingleUpdateGameTime(24);Interval we measure incubation period
		svr_PlayerVampireQuest.setStage(10);Initial Day of contraction
		;utility.wait(3);Allows Vanilla script to update itself before I register values from there to match mine.
        VampireChangeTimer = GameDaysPassed.getValue() + 3
		svr_DaysPast.setValue(0.0);Double check for safety

        if (SVR_MCMScript.getModSettingBool("bDebugMode:Debug"))
            debug.notification("We have contracted Vampirism")
            debug.Notification("Now monitering: " + currDisease.GetName())
            debug.notification("Transform date on Day : " + VampireChangeTimer)
        endIf
	endIf
EndEvent


;***********************************************************
;		Days since infection Monitor
;***********************************************************
Event OnUpdateGameTime()
    int i = 0
    While (i < svr_applicacbleDiseaseList.GetSize())
        ; If player has any of the diseases in the FormList, process it
        If (PlayerRef.HasMagicEffect(currDisease))
            float register_time = 24;
            ;float night_time = 0.29;166666667 ;7pm
            ;float aim_time = 0.46;833333334 ;6 hours before 7PM which is default night time
            float curr_time = Utility.getCurrentGameTime()
            ;float change_time = math.ceiling(VampireChangeTimer)
            ;Enable for strict 3 day vampirism        ;if curr_time > VampireChangeTimer
                ;svr_PlayerVampireQuest.setStage(200) ;For Vampire Overhauls that don't send VampireChangeEvent
            if curr_time >= (VampireChangeTimer - 0.25) ; Day 2.75->3+
                register_time = 6
                ;if (3 - curr_time) < night_time; Last 6 hours
                if (SVR_MCMScript.getModSettingBool("bDebugMode:Debug")) ;Debug
                    debug.messagebox("Last six hours of Vampirsim")
                    debug.MessageBox("Current Time = " + Utility.getCurrentGameTime())
                endIf
                svr_PlayerVampireQuest.SetStage(40)
                ;endIf
                
            elseif curr_time >= (VampireChangeTimer - 1) ; Day 1->2
                if (SVR_MCMScript.getModSettingBool("bDebugMode:Debug")) ;Debug
                    debug.messagebox("Day 2 Contraction completed. Finishing Day 3")
                    debug.MessageBox("Current Time = " + Utility.getCurrentGameTime())
                endIf
                ;float last_wait =((change_time - aim_time) - curr_time) * 24
                svr_PlayerVampireQuest.SetStage(30)
    
                register_time = 18
            elseif curr_time >= (VampireChangeTimer - 2) ;Day 0->1

                if (SVR_MCMScript.getModSettingBool("bDebugMode:Debug")) ;Debug
                    debug.messagebox("Day 1 of Contraction Completed. Progressing day 2")
                endIf
                svr_PlayerVampireQuest.setStage(20)
            endIf
    
            if (register_time)
                RegisterForSingleUpdateGameTime(register_time)
            endIf
        Else
            svr_PlayerVampireQuest.SetStage(200) ;Resets quest if we lost the disease for whatever reason.
            currDisease = None;
            If (SVR_MCMScript.GetModSettingBool("bDebugMode:Debug")) ;Debug
                Debug.Notification("The disease was lost")
            EndIf
        EndIf	
        i += 1
    EndWhile
endEvent

;***********************************************************
;		Death while incubation
;***********************************************************
Event OnEnterBleedout()
    int i = 0
    While (i < svr_applicacbleDiseaseList.GetSize())
        if (playerRef.HasMagicEffect(svr_applicacbleDiseaseList.GetAt(i) as MagicEffect))
            if (SVR_MCMScript.getModSettingBool("bDebugMode:Debug")) ;Debug Message
                Debug.notification("We entered bleedout...")
                debug.MessageBox("Found current disease... ")
            endIf

            if (!svr_DeathAltCompat.getValue()) ; If AltDeathCompat is not enabled
                UnRegisterForUpdateGameTime()
                svr_PlayerVampireQuest.SetStage(100)

            else
                RegisterForSingleUpdate(15)
            endIf
        endIf
        
        i += 1
    EndWhile

endEvent


;***********************************************************
;		Alt Death Compatibility
;***********************************************************
Event OnUpdate()
    if PlayerIsVampire.getValue() == 0 && Game.GetPlayer().GetCombatState() == 0 && Game.IsMovementControlsEnabled() && Game.IsFightingControlsEnabled()
        int choice = svr_DeathAltConfirm.show()
        if choice == 0 ;Change meeeee
            PlayerVampireQuest.VampireChange(PlayerRef)
        elseIf choice == 1 ;Ask me again in a bit
            RegisterForSingleUpdate(10)
        Else
            svr_PlayerVampireQuest.setStage(200) ;No Vampire for you
        endIf
    Else
        RegisterForSingleUpdate(10)
    endIf
endEvent


;***********************************************************
;       Succesful Transformation
;***********************************************************
;/ Some mods don't use SE VampirismStateChangeEvent unfortunately.
Event OnVampirismStateChanged(bool abIsVampire)
    if (abIsVampire);Player is now vampire. Stop and reset mod effects
      svr_DaysPast.SetValue(0.0);Reset days since Vampire
      debug.MessageBox("Done with mod script")
      UnregisterForUpdate();Not necessary.
      UnregisterForUpdateGameTime();Precaution. Not necessary.
      svr_PlayerVampireQuest.SetStage(200);Should reset quest here
      debug.MessageBox("we should be a vampire now")
      ;svr_PlayerVampireQuest.Reset();Fail safe
    endIf
endEvent
/;

Event OnRaceSwitchComplete()
    utility.wait(3)
    ;debug.Notification("RaceSwitch")
    if PlayerIsVampire.getValue() == 1 ;Workaround.
        svr_DaysPast.SetValue(0.0);Reset days since Vampire
        
        UnregisterForUpdate();Not necessary.
        UnregisterForUpdateGameTime();Precaution. Not necessary.
        svr_PlayerVampireQuest.SetStage(200);Should reset quest here
        currDisease = None

        if (SVR_MCMScript.getModSettingBool("bDebugMode:Debug"))
            debug.MessageBox("Done with mod script")
            debug.MessageBox("we should be a vampire now")  
        endIf          
    endIf

    
endEvent

SVR_MCM property SVR_MCMScript Auto
Spell Property DiseaseSanguinareVampiris Auto
MagicEffect Property currDisease  Auto  
{disease that procced the OnMGEFApply Event}
VampireDiseaseEffectScript Property DiseaseEffectScript Auto
PlayerVampireQuestScript Property PlayerVampireQuest Auto
GlobalVariable Property svr_DaysPast  Auto  
{Days since incubation period}
GlobalVariable Property GameDaysPassed Auto
GlobalVariable Property svr_DeathAltCompat Auto
GlobalVariable Property PlayerIsVampire Auto
GlobalVariable property PlayerLocationValue auto
float property VampireChangeTimer Auto
actor Property PlayerRef Auto
Quest Property SVR_RespawnQuest Auto
Quest Property svr_PlayerVampireQuest  Auto  
message Property svr_DeathAltConfirm Auto
FormList Property svr_applicacbleDiseaseList  Auto  
{List of MGEFs to treat as if Vampirism}
