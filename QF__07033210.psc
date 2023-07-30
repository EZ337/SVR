;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname QF__07033210 Extends Quest Hidden

;BEGIN ALIAS PROPERTY NearestShrineLocation
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_NearestShrineLocation Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY AssumedMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_AssumedMarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY ShrineAlias
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_ShrineAlias Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY HoldLocation
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_HoldLocation Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY PlayerAssumedLocation
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_PlayerAssumedLocation Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY playerLocation
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_playerLocation Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY ProxyLoadedMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_ProxyLoadedMarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY RandomShrineLocation
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_RandomShrineLocation Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY ShrineLocation
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_ShrineLocation Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
debug.messagebox("Restarting Main Quest...")
utility.wait(5)
svr_PlayerVampireQuest.start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
;This was all made possible by Noah

ObjectReference shrine = Alias_ShrineAlias.GetReference();
Actor Player = Alias_Player.GetActorReference();
objectreference assuming = Alias_AssumedMarker.GetReference()

Location player_loc = (GetAliasByName("PlayerLocation") as LocationAlias).GetLocation();
Location loc1 = (GetAliasByName("PlayerAssumedLocation") as LocationAlias).GetLocation();
Location loc2 = (GetAliasByName("NearestShrineLocation") as LocationAlias).GetLocation();
Location loc3 = assuming.GetCurrentLocation();
Location loc4 = (GetAliasByName("HoldLocation") as LocationAlias).GetLocation();
;/
Debug.MessageBox("Assumed = " + loc1.GetName() + ", Near Shrine = " + loc2.GetName() + ", Assume Loc = " + loc3.GetName() + ", Assuming = " +assuming.GetDisplayName() + \
", hold = " + loc4.GetName() + ", [Player Loc loaded] "+ player_loc.IsLoaded() + "/" + (player_loc) + ",[assuming is player] = " + (Player == assuming as Actor))
/;

if (shrine)
    player.restoreav("Health", 100000)
    player.MoveTo(shrine, 120.0 * Math.cos(shrine.GetAngleZ()), -60.0 * Math.sin(shrine.GetAngleZ())); abMatchRotation = false)
else
    Debug.notification("Issue with shrine positioning or something.")
endIf
Stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property SVR_PlayerVampireQuest  Auto  
