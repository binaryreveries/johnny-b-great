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
    new team_id = get_user_team(id)
    switch (team_id)
    {
      case 1:
      {
      }
      case 2:
      {
        drop_weapons(id)
      }
    }
}

stock drop_weapons(id)
{
  console_cmd(id, "drop")
  client_print(id, print_chat, "FadedParadigm dropped all weapons")
}

public start_match(id)
{
  if (!attached)
  {
    register_event("WeaponInfo", "event_WeaponInfo", "b")
    attached = true
  }

  setup_fadedparadigm()

  client_print(id, print_chat, "Johnny B. Great is now active!")
}

stock setup_fadedparadigm()
{
  new const fadedParadigm_team = 2
  new players[32], num
  get_players(players, num)
  new i
  new id
  for (i = 0; i < num; i++)
  {
    id = players[i]
    if (get_user_team(id) == fadedParadigm_team)
    {
      increase_health(id, 1000)
      drop_weapons(id);
    }
  }
}

stock increase_health(id, amount)
{
  set_user_health(id, amount)
  client_print(0, print_chat, "Set Health to %i!", amount)
}
