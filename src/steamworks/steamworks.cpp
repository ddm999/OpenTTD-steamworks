
/**
 * @file steamworks.cpp
 * Implementation of Steamworks API handler.
 * StartUp returns false if it failed, but this can be ignored.
 * Any calls that are unsuccessful will return the following based on type:
 * bool: false
 * int: -1
 * uint: 0
 * pointer: NULL
 *
 * @inject src/openttd.cpp@80
 * #ifdef WITH_STEAMWORKS
 * #	include "steamworks/steamworks.h"
 * #endif
 *
 * The JavaDoc command "@inject" signifies a function call or specific code must be run at the provided location for implementation.
 * Wrap all of these in `#ifdef WITH_STEAMWORKS` / `#endif`.
 */

#include "stdafx.h"
#include "network/core/config.h"
#include "string_func.h"

#include "steam_api.h"

bool _steamworks_ok = false; ///< Is our Steam API working? Always early return if it's not.

/** Initialize Steamworks API and setup globals (if any)
 *
 * @note	There is no warning or alert if the connection fails. API calls will instead just do nothing.
 * @inject src/openttd.cpp@775
 */
bool SteamworksStartUp()
{
	if (SteamAPI_Init()) {
		_steamworks_ok = true;
	}

	return _steamworks_ok;
}

/** Tell Steamworks API we're closing and it can free itself
 * 
 * @inject src/openttd.cpp@307
 */
void SteamworksShutDown()
{
	if (!_steamworks_ok) return;

	SteamAPI_Shutdown();
}

/**
 * Return the local Steam players name: after being validated.
 * This is the name displayed on their Steam Community profile.
 *
 * @return Pointer to validated Steam display name (or NULL if there is no connection to Steam)
 *
 * @warning Unlike the Steam API call, this can return NULL (for no connection). Make sure this is handled.
 * @inject src/openttd.cpp@466
 *		if (StrEmpty(_settings_client.network.client_name)) {
 *			const char* SteamUsername = SteamworksGetDisplayName();
 *			if (SteamUsername != NULL) {
 *				strecpy(_settings_client.network.client_name, SteamUsername, lastof(_settings_client.network.client_name));
 *			}
 *		}
 */
const char *SteamworksGetDisplayName()
{
	if (!_steamworks_ok) return NULL;

	const char* name = SteamFriends()->GetPersonaName();
	/* Limit the name length to a valid client name */
	char* valid_name = stredup(name, &name[ttd_strnlen(name, NETWORK_CLIENT_NAME_LENGTH - 1)]);
	/* And validate it to remove quirky UTF-8 that people like to put in nicks */
	ValidateString(valid_name);
	return valid_name;
}

/**
 * Activates Steam Overlay web browser directly to the specified URL.
 * Full address with protocol type is required, e.g. http://www.steamgames.com/
 *
 * @param url Address to open
 * @return True if the overlay could be opened, false otherwise.
 * @inject src/openttd.cpp@399
 *	if (SteamworksOpenBrowser(url)) return;
 */
bool SteamworksOpenBrowser(const char* url)
{
	if (!_steamworks_ok) return false;
	if (!(SteamUtils()->IsOverlayEnabled())) return false;

	SteamFriends()->ActivateGameOverlayToWebPage(url);
	return true;
}
