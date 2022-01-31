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
;; Contains the mode selection menu.
;;
;; Index:
;;     _mode_menu()       -- Displays the mode selection menu.
;;     _draw_mode_menu()  -- (Re)draws the mode selection menu on the screen.
;;



MODE              db 0
MODE_PRACTICE    equ 0
MODE_COMPETITION equ 1



;=========================================================== _mode_menu() ====
;; Displays the mode selection menu.

;; Using:
;; call _mode_menu


_mode_menu:

;Flush the input buffer
mov ah, 0x0C
mov al, 0
int 0x21

;Set the variables to theire default
mov MODE, MODE_PRACTICE
mov mode_menu_selected, MODE_MENU_PRACTICE

;Draw the UI
call _draw_ui

;Print the help message
mov HELP_STR, offset mode_menu_help
call _print_help
jmp mode_menu_refresh

mode_menu_snd:
    mov SOUND, offset SND_MENU_CH_ITEM
    call _draw_mode_menu
    call _play_sound
    jmp mode_menu_loop

mode_menu_refresh:
    call _draw_mode_menu

mode_menu_loop:
    ;Wait for input
    mov ah, 0x00
    int 0x16

    cmp al, ' '          ;Space
    jz  mode_menu_validate
    cmp al, 0x0D         ;Enter
    jz  mode_menu_validate
    cmp ah, 0x50         ;Down arrow
    jz  mode_menu_movedown
    cmp ah, 0x48         ;Up arrow
    jz  mode_menu_moveup
    cmp ax, 0x011B       ;Escape
    jz  mode_menu_backtomain

    ;Not a valid input
    jmp mode_menu_loop

    ;Move down
    mode_menu_movedown:
        inc mode_menu_selected

        cmp mode_menu_selected, mode_menu_items_numb
        jnz mode_menu_snd

        mov mode_menu_selected, 0
        jmp mode_menu_snd

    ;Move up
    mode_menu_moveup:
        dec mode_menu_selected

        cmp mode_menu_selected, -1
        jnz mode_menu_snd

        mov mode_menu_selected, mode_menu_items_numb
        dec mode_menu_selected
        jmp mode_menu_snd

    ;Validate
    mode_menu_validate:
        mov SOUND, offset SND_MENU_VALID
        call _play_sound

        ;Practice
        cmp mode_menu_selected, MODE_MENU_PRACTICE
        jnz mode_menu_practice_end
        mov MODE, MODE_PRACTICE
        jmp mode_menu_end
        mode_menu_practice_end:

        ;Competition
        cmp mode_menu_selected, MODE_MENU_COMPETITION
        jnz mode_menu_competition_end
        mov MODE, MODE_COMPETITION
        jmp mode_menu_end
        mode_menu_competition_end:

        ;Back
        cmp mode_menu_selected, MODE_MENU_BACK
        jnz mode_menu_back_end
        jmp mode_menu_backtomain
        mode_menu_back_end:

        jmp mode_menu_refresh

mode_menu_backtomain:
mov MODE, -1

mode_menu_end:

ret



;====================================================== _draw_mode_menu() ====
;; (Re)draws the mdoe selection menu on the screen.

;; Using:
;; call _draw_mode_menu


_draw_mode_menu:

;Center the menu
mov pos_x, (COLS-mode_menu_items_len)/2
mov pos_y, header_height
add pos_y, 4

;Prepare the print
mov ah, 0x09
mov dx, offset mode_menu_items

mov cx, mode_menu_items_numb

;Draw items
draw_mode_menu_loop:
    call _move_cursor
    int 0x21
    add pos_y, 2
    add dx, mode_menu_items_len
    dec cx
    cmp cx, 0
    jne draw_mode_menu_loop


;Display the cursor on the selected item
mov pos_y, header_height
add pos_y, 4
mov ah, 0x00
mov al, mode_menu_selected
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



;============================ Vars for _mode_menu() and _draw_mode_menu() ====
mode_menu_selected db 0  ;The selected item of the menu



;=========================== Datas for _mode_menu() and _draw_mode_menu() ====
mode_menu_help  db 0xDA,0x18,0x19,0xBF," Navigate   ",0xDA,"Enter",0xBF
                db " Validate                                    ",0xDA
                db "Esc",0xBF, " Quit$"

mode_menu_items db "  Practice     $"
                db "  Competition  $"
                db "  Back         $"
mode_menu_items_len  equ 16
mode_menu_items_numb equ 3

MODE_MENU_PRACTICE      equ 0
MODE_MENU_COMPETITION   equ 1
MODE_MENU_BACK          equ 2


