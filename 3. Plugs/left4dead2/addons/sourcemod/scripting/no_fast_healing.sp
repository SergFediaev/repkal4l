#define PLUGIN_VERSION	"1.0"
#define PLUGIN_NAME     "No Fast Healing"
#define PLUGIN_PREFIX	"no_fast_healing"

#pragma tabsize 0
#pragma semicolon 1
#pragma newdecls required
#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = PLUGIN_NAME,
	author = "little_froy",
	description = "game play",
	version = PLUGIN_VERSION,
	url = "https://forums.alliedmods.net/showthread.php?t=349778"
};

void change_weapon(int client)
{
    if(GetEntProp(client, Prop_Send, "m_iCurrentUseAction") != 1)
    {
        return;
    }
    int active = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
    if(active == -1)
    {
        return;
    }
    for(int i = 0; i < 5; i++)
    {
        int slot = GetPlayerWeaponSlot(client, i);
        if(slot != -1 && slot != active)
        {
            char class_name[64];
            GetEntityClassname(slot, class_name, sizeof(class_name));
            FakeClientCommand(client, "use %s", class_name);
            break;
        }
    }
}

void event_map_transition(Event event, const char[] name, bool dontBroadcast)
{
	for(int client = 1; client <= MaxClients; client++)
	{
        if(IsClientInGame(client) && GetClientTeam(client) == 2 && IsPlayerAlive(client))
        {
            change_weapon(client);
        }
	}
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
    if(GetEngineVersion() != Engine_Left4Dead2)
    {
        strcopy(error, err_max, "this plugin only runs in \"Left 4 Dead 2\"");
        return APLRes_SilentFailure;
    }
    return APLRes_Success;
}

public void OnPluginStart()
{
    HookEvent("map_transition", event_map_transition);

    CreateConVar(PLUGIN_PREFIX ... "_version", PLUGIN_VERSION, "version of " ... PLUGIN_NAME, FCVAR_NOTIFY | FCVAR_DONTRECORD);
}