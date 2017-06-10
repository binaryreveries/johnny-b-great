#include <amxmodx>
#include <fun>
#include <amxmisc>
#include <fakemeta>
#include <engine>

#define PLUGIN "Johnny B. Great!"
#define VERSION "0.1"
#define AUTHOR "tree"
#define MAX_TEAMS 2

new attached = false
// teams are 1-indexed >__<
new teams[MAX_TEAMS + 1][16]
new total_teams

public plugin_init()
{
  // register plugin with AMX Mod X
  register_plugin(PLUGIN, VERSION, AUTHOR)

  // register say commands which are used via chat
  register_clcmd("say /jbg", "start_match", -1,
    "Shows Johnny B. Great info.")
}

public event_ScoreInfo(id)
{
    new name[32]
    get_user_name(id, name, 31)
    if (!equali(name, "FadedParadigm"))
    {
      client_cmd(id, "jointeam 1")
      client_print(id, print_chat, "You can only spawn as a Pleb, Pleb ;)")
    }
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
  if (is_user_bot(id))
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

public start_match(id)
{
  if (!attached)
  {
    register_event("WeaponInfo", "event_WeaponInfo", "b")
    register_event("ScoreInfo", "event_ScoreInfo", "a", "5=2")
    attached = true
  }

  client_print(id, print_chat, "Setting up match!")
  setup_match()

  // collect the valid teams (stored in teams global)
  get_all_teams()

  client_print(id, print_chat, "Setting up players!")

  setup_players()

  client_print(id, print_chat, "Johnny B. Great is now active!")
}

stock setup_match()
{
  set_cvar_string("mp_teamlist", "Plebs;FadedParadigm")
  set_cvar_string("mp_teammodels", "seal|gordon;")
  set_cvar_num("mp_teamplay", 1)
  change_level("ts_lobby")
}

stock setup_players()
{
  new const fadedParadigm_team = 2
  new players[32], num
  get_players(players, num)
  new i
  new id
  new name[32]
  new fadedparadigm_setup = false
  new cmd[40]
  for (i = 0; i < num; i++)
  {
    id = players[i]
    get_user_name(id, name, 31)
    if (!fadedparadigm_setup && equali(name, "FadedParadigm"))
    {
      client_print(0, print_chat, "Moving %s to team %s!", name, teams[fadedParadigm_team])
      format(cmd, 39, "model %s", teams[fadedParadigm_team])
      client_cmd(id, cmd)
      increase_health(id, 1000)
      drop_weapons(id);
      fadedparadigm_setup = true
    }
    else
    {
      client_print(0, print_chat, "Moving %s to team %s!", name, teams[1])
      format(cmd, 39, "model %s", teams[1])
      client_cmd(id, cmd)
    }
  }
}

stock increase_health(id, amount)
{
  set_user_health(id, amount)
  client_print(id, print_chat, "Set Health to %i!", amount)
}

// take from ts_teamcmd.sma
stock get_all_teams()
{
  new raw_team_string[128]
  get_cvar_string("mp_teamlist", raw_team_string, 127)
  client_print(0, print_chat, "Begin parsing teamlist: %s!", raw_team_string)

  new index = 1, length = strlen(raw_team_string)
  new new_length = (1 + copyc(teams[index], 23, raw_team_string, ';'))
  while((new_length < length) && (++index <= MAX_TEAMS))
  {
    new_length += (1 + copyc(teams[index], 23, raw_team_string[new_length], ';'))
    total_teams++
  }
}
