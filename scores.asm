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
;; Contains the functions for displaying and managing scores.
;;
;; Index:
;;     _scores                               -- Displays the best scores.
;;     _new_sp_score(NSPS_NAME, NSPS_SCORE)  -- Insert the new score if
;;                                              necessary (single PLAYER
;;                                              mode).
;;     _new_tp_score(NTPS_NAME, NTPS_SCORE)  -- Insert the new score if
;;                                              necessary (two PLAYER
;;                                              mode).
;;



SP_SCORE_1N db "FLOZZ   "
SP_SCORE_1S dw 1000

SP_SCORE_2N db "WILBER  "
SP_SCORE_2S dw 100

SP_SCORE_3N db "THIERRY "
SP_SCORE_3S dw 50


TP_SCORE_1N db "TOMATE  "
TP_SCORE_1S dw 42

TP_SCORE_2N db "WILBER  "
TP_SCORE_2S dw 20

TP_SCORE_3N db "THIERRY "
TP_SCORE_3S dw 10



;============================================================== _scores() ====
;; Contains the functions for displaying and managing scores.

;; Usage:
;; call _scores


_scores:

;Backup registers
push ax
push bx
push cx
push dx

;Draw the UI
call _draw_ui
mov HELP_STR, offset scores_help
call _print_help

;SINGLE PLAYER
    mov POS_X, 15
    mov POS_Y, header_height + 6
    call _move_cursor

    ;TITLE
    mov ah, 0x09
    mov dx, offset scores_sp_title
    int 0x21

    add POS_Y, 2
    call _move_cursor

    ;ITEM 1
    mov MEMCPY_SRC, offset SP_SCORE_1N
    mov MEMCPY_DEST, offset scores_disp_tpl
    add MEMCPY_DEST, 3
    mov MEMCPY_LEN, 8
    call _memcpy
    ;;
    mov ax, SP_SCORE_1S
    mov I2S_INT, ax
    call _inttostr
    mov MEMCPY_SRC, offset I2S_STR
    add MEMCPY_DEST, 9
    mov MEMCPY_LEN, 4
    call _memcpy

    mov ah, 0x09
    mov dx, offset scores_disp_tpl
    int 0x21

    inc POS_Y
    call _move_cursor

    ;ITEM 2
    mov MEMCPY_SRC, offset SP_SCORE_2N
    mov MEMCPY_DEST, offset scores_disp_tpl
    add MEMCPY_DEST, 3
    mov MEMCPY_LEN, 8
    call _memcpy
    ;;
    mov ax, SP_SCORE_2S
    mov I2S_INT, ax
    call _inttostr
    mov MEMCPY_SRC, offset I2S_STR
    add MEMCPY_DEST, 9
    mov MEMCPY_LEN, 4
    call _memcpy

    mov ah, 0x09
    mov dx, offset scores_disp_tpl
    int 0x21

    inc POS_Y
    call _move_cursor

    ;ITEM 3
    mov MEMCPY_SRC, offset SP_SCORE_3N
    mov MEMCPY_DEST, offset scores_disp_tpl
    add MEMCPY_DEST, 3
    mov MEMCPY_LEN, 8
    call _memcpy
    ;;
    mov ax, SP_SCORE_3S
    mov I2S_INT, ax
    call _inttostr
    mov MEMCPY_SRC, offset I2S_STR
    add MEMCPY_DEST, 9
    mov MEMCPY_LEN, 4
    call _memcpy

    mov ah, 0x09
    mov dx, offset scores_disp_tpl
    int 0x21

;TWO PLAYER
    mov POS_X, COLS - 15 - 19
    mov POS_Y, header_height + 6
    call _move_cursor

    ;TITLE
    mov ah, 0x09
    mov dx, offset scores_tp_title
    int 0x21

    add POS_Y, 2
    call _move_cursor

    ;ITEM 1
    mov MEMCPY_SRC, offset TP_SCORE_1N
    mov MEMCPY_DEST, offset scores_disp_tpl
    add MEMCPY_DEST, 3
    mov MEMCPY_LEN, 8
    call _memcpy
    ;;
    mov ax, TP_SCORE_1S
    mov I2S_INT, ax
    call _inttostr
    mov MEMCPY_SRC, offset I2S_STR
    add MEMCPY_DEST, 9
    mov MEMCPY_LEN, 4
    call _memcpy

    mov ah, 0x09
    mov dx, offset scores_disp_tpl
    int 0x21

    inc POS_Y
    call _move_cursor

    ;ITEM 2
    mov MEMCPY_SRC, offset TP_SCORE_2N
    mov MEMCPY_DEST, offset scores_disp_tpl
    add MEMCPY_DEST, 3
    mov MEMCPY_LEN, 8
    call _memcpy
    ;;
    mov ax, TP_SCORE_2S
    mov I2S_INT, ax
    call _inttostr
    mov MEMCPY_SRC, offset I2S_STR
    add MEMCPY_DEST, 9
    mov MEMCPY_LEN, 4
    call _memcpy

    mov ah, 0x09
    mov dx, offset scores_disp_tpl
    int 0x21

    inc POS_Y
    call _move_cursor

    ;ITEM 3
    mov MEMCPY_SRC, offset TP_SCORE_3N
    mov MEMCPY_DEST, offset scores_disp_tpl
    add MEMCPY_DEST, 3
    mov MEMCPY_LEN, 8
    call _memcpy
    ;;
    mov ax, TP_SCORE_3S
    mov I2S_INT, ax
    call _inttostr
    mov MEMCPY_SRC, offset I2S_STR
    add MEMCPY_DEST, 9
    mov MEMCPY_LEN, 4
    call _memcpy

    mov ah, 0x09
    mov dx, offset scores_disp_tpl
    int 0x21

;Wait
mov ax, 0x0000
int 0x16

;Restore registers
pop dx
pop cx
pop bx
pop ax

ret


;Datas
scores_help db "Press any key$"

scores_sp_title db "-- SINGLE PLAYER --$"
scores_tp_title db "--- TWO PLAYERS ---$"
scores_disp_tpl db " > <PLAYER> <SC>$"



;=================================== _new_sp_score(NSPS_NAME, NSPS_SCORE) ====
;; Insert the new score if necessary (single player mode).

;; Usage:
;; mov NSPS_NAME, offset <playername>
;; mov NSPS_SCORE, <score>
;; call _new_sp_score

;; Args:
NSPS_NAME  dw 0 ;Address of the player name
NSPS_SCORE dw 0 ;The score


_new_sp_score:

;Backup registers
push ax
push bx
push cx
push dx

;Check if the score is better than the best score
    mov ax, NSPS_SCORE
    cmp SP_SCORE_1S, ax
    jge nsps_1s_end

    mov ax, SP_SCORE_2S
    mov SP_SCORE_3S, ax
    mov MEMCPY_SRC, offset SP_SCORE_2N
    mov MEMCPY_DEST, offset SP_SCORE_3N
    mov MEMCPY_LEN, 8
    call _memcpy

    mov ax, SP_SCORE_1S
    mov SP_SCORE_2S, ax
    mov MEMCPY_SRC, offset SP_SCORE_1N
    mov MEMCPY_DEST, offset SP_SCORE_2N
    mov MEMCPY_LEN, 8
    call _memcpy

    mov ax, NSPS_SCORE
    mov SP_SCORE_1S, ax
    mov ax, NSPS_NAME
    mov MEMCPY_SRC, ax
    mov MEMCPY_DEST, offset SP_SCORE_1N
    mov MEMCPY_LEN, 8
    call _memcpy

    jmp nsps_end
    nsps_1s_end:

;Check if the score is better than the second score
    mov ax, NSPS_SCORE
    cmp SP_SCORE_2S, ax
    jge nsps_2s_end

    mov ax, SP_SCORE_2S
    mov SP_SCORE_3S, ax
    mov MEMCPY_SRC, offset SP_SCORE_2N
    mov MEMCPY_DEST, offset SP_SCORE_3N
    mov MEMCPY_LEN, 8
    call _memcpy

    mov ax, NSPS_SCORE
    mov SP_SCORE_2S, ax
    mov ax, NSPS_NAME
    mov MEMCPY_SRC, ax
    mov MEMCPY_DEST, offset SP_SCORE_2N
    mov MEMCPY_LEN, 8
    call _memcpy

    jmp nsps_end
    nsps_2s_end:

;Check if the score is better than the third score
    mov ax, NSPS_SCORE
    cmp SP_SCORE_3S, ax
    jge nsps_end

    mov ax, NSPS_SCORE
    mov SP_SCORE_3S, ax
    mov ax, NSPS_NAME
    mov MEMCPY_SRC, ax
    mov MEMCPY_DEST, offset SP_SCORE_3N
    mov MEMCPY_LEN, 8
    call _memcpy


nsps_end:

;Restore registers
pop dx
pop cx
pop bx
pop ax

ret



;=================================== _new_tp_score(NTPS_NAME, NTPS_SCORE) ====
;; Insert the new score if necessary (two player mode).

;; Usage:
;; mov NTPS_NAME, offset <playername>
;; mov NTPS_SCORE, <score>
;; call _new_tp_score

;; Args:
NTPS_NAME  dw 0 ;Address of the player name
NTPS_SCORE dw 0 ;The score


_new_tp_score:

;Backup registers
push ax
push bx
push cx
push dx

;Check if the score is better than the best score
    mov ax, NTPS_SCORE
    cmp TP_SCORE_1S, ax
    jge ntps_1s_end

    mov ax, TP_SCORE_2S
    mov TP_SCORE_3S, ax
    mov MEMCPY_SRC, offset TP_SCORE_2N
    mov MEMCPY_DEST, offset TP_SCORE_3N
    mov MEMCPY_LEN, 8
    call _memcpy

    mov ax, TP_SCORE_1S
    mov TP_SCORE_2S, ax
    mov MEMCPY_SRC, offset TP_SCORE_1N
    mov MEMCPY_DEST, offset TP_SCORE_2N
    mov MEMCPY_LEN, 8
    call _memcpy

    mov ax, NTPS_SCORE
    mov TP_SCORE_1S, ax
    mov ax, NTPS_NAME
    mov MEMCPY_SRC, ax
    mov MEMCPY_DEST, offset TP_SCORE_1N
    mov MEMCPY_LEN, 8
    call _memcpy

    jmp ntps_end
    ntps_1s_end:

;Check if the score is better than the second score
    mov ax, NTPS_SCORE
    cmp TP_SCORE_2S, ax
    jge ntps_2s_end

    mov ax, TP_SCORE_2S
    mov TP_SCORE_3S, ax
    mov MEMCPY_SRC, offset TP_SCORE_2N
    mov MEMCPY_DEST, offset TP_SCORE_3N
    mov MEMCPY_LEN, 8
    call _memcpy

    mov ax, NTPS_SCORE
    mov TP_SCORE_2S, ax
    mov ax, NTPS_NAME
    mov MEMCPY_SRC, ax
    mov MEMCPY_DEST, offset TP_SCORE_2N
    mov MEMCPY_LEN, 8
    call _memcpy

    jmp ntps_end
    ntps_2s_end:

;Check if the score is better than the third score
    mov ax, NTPS_SCORE
    cmp TP_SCORE_3S, ax
    jge ntps_end

    mov ax, NTPS_SCORE
    mov TP_SCORE_3S, ax
    mov ax, NTPS_NAME
    mov MEMCPY_SRC, ax
    mov MEMCPY_DEST, offset TP_SCORE_3N
    mov MEMCPY_LEN, 8
    call _memcpy


ntps_end:

;Restore registers
pop dx
pop cx
pop bx
pop ax

ret


