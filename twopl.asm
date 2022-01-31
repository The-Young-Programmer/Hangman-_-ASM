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
;; Contains the two players mode.
;;
;; Index:
;;     _two_players()            -- Play in two players mode.
;;



;======================================================= _two_players() ====
;; Play in two players mode.

;; Usage:
;; call _two_players


_two_players:

;Backup registers

push ax
push bx
push cx
push dx

;Get the mode
call _mode_menu

;Back to the main menu if necessary
cmp MODE, -1
je tp_end


;Ask the first player's name
mov IF_MSG, offset tp_msg_fplname
mov IF_MAXLEN, 8
mov IF_EWD, 0
call _input_field
mov MEMCPY_SRC, offset IF_WORD
mov MEMCPY_DEST, offset tp_fplname
mov MEMCPY_LEN, 8
call _memcpy
nop

;Ask the second player's name

mov IF_MSG, offset tp_msg_splname
mov IF_MAXLEN, 8
mov IF_EWD, 0
call _input_field
mov MEMCPY_SRC, offset IF_WORD
mov MEMCPY_DEST, offset tp_splname
mov MEMCPY_LEN, 8
call _memcpy
nop



;Game loop.

mov cx, 3
tp_game_loop:

;Ask the first player's secret word.

mov MEMCPY_SRC, offset tp_fplname
mov MEMCPY_DEST, offset tp_msg_fplword
mov MEMCPY_LEN, 8
call _memcpy
mov IF_MSG, offset tp_msg_fplword
mov IF_MAXLEN, 26
mov IF_EWD, 1
call _input_field
mov MEMCPY_SRC, offset IF_WORD
mov MEMCPY_DEST, offset tp_fplword
mov MEMCPY_LEN, 26
call _memcpy
nop

;Let's play with the second player !

mov WORD, offset tp_fplword
;SET PLAYER
mov MEMCPY_SRC, offset tp_splname
mov MEMCPY_DEST, offset PLAYER
mov MEMCPY_LEN, 8
call _memcpy

;SET SCORE
mov ah, 0
mov al, play_sp_lives
mov SCORE, ax

call _play


;Count the second player's lives.

mov ax, 0
mov al, play_lives
add play_sp_lives, al

;Test if play whith gibbets, add 6 points if yes.
cmp OPTION_GIBBET, OPTION_GIBBET_ON
jnz tp_gibbet_end_sp:
add play_sp_lives, 6
tp_gibbet_end_sp:

;Abort game.

cmp GAME_STATUS, GAME_STATUS_ABORT
je tp_end

;Ask the second player's secret word.

mov MEMCPY_SRC, offset tp_splname
mov MEMCPY_DEST, offset tp_msg_splword
mov MEMCPY_LEN, 8
call _memcpy
mov IF_MSG, offset tp_msg_splword
mov IF_MAXLEN, 26
mov IF_EWD, 1
call _input_field
mov MEMCPY_SRC, offset IF_WORD
mov MEMCPY_DEST, offset tp_splword
mov MEMCPY_LEN, 26
call _memcpy
nop

;Let's play with the first player !

mov WORD, offset tp_splword
;SET PLAYER
mov MEMCPY_SRC, offset tp_fplname
mov MEMCPY_DEST, offset PLAYER
mov MEMCPY_LEN, 8
call _memcpy

;SET SCORE
mov ah, 0
mov al, play_fp_lives
mov SCORE, ax

call _play

;Count the first player's lives.

mov ax, 0
mov al, play_lives
add play_fp_lives, al

;Test if play whith gibbets, add 6 points if yes.
cmp OPTION_GIBBET, OPTION_GIBBET_ON
jnz tp_gibbet_end2:
add play_fp_lives, 6
tp_gibbet_end2:

;Abort game.

cmp GAME_STATUS, GAME_STATUS_ABORT
je tp_end

;Game loop.

dec cx
cmp cx, 0
jne tp_game_loop

;Put the number of lives of the second player in ax.

mov ax, 0
mov al, play_sp_lives

;Jump to fp_win if the first player win.

call _draw_ui

cmp play_fp_lives, al
jg fp_win

;Display message if second player win.

;check if competition mode is set.
cmp MODE, MODE_COMPETITION
jne norm_sp_win

;SCORE
mov NTPS_NAME, offset tp_splname
mov ah, 0
mov al, play_sp_lives
mov NTPS_SCORE, ax
call _new_tp_score

norm_sp_win:
mov POS_X, (COLS-24)/2
mov POS_Y, header_height + 4
call _move_cursor
mov MEMCPY_SRC, offset tp_splname
mov MEMCPY_DEST, offset tp_msg_win
mov MEMCPY_LEN, 8
call _memcpy
mov ah, 0x09
mov dx, offset tp_msg_win
int 0x21

cmp MODE, MODE_COMPETITION
jnz norm_sp_win_end

add POS_Y, 2
call _move_cursor

mov ah, 0
mov al, play_sp_lives
mov I2S_INT, ax
call _inttostr

mov MEMCPY_SRC, offset I2S_STR
mov MEMCPY_DEST, offset tp_msg_score
add MEMCPY_DEST, 7
mov MEMCPY_LEN, 4
call _memcpy

mov ah, 0x09
mov dx, offset tp_msg_score
int 0x21

norm_sp_win_end:

;wait
mov ah, 0x86
mov cx, 96
int 0x15

jmp tp_end

;Display message if first player win.

fp_win:

;Check if competition mode is set.
cmp MODE, MODE_COMPETITION
jne norm_fp_win

;SCORE
mov NTPS_NAME, offset tp_fplname
mov ah, 0
mov al, play_sp_lives
mov NTPS_SCORE, ax
call _new_tp_score

norm_fp_win:
mov POS_X, (COLS-24)/2
mov POS_Y, header_height + 4
call _move_cursor
mov MEMCPY_SRC, offset tp_fplname
mov MEMCPY_DEST, offset tp_msg_win
mov MEMCPY_LEN, 8
call _memcpy
mov ah, 0x09
mov dx, offset tp_msg_win
int 0x21

cmp MODE, MODE_COMPETITION
jnz norm_fp_win_end

add POS_Y, 2
call _move_cursor

mov ah, 0
mov al, play_fp_lives
mov I2S_INT, ax
call _inttostr

mov MEMCPY_SRC, offset I2S_STR
mov MEMCPY_DEST, offset tp_msg_score
add MEMCPY_DEST, 7
mov MEMCPY_LEN, 4
call _memcpy

mov ah, 0x09
mov dx, offset tp_msg_score
int 0x21

norm_fp_win_end:

;wait
mov ah, 0x86
mov cx, 96
int 0x15

tp_end:

;Restore registers

pop dx
pop cx
pop bx
pop ax


ret


;Datas

tp_msg_fplname db "Please enter the first player's name:$"
tp_fplname db "--------"
tp_msg_splname db "Please enter the second player's name:$"
tp_splname db "--------"

tp_msg_fplword db "******** enter your secret word:$"
tp_fplword db "-------------------------"
tp_msg_splword db "******** enter your secret word:$"
tp_splword db "-------------------------"

tp_msg_win db "******** is the winner !$"

tp_msg_score db "Score: 0000$"

play_fp_lives db 0
play_sp_lives db 0

