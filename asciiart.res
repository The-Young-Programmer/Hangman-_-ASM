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
;; Contains the ASCII art of the game.
;;



;============================================================ Header Logo ====
header db " __   __  _______  __    _  _______  __   __  _______  __    _ $"
       db "|  | |  ||   _   ||  |  | ||       ||  |_|  ||   _   ||  |  | |$"
       db "|  |_|  ||  |_|  ||   |_| ||    ___||       ||  |_|  ||   |_| |$"
       db "|       ||       ||       ||   | __ |       ||       ||       |$"
       db "|       ||       ||  _    ||   ||  ||       ||       ||  _    |$"
       db "|   _   ||   _   || | |   ||   |_| || ||_|| ||   _   || | |   |$"
       db "|__| |__||__| |__||_|  |__||_______||_|   |_||__| |__||_|  |__|$"

header_len    equ 64
header_height equ  7



;============================================================ Header Logo ====
gameover db "   _____                         ____                  $"
         db "  / ____|                       / __ \                 $"
         db " | |  __  __ _ _ __ ___   ___  | |  | |__   _____ _ __ $"
         db " | | |_ |/ _` | '_ ` _ \ / _ \ | |  | |\ \ / / _ \ '__|$"
         db " | |__| | (_| | | | | | |  __/ | |__| | \ V /  __/ |   $"
         db "  \_____|\__,_|_| |_| |_|\___|  \____/   \_/ \___|_|   $"

gameover_len    equ 56
gameover_height equ  6



;========================================================= Startup Screen ====
startup_scr db "    _____ _____    _    __  __ _______   ______     $"
            db "   |_   _| ____|  / \  |  \/  |_   _\ \ / /  _ \    $"
            db "     | | |  _|   / _ \ | |\/| | | |  \ V /| |_) |   $"
            db "     | | | |___ / ___ \| |  | | | |   | | |  __/    $"
            db "     |_| |_____/_/   \_\_|  |_| |_|   |_| |_|       $"
            db "                                                    $"
            db "                 - Presents -                       $"
            db "                                                    $"
            db "                                                    $"
            db "                                                    $"
            db "                                                    $"
            db "                                                    $"
            db "                                                    $"
            db "    Created by The Young Programmer [TYP 💻]        $"
            db "    Created by The Young Programmer [TYP 💻]        $"
            db "    Created by The Young Programmer [TYP 💻]        $"
            db "    Created by The Young Programmer [TYP 💻]        $"

startup_scr_len    equ 48
startup_scr_height equ 18



;================================================================= Gibbet ====
GIBBET_WIDTH  equ 15
GIBBET_HEIGHT equ  9

HANGMAN_LIVES_10 db "              $"
                 db "              $"
                 db "              $"
                 db "              $"
                 db "              $"
                 db "              $"
                 db "              $"
                 db "              $"
                 db "              $"

HANGMAN_LIVES_09 db "              $"
                 db "              $"
                 db "              $"
                 db "              $"
                 db "              $"
                 db "              $"
                 db "+------------+$"
                 db "|            |$"
                 db "+------------+$"

HANGMAN_LIVES_08 db "+             $"
                 db "|             $"
                 db "|             $"
                 db "|             $"
                 db "|             $"
                 db "|             $"
                 db "+------------+$"
                 db "|            |$"
                 db "+------------+$"

HANGMAN_LIVES_07 db "+------+      $"
                 db "|             $"
                 db "|             $"
                 db "|             $"
                 db "|             $"
                 db "|             $"
                 db "+------------+$"
                 db "|            |$"
                 db "+------------+$"

HANGMAN_LIVES_06 db "+------+      $"
                 db "|      |      $"
                 db "|             $"
                 db "|             $"
                 db "|             $"
                 db "|             $"
                 db "+------------+$"
                 db "|            |$"
                 db "+------------+$"

HANGMAN_LIVES_05 db "+------+      $"
                 db "|      |      $"
                 db "|      O      $"
                 db "|             $"
                 db "|             $"
                 db "|             $"
                 db "+------------+$"
                 db "|            |$"
                 db "+------------+$"

HANGMAN_LIVES_04 db "+------+      $"
                 db "|      |      $"
                 db "|      O      $"
                 db "|      |      $"
                 db "|             $"
                 db "|             $"
                 db "+------------+$"
                 db "|            |$"
                 db "+------------+$"

HANGMAN_LIVES_03 db "+------+      $"
                 db "|      |      $"
                 db "|      O      $"
                 db "|     /|      $"
                 db "|             $"
                 db "|             $"
                 db "+------------+$"
                 db "|            |$"
                 db "+------------+$"

HANGMAN_LIVES_02 db "+------+      $"
                 db "|      |      $"
                 db "|      O      $"
                 db "|     /|\     $"
                 db "|             $"
                 db "|             $"
                 db "+------------+$"
                 db "|            |$"
                 db "+------------+$"

HANGMAN_LIVES_01 db "+------+      $"
                 db "|      |      $"
                 db "|      O      $"
                 db "|     /|\     $"
                 db "|     /       $"
                 db "|             $"
                 db "+------------+$"
                 db "|            |$"
                 db "+------------+$"

HANGMAN_LIVES_00 db "+------+      $"
                 db "|      |      $"
                 db "|      O      $"
                 db "|     /|\     $"
                 db "|     / \     $"
                 db "|             $"
                 db "+------------+$"
                 db "|            |$"
                 db "+------------+$"


HANGMAN_GAMEOVER_00 db "+------+      $"
                    db "|      |      $"
                    db "|      O      $"
                    db "|     /|\     $"
                    db "|     / \     $"
                    db "|             $"
                    db "+------------+$"
                    db "|  YOU  DIE  |$"
                    db "+------------+$"

HANGMAN_GAMEOVER_01 db "+------+      $"
                    db "|     /       $"
                    db "|   _O        $"
                    db "|  _/\        $"
                    db "|   \         $"
                    db "|             $"
                    db "+------------+$"
                    db "|  YOU  DIE  |$"
                    db "+------------+$"

HANGMAN_GAMEOVER_02 db "+------+      $"
                    db "|      |      $"
                    db "|      O      $"
                    db "|     /|\     $"
                    db "|     / \     $"
                    db "|             $"
                    db "+------------+$"
                    db "|            |$"
                    db "+------------+$"

HANGMAN_GAMEOVER_03 db "+------+      $"
                    db "|       \     $"
                    db "|        O_   $"
                    db "|        /\_  $"
                    db "|         /   $"
                    db "|             $"
                    db "+------------+$"
                    db "|  YOU  DIE  |$"
                    db "+------------+$"


HANGMAN_GOODGAME_00 db "+------+      $"
                    db "|      |      $"
                    db "|             $"
                    db "|      O      $"
                    db "|     /|\     $"
                    db "|     / \     $"
                    db "+------------+$"
                    db "| GOOD  GAME |$"
                    db "+------------+$"

HANGMAN_GOODGAME_01 db "+------+      $"
                    db "|      |      $"
                    db "|             $"
                    db "|      O_     $"
                    db "|     /|      $"
                    db "|     / \     $"
                    db "+------------+$"
                    db "| GOOD  GAME |$"
                    db "+------------+$"

HANGMAN_GOODGAME_02 db "+------+      $"
                    db "|      |      $"
                    db "|             $"
                    db "|      O/     $"
                    db "|     /|      $"
                    db "|     / \     $"
                    db "+------------+$"
                    db "| GOOD  GAME |$"
                    db "+------------+$"

HANGMAN_GOODGAME_03 db "+------+      $"
                    db "|      |      $"
                    db "|             $"
                    db "|      O_     $"
                    db "|     /|      $"
                    db "|     / \     $"
                    db "+------------+$"
                    db "|            |$"
                    db "+------------+$"

