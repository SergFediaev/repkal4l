#if defined _respawn_health_included
 #endinput
#endif
#define _respawn_health_included

public SharedPlugin __pl_respawn_health = 
{
    name = "respawn_health",
    file = "respawn_health.smx",
#if defined REQUIRE_PLUGIN
    required = 1,
#else
    required = 0,
#endif
};

#if !defined REQUIRE_PLUGIN
public void __pl_respawn_health_SetNTVOptional()
{

}
#endif

/**
 * @brief Called when rescue health settings has been done
 *
 * @param client		client index
 *
 * @noreturn
 */
forward void RespawnHealth_OnSetRescueHealth(int client);

/**
 * @brief Called when defibrillator health settings has been done
 *
 * @param client		client index
 *
 * @noreturn
 */
forward void RespawnHealth_OnSetDefibrillatorHealth(int client);
