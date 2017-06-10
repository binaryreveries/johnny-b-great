#include <amxmodx>

#define PLUGIN "Johnny B. Great!"
#define VERSION "0.1"
#define AUTHOR "tree"

new curweapon[33]
new attached = false

public plugin_init()
{
  // register plugin with AMX Mod X
  register_plugin(PLUGIN, VERSION, AUTHOR)

  // register say commands which are used via chat
  register_clcmd("say /johnnybgreat", "show_info", -1,
    "Shows Johnny B. Great info.")
}

public event_WeaponInfo(id)
{
  curweapon[id] = read_data(1) 
  // No weapons for you, Faded :)
  if(get_user_team(id) == 2)
  {
      console_cmd(id, "drop")
  }
}

public show_info(id)
{
  if (!attached)
  {
    register_event("WeaponInfo", "event_WeaponInfo", "b")
    attached = true
  }

  client_print(id, print_chat, "Johnny B. Great is now active!")
}
