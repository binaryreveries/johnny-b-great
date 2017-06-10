                    Johnny B. Great! for The Specialists 2.1
                    ========================================
                                  by tree

 This is a fun little mod created in celebration of FadedParadigm's upcoming
 wedding. When the "Jonny B. Great!" gamemode is activated, the player named
 "FadedParadigm" is given 1000 health and has all their weapons stripped. For
 the entire duration of the activation, "FadedParadigm" will not be able to
 pick up weapons. Once the player's health reaches 100, he will be given a
 kung-fu powerup.

 ## Instructions ##
 Add these lines to `server.cfg` if they do not exist already:

      ```
         mp_teamlist "Plebs;FadedParadigm"
         mp_teammodels "laurence;merc;seal|gordon;"
         bottalk 0
      ```

 ####  NOTE: ####
 You can use any player models you'd like for `mp_teammodels`.
 However, you should not change the names or the order of the teams.

 Add this line to `game.cfg` if it does not exist already:

      ```
         "mp_teamplay" "1"
      ```
