#define PLUGIN_VERSION  "1.1"
#define PLUGIN_NAME     "c7m3 Sacrifice Finale Remove"
#define PLUGIN_PREFIX	"c7m3_sacrifice_finale_remove"

#pragma tabsize 0
#pragma semicolon 1
#pragma newdecls required
#include <sourcemod>

public Plugin myinfo =
{
	name = PLUGIN_NAME,
	author = "little_froy",
	description = "game play",
	version = PLUGIN_VERSION,
	url = "https://forums.alliedmods.net/showthread.php?t=348950"
};

public void OnMapInit(const char[] mapName)
{
    if(strcmp(mapName, "c7m3_port") != 0)
    {
        return;
    }
    for(int i = 0; i < EntityLump.Length(); i++)
    {
        EntityLumpEntry entry = EntityLump.Get(i);
        int key_id = entry.FindKey("hammerid");
        if(key_id != -1)
        {
            char id[64];
            entry.Get(key_id, .valbuf = id, .vallen = sizeof(id));
            if(strcmp(id, "1639399") == 0)
            {
                int finale_key = entry.FindKey("IsSacrificeFinale");
                if(finale_key != -1)
                {
                    entry.Update(finale_key, .value = "0");
                    delete entry;
                    return;
                }
            }
        }
        delete entry;
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
    CreateConVar(PLUGIN_PREFIX ... "_version", PLUGIN_VERSION, "version of " ... PLUGIN_NAME, FCVAR_NOTIFY | FCVAR_DONTRECORD);
}