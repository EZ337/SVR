Scriptname svrSpawnVamp extends Quest  
{For testing. Spawn a vampire when you press semicolon.}

Event OnInit()
    RegisterForKey(39)
endEvent

event OnKeydown(int keycode)
	if (Utility.IsInMenuMode() == true)
        return
    Else
        playerRef.PlaceActorAtMe(EncVampire00BretonF)
	endIf
endEvent

SVR_MCM property SVR_MCMScript Auto
actor Property PlayerRef Auto
actorbase Property EncVampire00BretonF Auto