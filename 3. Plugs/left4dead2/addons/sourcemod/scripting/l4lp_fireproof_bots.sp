#include <sdkhooks>

bool IsSurvivorBot(int client)
{
	return IsFakeClient(client) && GetClientTeam(client) == 2;
}

void HookDamage(int client)
{
	SDKHook(client, SDKHook_OnTakeDamageAlive, OnTakeDamage);
}

public void OnPluginStart()
{
	for (int client = 1; client <= MaxClients; client++)
		if (IsClientInGame(client) && IsSurvivorBot(client))
		{
			// PrintToChatAll("OnPluginStart client: %d", client);
			HookDamage(client);
		}
}

public void OnClientPutInServer(int client)
{
	if (IsClientInGame(client) && IsFakeClient(client))
	{
		// PrintToChatAll("OnClientPutInServer client: %d", client);
		HookDamage(client);
	}
}

Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype)
{
	if ((damagetype == 8 || damagetype == 2056) && IsSurvivorBot(victim))
	{
		// 8 Fire started, 2056 Fire from middle to end, 131072 Incap damage
		// PrintToChatAll("OnTakeDamage type: %d, victim: %d", damagetype, victim);
		damage = 0.0;
		return Plugin_Changed;
	}

	return Plugin_Continue;
}