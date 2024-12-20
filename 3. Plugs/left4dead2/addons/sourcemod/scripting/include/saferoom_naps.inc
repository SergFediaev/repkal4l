#if defined _saferoom_naps_included
 #endinput
#endif
#define _saferoom_naps_included

public SharedPlugin __pl_saferoom_naps = 
{
    name = "saferoom_naps",
    file = "saferoom_naps.smx",
#if defined REQUIRE_PLUGIN
    required = 1,
#else
    required = 0,
#endif
};

#if !defined REQUIRE_PLUGIN
public void __pl_saferoom_naps_SetNTVOptional()
{

}
#endif

/**
 * @brief Called when a survivor is healed
 *
 * @param client		client index
 *
 * @noreturn
 */
forward void SafeRoomNaps_OnHealed(int client);
