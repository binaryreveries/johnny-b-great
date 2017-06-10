#include <amxmodx>

#define PLUGIN "Johnny B. Great!"
#define VERSION "0.1"
#define AUTHOR "tree"

public plugin_init()
{
  // register plugin with AMX Mod X
  register_plugin(PLUGIN, VERSION, AUTHOR)

  // register "say" commands which are used via chat
  register_clcmd("say /johnnybgreat", "show_info", -1,
    "Shows Johnny B. Great info.")

}

public show_info(id)
{
  client_print(id, print_chat, "Johnny B. Great is now active!")
}
