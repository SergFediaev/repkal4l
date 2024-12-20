/*=============================================================================================================================================
* version = "1.5a".
*/
 
#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <left4dhooks>
#define PLUGIN_VERSION "1.5a"

ConVar g_hCvarDist;
float g_fDist;

public Plugin myinfo =
{
	name = "Tank rock staggering",
	author = "3ipka",
	description = "Tank rock staggers player",
	version = PLUGIN_VERSION,
	url = ""
};

public void OnPluginStart()
{
	g_hCvarDist = CreateConVar(	"l4d_rock_stagger_dist", "300.0", "Distance that rocks stagger players");
	g_hCvarDist.AddChangeHook(ConVarChanged);
}

public void OnConfigsExecuted()
{
	g_fDist = g_hCvarDist.FloatValue;
}

public void ConVarChanged(Handle convar, const char[] oldValue, const char[] newValue)
{
	g_fDist = g_hCvarDist.FloatValue;
}

//forward void L4D_TankRock_OnDetonate(int tank, int rock);
//native void L4D_StaggerPlayer(int target, int source_ent, float vecSource[3]);

public void L4D_TankRock_OnDetonate(int tank, int rock)
{
	float vPosClient[3], vPosRock[3], traceVec[3], resulting[3];

	for (new target = 1; target <= MaxClients; target++)
	{
		if (IsClientInGame(target))
		{
			if(L4D2_GetPlayerZombieClass(target) !=8 && IsPlayerAlive(target) && !IsPlayerBusy(target) && !IsPlayerAnim(target))
			{
				GetClientAbsOrigin(target, vPosClient);
				GetEntPropVector(rock, Prop_Send, "m_vecOrigin", vPosRock);
				if(GetVectorDistance(vPosClient, vPosRock) <= g_fDist)
				{
					if(GetEntPropEnt(target, Prop_Send, "m_hGroundEntity") == -1 && GetClientTeam(target) != 3)
					{
						GetEntPropVector(target, Prop_Data, "m_vecOrigin", vPosClient);
						float power = 50.0;
						MakeVectorFromPoints(vPosClient, vPosRock, traceVec);
						GetVectorAngles(traceVec, resulting);
						resulting[0] = Cosine(DegToRad(resulting[1])) * power;
						resulting[1] = Sine(DegToRad(resulting[1])) * power;
						resulting[2] = power + (power * 0.5);
						L4D2_CTerrorPlayer_Fling(target, tank, resulting);
					}
					else{
					L4D_StaggerPlayer(target, rock, vPosRock);}
				}
			}
		}
	}
}

stock IsPlayerAnim(client)
{
	static sequence = 0;
	static char temp[40];
	//GetClientModel(client, temp, sizeof(temp));
	GetEntPropString(client, Prop_Data, "m_ModelName", temp, sizeof(temp));
	//if(temp[17] == 's' && temp[26] == 'e') // survivor_coach.mdl
	if(strcmp(temp, "models/survivors/survivor_coach.mdl") == 0)
	{
		sequence = GetEntProp(client, Prop_Send, "m_nSequence");
		if (sequence == 628 || sequence == 629 || sequence == 630)
		return true;
	}
	//else if(temp[17] == 's' && temp[26] == 'g') // survivor_gambler.mdl
	else if(strcmp(temp, "models/survivors/survivor_gambler.mdl") == 0)
	{
		sequence = GetEntProp(client, Prop_Send, "m_nSequence");
		if (sequence == 628 || sequence == 629 || sequence == 630)
		return true;
	}
	//else if(temp[17] == 's' && temp[26] == 'p') // survivor_producer.mdl
	else if(strcmp(temp, "models/survivors/survivor_producer.mdl") == 0)
	{
		sequence = GetEntProp(client, Prop_Send, "m_nSequence");
		if (sequence == 636 || sequence == 637 || sequence == 638)
		return true;
	}
	//else if(temp[17] == 's' && temp[26] == 'm' &&  temp[27]  == 'e') // survivor_mechanic.mdl
	else if(strcmp(temp, "models/survivors/survivor_mechanic.mdl") == 0)
	{
		sequence = GetEntProp(client, Prop_Send, "m_nSequence");
		if (sequence == 633 || sequence == 634 || sequence == 635)
		return true;
	}
	//else if(temp[17] == 's' && temp[26] == 'm' &&  temp[27]  == 'a') // survivor_manager.mdl
	else if(strcmp(temp, "models/survivors/survivor_manager.mdl") == 0)
	{
		sequence = GetEntProp(client, Prop_Send, "m_nSequence");
		if (sequence == 536 ||sequence == 537 || sequence == 538)
		return true;
	}
	//else if(temp[17] == 's' && temp[26] == 't') // survivor_teenangst.mdl
	else if(strcmp(temp, "models/survivors/survivor_teenangst.mdl") == 0)
	{
		sequence = GetEntProp(client, Prop_Send, "m_nSequence");
		if (sequence == 545 || sequence == 546 || sequence == 547)
		return true;
	}
	//else if(temp[17] == 's' && temp[26] == 'n') // survivor_namvet.mdl
	else if(strcmp(temp, "models/survivors/survivor_namvet.mdl") == 0)
	{
		sequence = GetEntProp(client, Prop_Send, "m_nSequence");
		if (sequence == 536 ||sequence == 537 || sequence == 538)
		return true;
	}
	//else if(temp[17] == 's' && temp[26] == 'b') // survivor_biker.mdl
	else if(strcmp(temp, "models/survivors/survivor_biker.mdl") == 0)
	{
		sequence = GetEntProp(client, Prop_Send, "m_nSequence");
		if (sequence == 539 || sequence == 540 || sequence == 541)
		return true;
	}
	return false;
}

stock bool:IsPlayerBusy(client)
{
		return GetEntProp(client, Prop_Send, "m_isIncapacitated") > 0 ||
			GetEntPropEnt(client, Prop_Send, "m_pummelAttacker") > 0 ||
			GetEntPropEnt(client, Prop_Send, "m_carryAttacker") > 0 ||
			GetEntPropEnt(client, Prop_Send, "m_pounceAttacker") > 0 ||
			GetEntPropEnt(client, Prop_Send, "m_tongueOwner") > 0 ||
			GetEntPropEnt(client, Prop_Send, "m_jockeyAttacker") > 0;
}