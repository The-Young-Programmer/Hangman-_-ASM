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
;; Contains the functions of the main menu.
;;
;; Index:
;;     _main_menu()       -- Displays the main menu.
;;     _draw_main_menu()  -- (Re)draws the main menu on the screen.
;;



;=========================================================== _main_menu() ====
;; Displays the main menu.

;; Using:
;; call _main_menu


_main_menu:

;Flush the input buffer
mov ah, 0x0C
mov al, 0
int 0x21

;Draw the UI
call _draw_ui

;Print the help message
mov HELP_STR, offset main_menu_help
call _print_help

jmp main_menu_st_refresh

;Play a sound when the item change
main_menu_st_snd:
    mov SOUND, offset SND_MENU_CH_ITEM
    call _clear_working
    call _draw_main_menu
    call _play_sound
    jmp main_menu_st

main_menu_st_refresh:
    call _clear_working
    call _draw_main_menu

;The main menu
main_menu_st:
    ;Wait for input
    mov ax, 0x0000
    int 0x16

    ;Test the input
    cmp al, ' '         ;Space
    je main_menu_validate
    cmp al, 0x0D        ;Enter
    je main_menu_validate
    cmp ah, 0x50        ;Down arrow
    je main_menu_movedown
    cmp ah, 0x48        ;Up arrow
    je main_menu_moveup
    cmp ax, 0x011B      ;Escape
    je main_menu_end

    ;Not a valid input... try again ! :p
    jmp main_menu_st

    ;Move down in the menu
    main_menu_movedown:
        inc main_menu_selected

        cmp main_menu_selected, main_menu_items_numb
        jne main_menu_st_snd

        mov main_menu_selected, 0

        jmp main_menu_st_snd

    ;Move up in the menu
    main_menu_moveup:
        dec main_menu_selected

        cmp main_menu_selected, -1
        jne main_menu_st_snd

        mov main_menu_selected, main_menu_items_numb
        dec main_menu_selected

        jmp main_menu_st_snd

    ;Validate the selected item
    main_menu_validate:
        mov SOUND, offset SND_MENU_VALID
        call _play_sound

        ;Single player
        cmp main_menu_selected, MAIN_MENU_SINGLE_PLAYER
        jne main_menu_sp_end
        call _single_player
        jmp _main_menu
        main_menu_sp_end:

        ;Two players
        cmp main_menu_selected, MAIN_MENU_TWO_PLAYERS
        jne main_menu_tp_end
        call _two_players
        jmp _main_menu
        main_menu_tp_end:

        ;Options
        cmp main_menu_selected, MAIN_MENU_OPTIONS
        jne main_menu_option_end
        call _option_menu
        jmp _main_menu
        main_menu_option_end:

        ;Scores
        cmp main_menu_selected, MAIN_MENU_SCORES
        jne main_menu_scores_end
        call _scores
        jmp _main_menu
        main_menu_scores_end:

        ;Quit
        cmp main_menu_selected, MAIN_MENU_QUIT
        je main_menu_end2

        jmp main_menu_st_refresh

main_menu_end:
mov SOUND, offset SND_MENU_VALID
call _play_sound
main_menu_end2:

ret



;=================================================== _draw_main_menu() ====
;; (Re)draws the main menu on the screen.

;; Using:
;; call _draw_main_menu


_draw_main_menu:

;Center the menu
mov pos_x, (COLS-main_menu_items_len)/2
mov pos_y, header_height
add pos_y, 4

;Prepare the print
mov ah, 0x09
mov dx, offset main_menu_items

mov cx, main_menu_items_numb

;Draw items
draw_menu_loop:
    call _move_cursor
    int 0x21
    add pos_y, 2
    add dx, main_menu_items_len
    dec cx
    cmp cx, 0
    jne draw_menu_loop


;Display the cursor on the selected item
mov pos_y, header_height
add pos_y, 4
mov ah, 0x00
mov al, main_menu_selected
mov bl, 2
mul bl
add pos_y, al

call _move_cursor

mov ah, 0x09
mov al, 0x10
mov bh, 0
mov bl, COLOR_CURSOR ; color
mov cx, 1
int 0x10

ret



;============================ Vars for _main_menu() and _draw_main_menu() ====
main_menu_selected db 1  ;The selected item of the menu



;=========================== Datas for _main_menu() and _draw_main_menu() ====
main_menu_help  db 0xDA,0x18,0x19,0xBF," Navigate   ",0xDA,"Enter",0xBF
                db " Validate                                    ",0xDA
                db "Esc",0xBF, " Quit$"
main_menu_items db "  Single Player$"
                db "  Two players  $"
                db "  Options      $"
                db "  Scores       $"
                db "  Quit         $"
main_menu_items_len  equ 16
main_menu_items_numb equ 5

MAIN_MENU_SINGLE_PLAYER equ 0
MAIN_MENU_TWO_PLAYERS   equ 1
MAIN_MENU_OPTIONS       equ 2
MAIN_MENU_SCORES        equ 3
MAIN_MENU_QUIT          equ 4

