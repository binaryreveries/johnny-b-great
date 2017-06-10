#include <amxmodx>
#include <fun>

#define PLUGIN "Johnny B. Great!"
#define VERSION "0.1"
#define AUTHOR "tree"

new attached = false

public plugin_init()
{
  // register plugin with AMX Mod X
  register_plugin(PLUGIN, VERSION, AUTHOR)

  // register say commands which are used via chat
  register_clcmd("say /jbg", "start_match", -1,
    "Shows Johnny B. Great info.")
}

public event_WeaponInfo(id)
{
  // No weapons for you, Faded :)
  if(get_user_team(id) == 2)
  {
      console_cmd(id, "drop")
      client_print(id, print_chat, "FadedParadigm dropped all weapons")
  }
}

public start_match(id)
{
  if (!attached)
  {
    register_event("WeaponInfo", "event_WeaponInfo", "b")
    attached = true
  }

  increase_health(1000)

  client_print(id, print_chat, "Johnny B. Great is now active!")
}

public increase_health(amount)
{
  new const fadedParadigm_team = 2
  new players[32], num
  get_players(players, num)
  new i
  for (i = 0; i < num; i++)
  {
    if (get_user_team(players[i]) == fadedParadigm_team)
    {
      set_user_health(players[i], amount)
      client_print(0, print_chat, "Set FadedParadigm's Health to 1000!")
      break
    }
  }
}
