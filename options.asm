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
;; Contains the options menu.
;;
;; Index:
;;     _option_menu()       -- Displays the option menu.
;;     _draw_option_menu()  -- (Re)draws the option menu on the screen.
;;



OPTION_GIBBET      db 1
OPTION_GIBBET_ON  equ 1
OPTION_GIBBET_OFF equ 0


OPTION_DICT     db 0
OPTION_DICT_EN equ 0
OPTION_DICT_FR equ 1



;========================================================= _option_menu() ====
;; Displays the option menu.

;; Using:
;; call _option_menu


_option_menu:

;Flush the input buffer
mov ah, 0x0C
mov al, 0
int 0x21

;Draw the UI
call _draw_ui

;Print the help message
mov HELP_STR, offset option_menu_help
call _print_help
jmp option_menu_refresh

option_menu_snd:
    mov SOUND, offset SND_MENU_CH_ITEM
    call _draw_option_menu
    call _play_sound
    jmp option_menu_loop

option_menu_refresh:
    call _draw_option_menu

option_menu_loop:
    ;Wait for input
    mov ah, 0x00
    int 0x16

    cmp al, ' '          ;Space
    jz  option_menu_validate
    cmp al, 0x0D         ;Enter
    jz  option_menu_validate
    cmp ah, 0x4B         ;Left arrow
    jz  option_menu_validate
    cmp ah, 0x4D         ;Right arrow
    jz  option_menu_validate
    cmp ah, 0x50         ;Down arrow
    jz  option_menu_movedown
    cmp ah, 0x48         ;Up arrow
    jz  option_menu_moveup
    cmp ax, 0x011B       ;Escape
    jz  option_menu_end

    ;Not a valid input
    jmp option_menu_loop

    ;Move down
    option_menu_movedown:
        inc option_menu_selected

        cmp option_menu_selected, option_menu_items_numb
        jnz option_menu_snd

        mov option_menu_selected, 0
        jmp option_menu_snd

    ;Move up
    option_menu_moveup:
        dec option_menu_selected

        cmp option_menu_selected, -1
        jnz option_menu_snd

        mov option_menu_selected, option_menu_items_numb
        dec option_menu_selected
        jmp option_menu_snd

    ;Validate
    option_menu_validate:
        mov SOUND, offset SND_MENU_VALID
        call _play_sound

        ;Gibbet
        cmp option_menu_selected, OPTION_MENU_GIBBET
        jnz option_menu_gibbet_end
        not OPTION_GIBBET
        and OPTION_GIBBET, 00000001b
        option_menu_gibbet_end:

        ;Dictionary
        cmp option_menu_selected, OPTION_MENU_DICT
        jnz option_menu_dict_end
        not OPTION_DICT
        and OPTION_DICT, 00000001b
        option_menu_dict_end:

        ;Dictionary
        cmp option_menu_selected, OPTION_MENU_BACK
        jnz option_menu_back_end
        jmp option_menu_end
        option_menu_back_end:

        jmp option_menu_refresh

option_menu_end:

ret



;==================================================== _draw_option_menu() ====
;; (Re)draws the option menu on the screen.

;; Using:
;; call _draw_option_menu


_draw_option_menu:

call _clear_working

;Calclulate the position of the first item
mov POS_X, COLS / 2 - 15
mov POS_Y, header_height
add POS_Y, 4

call _move_cursor

mov ah, 0x09

;Print the GIBBET item
cmp OPTION_GIBBET, OPTION_GIBBET_ON
je  droption_gibbet_on
;GIBBET = OFF
mov dx, offset option_item_gibbet_off
jmp droption_gibbet_end
droption_gibbet_on: ;GIBBET = ON
mov dx, offset option_item_gibbet_on
droption_gibbet_end:
int 0x21 ;Print

add POS_Y, 2
call _move_cursor

;Print the DICTIONARY item
cmp OPTION_DICT, OPTION_DICT_FR
je  droption_dict_fr
;DICT = EN
mov dx, offset option_item_dict_en
jmp droption_dict_end
droption_dict_fr: ;DICT = FR
mov dx, offset option_item_dict_fr
droption_dict_end:
int 0x21 ;Print

add POS_Y, 2
call _move_cursor

;Print the BACK item
mov dx, offset option_item_backmain
int 0x21 ;Print

;=> Print the arrow (selected item)
;Calclulate the position of the selected item
mov POS_X, COLS / 2 - 15 - 2
mov POS_Y, header_height
add POS_Y, 4
mov ah, 0x00
mov al, option_menu_selected
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



;======================== Vars for _option_menu() and _draw_option_menu() ====
option_menu_selected db 0  ;The selected item of the menu



;======================= Datas for _option_menu() and _draw_option_menu() ====
option_menu_help  db 0xDA,0x18,0x19,0xBF," Navigate   ",0xDA,"Enter",0xBF
                db " Validate / Toggle options                   ",0xDA
                db "Esc",0xBF, " Quit$"

option_item_gibbet_on   db "Gibbet      [ With ]   Without  $"
option_item_gibbet_off  db "Gibbet        With   [ Without ]$"
OPTION_MENU_GIBBET     equ 0

option_item_dict_en     db "Dictionary  [ English ]   French  $"
option_item_dict_fr     db "Dictionary    English   [ French ]$"
OPTION_MENU_DICT       equ 1

option_item_backmain    db "Back$"
OPTION_MENU_BACK       equ 2

option_menu_items_numb equ 3

