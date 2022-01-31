;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;      __   __  _______  __    _  _______  __   __  _______  __    _          ;;
;;     |  | |  ||   _   ||  |  | ||       ||  |_|  ||   _   ||  |  | |         ;;
;;     |  |_|  ||  |_|  ||   |_| ||    ___||       ||  |_|  ||   |_| |         ;;
;;     |       ||       ||       ||   | __ |       ||       ||       |         ;;
;;     |       ||       ||  _    ||   ||  ||       ||       ||  _    |         ;;
;;     |   _   ||   _   || | |   ||   |_| || ||_|| ||   _   || | |   |         ;;
;;     |__| |__||__| |__||_|  |__||_______||_|   |_||__| |__||_|  |__|         ;;
;;                                                                             ;;
;;                                                                             ;;
;;  HANGMAN - An implementation of the Hang Man game in assembly (Emu8086)     ;;
;;                                                                             ;;
;;  Created by The Young Programmer [TYP 💻] in 2022                           ;;
;;  Created by The Young Programmer [TYP 💻] in 2022                           ;;
;;  Created by The Young Programmer [TYP 💻] in 2022                           ;;
;;  Created by The Young Programmer [TYP 💻] in 2022                           ;;
;;                                                                             ;;           
;;                                                                             ;;
;;  HangMan game is free software: I value keeping my site open source,        ;;
;;  but as you all know, PLAGIARISM IS BAD. It's always disheartening          ;;
;;  whenever I find that someone has copied my code without giving me credit   ;;
;;  I spent a lot of time and effort building this game.                       ;;
;;  All I ask of you all is to not claim this effort as your own.              ;;
;;  You can redistribute it and/or modify.                                     ;;
;;                                                                             ;;
;;            Please give me proper credit by linking back to                  ;;
;;     https://github.com/The-Young-Programmer/Hangman-_-ASM. Thanks!          ;;
;;                                                                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
;; Contains the sounds ressources.
;;



;========================================================== Startup music ====
;              Sound, duration
SND_START   dw     4049,  1
            dw    40000,  1
            dw     3033,  1
            dw    40000,  4
            dw     2702,  5
            dw    40000,  1
            dw     2407,  2
            dw    40000,  2
            dw     3033,  2
            dw    40000,  3
            dw     4049,  3
            dw    40000,  2
            dw     4049,  1
            dw    40000,  3
            dw     3405,  3
            dw    40000,  3
            dw     3607,  2
            dw    40000,  3
            dw     4049,  4
            dw    40000,  5
            dw     3405,  2
            dw    40000,  2
            dw     3405,  1
            dw    40000,  1
            dw     2551,  2
            dw    40000,  1
            dw     3405,  1
            dw    40000,  1
            dw     2551,  4
            dw    40000,  4
            dw     2272,  6
            dw    40000,  2
            dw     3405,  2
            dw    40000,  2
            dw     3405,  2
            dw    40000,  2
            dw     3405,  2
            dw    40000,  1
            dw     3033,  6
            dw        0,  0


;================================================================== Menus ====
;                     Sound, duration
SND_MENU_CH_ITEM dw    4000, 01
                 dw       0,  0


;                   Sound, duration
SND_MENU_VALID dw    2000, 01
               dw    0800, 02
               dw       0,  0



;=================================================================== Game ====
;                       Sound, duration
SND_GAME_GOOD_LTTR dw    4000, 01
                   dw    2000, 01
                   dw    1000, 01
                   dw       0,  0


;                      Sound, duration
SND_GAME_BAD_LTTR dw    9000, 01
                  dw       0,  0


;                 Sound, duration
SND_GAME_DIE dw    7000, 02
             dw    8000, 02
             dw    9000, 02
             dw    9999, 08
             dw       0,  0


;                 Sound, duration
SND_GAME_GG dw     3000, 02
            dw     2500, 02
            dw     2000, 02
            dw    20000, 01
            dw     2500, 02
            dw     2000, 02
            dw     1500, 02
            dw    20000, 01
            dw     2000, 02
            dw     1500, 02
            dw     1000, 03
            dw        0,  0

