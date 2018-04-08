#include <amxmodx>
#include <hamsandwich>
#include <fun>

#define PLUGIN "Johnny B. Great!"
#define VERSION "0.5"
#define AUTHOR "tree"

new const MODEL[] = "model"

new attached = false
new match_running = false
new remaining_agents = 100

new HUD_msg_sync
new HP_msg_sync
new AGENTS_msg_sync

const TARGET_ALL = 0  // display HUD message to all players

public plugin_init()
{
  // register plugin with AMX Mod X
  register_plugin(PLUGIN, VERSION, AUTHOR)

  // register say commands which are used via chat
  register_clcmd("say /jbg", "start_match", -1,
    "Shows Johnny B. Great info.")

  RegisterHam(Ham_TakeDamage, "player", "hook_TakeDamage", 0, true)

  HUD_msg_sync = CreateHudSyncObj()
  HP_msg_sync = CreateHudSyncObj()
  AGENTS_msg_sync = CreateHudSyncObj()
}

public hook_TakeDamage(victim_id, inflictor_id, attacker_id, damage, damagebits)
{
  if (match_running)
  {
    if (attacker_id == find_player_i("FadedParadigm") &&
        get_user_health(attacker_id) <= 100)
    {
      SetHamParamFloat(4, damage * 2.0)
      speed = get_user_maxspeed(attack_id)
      set_user_maxspeed(attack_id, speed * 2.0)
    }
  }
}

public event_DeathMsg(id)
{
  // this id is a lie... we must get ids from client
  new attacker_id = read_data(1)
  new victim_id = read_data(2)
  new fp_id = find_player_i("FadedParadigm")
  if (match_running)
  {
    if (victim_id == fp_id)
    {
      match_running = false
      set_hudmessage(255, 0, 0, 0.5, 0.15, 0, 6.0, 12.0, 0.5, 0.25, -1)
      ShowSyncHudMsg(TARGET_ALL, HUD_msg_sync, "GAME OVER")
      set_hudmessage(255, 0, 0, 0.5, 0.5, 0, 6.0, 12.0, 0.5, 0.25, -1)
      ShowSyncHudMsg(TARGET_ALL, HUD_msg_sync, "Agents have Prevailed!")
    }
    else if (attacker_id == fp_id)
    {
      remaining_agents--
    }

    if (remaining_agents == 0)
    {
      match_running = false
      set_hudmessage(255, 0, 0, 0.5, 0.15, 0, 6.0, 12.0, 0.5, 0.25, -1)
      ShowSyncHudMsg(TARGET_ALL, HUD_msg_sync, "GAME OVER")
      set_hudmessage(255, 0, 0, 0.5, 0.5, 0, 6.0, 12.0, 0.5, 0.25, -1)
      ShowSyncHudMsg(TARGET_ALL, HUD_msg_sync, "FadedParadigm is Victorious!")
    }
    else
    {
      new message[25]
      format(message, 24, "Only %i agents remain!", remaining_agents)
      set_hudmessage(255, 0, 0, 1.0, 0.25, 0, 6.0, 12.0, 0.5, 0.25, -1)
      ShowSyncHudMsg(TARGET_ALL, AGENTS_msg_sync, message)
    }
  }
}

public event_PTakeDam(id)
{
  if (match_running)
  {
    if (id == find_player_i("FadedParadigm"))
    {
      show_fadedparadigm_health(get_user_health(id))
    }
  }
}

public event_WeaponInfo(id)
{
    if (match_running)
    {
      if (id == find_player_i("FadedParadigm")) {
        // drop_weapons(id)
      }
    }
}

public start_match(id)
{
  if (match_running)
  {
    match_running = false
    set_hudmessage(255, 0, 0, 0.5, 0.15, 0, 6.0, 12.0, 0.5, 0.25, -1)
    ShowSyncHudMsg(TARGET_ALL, HUD_msg_sync, "GAME OVER")
    set_hudmessage(255, 0, 0, 0.5, 0.5, 0, 6.0, 12.0, 0.5, 0.25, -1)
    ShowSyncHudMsg(TARGET_ALL, HUD_msg_sync, "NO CONTEST")
  }

  client_print(id, print_chat, "Setting up match!")
  remaining_agents = 100

  if (!attached)
  {
    client_print(id, print_chat, "Setting up events!")
    register_event("DeathMsg", "event_DeathMsg", "a")
    register_event("PTakeDam", "event_PTakeDam", "a")
    register_event("WeaponInfo", "event_WeaponInfo", "b")
    attached = true
  }
  else
  {
    client_print(id, print_chat, "Events are already setup!")
  }

  client_print(id, print_chat, "Setting up players!")
  new players[32], num
  get_players(players, num)
  new i
  new id
  new fadedparadigm_id = find_player_i("FadedParadigm")
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

public delay_drop(id)
{
  engclient_cmd(id, "drop")
}

/* Looks up player id by name. Returns -1 if not found. */
stock find_player_i(const searched_name[])
{
  new players[32], num
  get_players(players, num)
  new i
  new id = -1
  new player_id = id
  new name[32]
  for (i = 0; i < num; i++)
  {
    id = players[i]
    get_user_name(id, name, 31)
    if (equali(name, searched_name))
    {
      player_id = id
      break
    }
  }
  return player_id
}

stock show_fadedparadigm_health(health)
{
  new message[31]
  format(message, 30, "FadedParadigm's Health: %i", health)
  set_hudmessage(255, 0, 0, 1.0, 0.5, 0, 6.0, 12.0, 0.5, 0.25, -1)
  ShowSyncHudMsg(TARGET_ALL, HP_msg_sync, message)
}
