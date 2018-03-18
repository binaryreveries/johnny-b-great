#include <amxmodx>
#include <fun>

#define PLUGIN "Johnny B. Great!"
#define VERSION "0.1"
#define AUTHOR "tree"

new const MODEL[] = "model"

new attached = false
new match_running = false
new fadedparadigm_id
new remaining_agents = 100

public plugin_init()
{
  // register plugin with AMX Mod X
  register_plugin(PLUGIN, VERSION, AUTHOR)

  // register say commands which are used via chat
  register_clcmd("say /jbg", "start_match", -1,
    "Shows Johnny B. Great info.")
}

public event_DeathMsg(id)
{
  if (match_running) {
    // if all agents are killed, or faded is defeated, restart
    if (fadedparadigm_id == id || remaining_agents == 0)
    {
      show_hudmessage(0, "GAME OVER")
      set_task(7.0, "start_match")
    }
    else
    {
      remaining_agents--
      client_print(0, print_chat, "Only %i agents remain!")
    }
  }
}

public event_PTakeDam(id)
{
  if (match_running) {
    new health = get_user_health(fadedparadigm_id)
    show_fadedparadigm_health(health)
  }
}

public event_WeaponInfo(id)
{
    if (match_running && fadedparadigm_id == id)
    {
      // drop_weapons(id)
    }
}

public start_match(id)
{
  match_running = false
  remaining_agents = 100

  // get FadedParadigms id and store it in global
  find_player_i("FadedParadigm")

  if (!attached)
  {
    register_event("DeathMsg", "event_DeathMsg", "a")
    register_event("PTakeDam", "event_PTakeDam", "a")
    register_event("WeaponInfo", "event_WeaponInfo", "b")
    attached = true
  }

  client_print(id, print_chat, "Setting up match!")
  setup_match()

  client_print(id, print_chat, "Setting up players!")

  setup_players()

  client_print(id, print_chat, "Johnny B. Great is now active!")
  match_running = true
}

stock drop_weapons(id)
{
  if (!is_user_bot(id))
  {
    console_cmd(id, "drop")
  }
  else
  {
    set_task(0.1, "delay_drop", id)
  }
}

stock delay_drop(id)
{
  engclient_cmd(id, "drop")
}

stock find_player_i(const searched_name[])
{
  new players[32], num
  get_players(players, num)
  new i
  new id
  new name[32]
  for (i = 0; i < num; i++)
  {
    id = players[i]
    get_user_name(id, name, 31)
    if (equali(name, searched_name))
    {
      fadedparadigm_id = id
      break
    }
  }
}

stock setup_match()
{
  client_print(0, print_chat, "Setting up match")
}

stock setup_players()
{
  new players[32], num
  get_players(players, num)
  new i
  new id
  new health = 1000
  for (i = 0; i < num; i++)
  {
    id = players[i]
    if (fadedparadigm_id == id)
    {
      set_user_info(id, MODEL, "gordon")

      set_user_health(id, health)
      client_print(id, print_chat, "Set FadedParadigm's Health to %i!", health)

      show_fadedparadigm_health(health)
      drop_weapons(id);
    }
    else
    {
      set_user_info(id, MODEL, "agent")
    }
  }
}

stock show_fadedparadigm_health(health)
{
  new message[31]
  format(message, 30, "FadedParadigm's Health: %i", health)
  show_hudmessage(0, message)
}
