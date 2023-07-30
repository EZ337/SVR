Scriptname SVR_IncubationMonitor extends ReferenceAlias  
{Monitors player incubation period once affected with Sanguinare Vampiris.
Starts the entire mod really.}
import PO3_Events_Alias

Event OnPlayerLoadGame()
    ;debug.MessageBox("OnGameLoad")
    DisDamageHealthVampire.SetEffectFlag(0x00008000) ;Hides effect from UI
    SVR_MCMScript.UpdateValsAll()
    SVR_MCMScript.ConsitencyCheck()
endEvent


Event OnInit()
    if PlayerRef.hasMagicEffect(DisDamageHealthVampire)
        debug.notification("SVR: Player already has Disease. Assuming day 2+ effects.")
        ;GotoState "Resting"
        svr_PlayerVampireQuest.setStage(10)
        RegisterForSingleUpdateGameTime(24)
        svr_PlayerVampireQuest.SetStage(20)
        VampireChangeTimer = GameDaysPassed.GetValue() + 2
    endIf
	RegisterForMagicEffectApplyEx(self, DisDamageHealthVampire, True)
    svr_DaysPast.SetValue(0.0);Monitor days since incubation. For changes at the different stages
    DisDamageHealthVampire.SetEffectFlag(0x00008000) ;Hides effect from UI

endEvent

;***********************************************************
;		Set up. We just Contracted Vamprisim
;***********************************************************
Event OnMagicEffectApplyEx(ObjectReference akCaster, MagicEffect akEffect, Form akSource, bool abApplied)
	if abApplied
		;debug.notification("We have contracted Vamprisim")
		RegisterForSingleUpdateGameTime(24);Interval we measure incubation period
		svr_PlayerVampireQuest.setStage(10);Initial Day of contraction
		;utility.wait(3);Allows Vanilla script to update itself before I register values from there to match mine.
        VampireChangeTimer = GameDaysPassed.getValue() + 3
        ;debug.notification("Transform date on Day : " + VampireChangeTimer)
		svr_DaysPast.setValue(0.0);Double check for safety
	endIf
EndEvent


;***********************************************************
;		Days since infection Monitor
;***********************************************************
Event OnUpdateGameTime()
    if playerRef.hasMagicEffect(DisDamageHealthVampire)
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
                ;debug.messagebox("Last six hours of Vampirsim")
                ;debug.MessageBox("Current Time = " + Utility.getCurrentGameTime())
                svr_PlayerVampireQuest.SetStage(40)
            ;endIf
            
        elseif curr_time >= (VampireChangeTimer - 1) ; Day 1->2
            ;debug.messagebox("Day 2 Contraction completed. Finishing Day 3")
            ;float last_wait =((change_time - aim_time) - curr_time) * 24
            svr_PlayerVampireQuest.SetStage(30)
            ;debug.MessageBox("Current Time = " + Utility.getCurrentGameTime())

            register_time = 18
        elseif curr_time >= (VampireChangeTimer - 2) ;Day 0->1
            ;debug.messagebox("Day 1 of Contraction Completed. Progressing day 2")
	    	svr_PlayerVampireQuest.setStage(20)
        endIf

        if (register_time)
            RegisterForSingleUpdateGameTime(register_time)
        endIf
    Else
        svr_PlayerVampireQuest.SetStage(200) ;Resets quest if we lost the disease for whatever reason.
    endIf
endEvent

;***********************************************************
;		Death while incubation
;***********************************************************
Event OnEnterBleedout()
    if svr_DeathAltCompat.getValue() == 0 && playerRef.HasMagicEffect(DisDamageHealthVampire)
        ;Debug.notification("We entered bleedout...")
        UnRegisterForUpdateGameTime()
        svr_PlayerVampireQuest.SetStage(100)
    Elseif svr_DeathAltCompat.getValue() == 1 && PlayerRef.HasMagicEffect(DisDamageHealthVampire)
        RegisterForSingleUpdate(15)
    endIf
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
        ;debug.MessageBox("Done with mod script")
        ;debug.MessageBox("we should be a vampire now")
        UnregisterForUpdate();Not necessary.
        UnregisterForUpdateGameTime();Precaution. Not necessary.
        svr_PlayerVampireQuest.SetStage(200);Should reset quest here
    endIf
endEvent

SVR_MCM property SVR_MCMScript Auto
Spell Property DiseaseSanguinareVampiris Auto
MagicEffect Property DisDamageHealthVampire  Auto  
{Sanguinare Vampiris}
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
