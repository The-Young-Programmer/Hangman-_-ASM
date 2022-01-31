






;;
;; Contains the game functions.
;;
;; Index:
;;     _play(WORD)          -- Play to hangman.
;;     _game_init()         -- Initializes the game.
;;     _print_gibbet()      -- Prints the gibbet with remaining lives.
;;     _print_gword()       -- Prints the guessed word (e.g. H _ _ _ _ _ N).
;;     _print_tried_letters -- Prints the letters that the player have already
;;                             tried (e.g. A U I O W).
;;     _print_score()       -- Print the score (in competition mode).
;;     _game_anima()        -- Displays an animation when the player loose
;;                             or win.
;;



GAME_STATUS_LOOSE equ 0
GAME_STATUS_WIN   equ 1
GAME_STATUS_ABORT equ 2

SCORE  dw 0
PLAYER dw "UNNAMED "


;============================================================ _play(WORD) ====
;; Play to hangman.

;; Usage:
;; mov WORD, offset <word>
;; mov PLAYER, offset <playername>
;; call _play

;; Function args:
WORD   dw 0 ;The adress of the word to guess.

;; Returns:
GAME_STATUS db 0 ;The game status (GAME_STATUS_LOOSE, GAME_STATUS_WIN,
                 ;GAME_STATUS_ABORT).


_play:

;Backup registers
push ax
push bx
push cx
push dx

call _draw_ui
mov HELP_STR, offset game_help
call _print_help
call _game_init

mov GAME_STATUS, GAME_STATUS_LOOSE

play_main_loop:
    call _clear_working
    call _print_gword
    call _print_tried_letters
    call _print_gibbet
    call _print_score

    ;Check if the play win
    ;For checking we search underscores in play_gword... It is not very
    ;pretty but it works...
    play_check_win:
    mov cl, play_word_len
    mov bx, offset play_gword
    play_check_win_loop:
        cmp [bx], '_'
        je  play_check_win_end ;not won yet
        inc bx
        dec cl
        cmp cl, 0
        jne play_check_win_loop
        ;The player win !
        mov GAME_STATUS, GAME_STATUS_WIN
        jmp play_eog
    play_check_win_end:

    ;Get a letter
    call _input_letter

    ;Check fo special keys
    cmp LETTER, KB_ENTER ;skip Enter
    je  play_main_loop
    cmp LETTER, KB_BKSP  ;skip Backspace
    je  play_main_loop
    cmp LETTER, KB_ESC   ;stop with Escape
    je  play_abort

    ;Check if the player have already tried this letter
    mov cl, play_tried_len
    mov bx, offset play_tried_letters
    mov al, LETTER
    play_ckeck_tried:
        cmp [bx], al
        je play_main_loop ;Letter already in the list -> play_main_loop
        inc bx
        dec cl
        cmp cl, 0
        jne play_ckeck_tried

    ;The letter is not in the list (play_tried_letters), so we add it
    mov cl, play_tried_len
    mov bx, offset play_tried_letters
    mov al, LETTER
    play_add_letter:
        cmp [bx], ' ' ;Search a space
        je play_add_letter_add
        inc bx
        dec cl
        cmp cl, 0
        jne play_add_letter
        jmp play_add_letter_end ;Something is wrong... No more place !
        play_add_letter_add:
            mov [bx], al
        play_add_letter_end:

    ;Check if the letter is in the word
    mov cl, play_word_len
    sub cl, 2
    mov bx, offset play_word
    inc bx
    mov al, LETTER
    play_check_word:
        cmp [bx], al
        je play_check_word_ok
        inc bx
        dec cl
        cmp cl, 0
        jne play_check_word
        ;The letter is not in the word
        dec play_lives
        mov SOUND, offset SND_GAME_BAD_LTTR
        call _play_sound
        jmp play_check_word_end
        play_check_word_ok:
        mov SOUND, offset SND_GAME_GOOD_LTTR
        call _play_sound
        play_check_word_end:

    ;Check the lives
    cmp play_lives, 0
    je  play_eog ;Hanged x_x

    jmp play_main_loop

play_eog:

call _game_anima
jmp play_end

play_abort:
mov GAME_STATUS, GAME_STATUS_ABORT

play_end:

;Restore registers
pop dx
pop cx
pop bx
pop ax

ret


;_play vars
play_word          db  "------------------------------"
play_word_len      db  0
play_word_max_len  equ 30

play_gword         db  "------------------------------"
play_tried_letters db  "--------------------------"
play_tried_len     equ 26

play_lives         db  0

;Help
game_help  db 0xDA,"A-Z",0xBF," Try a letter                                 "
           db "         ",0xDA,"Esc",0xBF," End the game$"



;=========================================================== _game_init() ====
;; Initializes the game.

;; NOTE: Called by the _play() function.

;; Usage:
;; call _game_init


_game_init:

;Backup registers
push ax
push bx
push cx
push dx

;Put the length of WORD in play_word_len
mov ax, WORD
mov STRLEN_STR, ax
call _strlen
mov al, STRLEN_LEN
mov play_word_len, al

;Put the WORD in play_word
mov ax, WORD
mov MEMCPY_SRC, ax
mov MEMCPY_DEST, offset play_word
mov al, STRLEN_LEN
mov MEMCPY_LEN, al
call _memcpy

;Fill play_tried_letters with spaces
mov bx, offset play_tried_letters
mov cl, play_tried_len

game_init_sploop:
    mov [bx], ' '
    inc bx
    dec cl
    cmp cl, 0
    jne game_init_sploop

;Init the play_lives to 10 (with gibbet) or 6 (without gibbet)
cmp OPTION_GIBBET, OPTION_GIBBET_ON
je  game_init_lives_gibbet_on
mov play_lives, 6
jmp game_init_lives_gibbet_end
game_init_lives_gibbet_on:
mov play_lives, 10
game_init_lives_gibbet_end:

;Restore registers
pop dx
pop cx
pop bx
pop ax

ret



;======================================================== _print_gibbet() ====
;; Prints the gibbet with remaining lives.

;; Usage:
;; call _print_gibbet


_print_gibbet:

;Backup registers
push ax
push bx
push cx
push dx

;Calculate the address of the gibbet that fit with the remaining lives
mov ah, 0
mov al, GIBBET_WIDTH
mov bh, 0
mov bl, GIBBET_HEIGHT
mul bl

mov bx, 10
sub bl, play_lives
mul bl

mov bx, offset HANGMAN_LIVES_10
add bx, ax

;Print the gibbet
mov cl, GIBBET_HEIGHT
mov ah, 0x09
mov dx, bx
mov bx, GIBBET_WIDTH
mov POS_X, COLS - GIBBET_WIDTH - 2
mov POS_Y, (ROWS - GIBBET_HEIGHT) / 2 + (header_height - 1) / 2
print_gibbet_loop:
    call _move_cursor
    int 0x21 ;Print
    add dx, bx
    inc POS_Y
    dec cl
    cmp cl, 0
    jne print_gibbet_loop

;Restore registers
pop dx
pop cx
pop bx
pop ax

ret



;========================================================= _print_gword() ====
;; Prints the guessed word (e.g. H _ _ _ _ _ N).

;; Usage:
;; call _print_gword


_print_gword:

;Backup registers
push ax
push bx
push cx
push dx

;Copy the word in play_gword
mov ax, WORD
mov MEMCPY_SRC, ax
mov MEMCPY_DEST, offset play_gword
mov al, STRLEN_LEN
mov MEMCPY_LEN, al
call _memcpy

;Make the string
mov cl, play_word_len
sub cl, 2
mov bx, offset play_gword
inc bx

print_gword_mkloop:
    mov al, [bx]
    mov ch, play_tried_len
    push bx
    mov bx, offset play_tried_letters
    print_gword_mkloop1:
        mov ah, [bx]
        cmp ah, al
        je print_gword_lil
        dec ch
        inc bx
        cmp ch, 0
        jne print_gword_mkloop1

    print_gword_lnil: ;Letter Not In List
        pop bx
        mov [bx], '_'
        jmp print_gword_mkloopend

    print_gword_lil: ;Letter In List
        pop bx

    print_gword_mkloopend:
        dec cl
        inc bx
        cmp cl, 0
        jne print_gword_mkloop

;Print the word
mov POS_Y, ROWS / 2 + (header_height - 1) - 5
mov POS_X, COLS / 2 - GIBBET_WIDTH + 3
mov al, play_word_len
sub POS_X, al
mov bx, offset play_gword
mov cl, play_word_len
mov ah, 0x02
print_gword_prnloop:
    call _move_cursor
    mov dl, [bx]
    int 0x21 ;print
    inc bx
    add POS_X, 2
    dec cl
    cmp cl, 0
    jne print_gword_prnloop

;Restore registers
pop dx
pop cx
pop bx
pop ax

ret



;================================================= _print_tried_letters() ====
;; Print the letters that the player have already tried (e.g. A U I O W).

;; Usage:
;; call _print_tried_letters


_print_tried_letters:

;Backup registers
push ax
push bx
push cx
push dx

;Calculate the length of the string
mov cl, 0
mov bx, offset play_tried_letters
prn_tried_strlen:
    cmp [bx], ' '
    je  prn_tried_strlen_end
    inc bx
    inc cl
    jmp prn_tried_strlen
prn_tried_strlen_end:

;Calculate the cursor position
mov POS_Y, ROWS / 2 + (header_height - 1) - 2
mov POS_X, COLS / 2 - GIBBET_WIDTH + 3
sub POS_X, cl

;Print letters
cmp cl, 0
je  prn_tried_end
mov bx, offset play_tried_letters
mov ah, 0x02

prnletters_loop:
    call _move_cursor
    mov dl, [bx]
    int 0x21 ;print
    inc bx
    add POS_X, 2
    dec cl
    cmp cl, 0
    jne prnletters_loop

prn_tried_end:

;Restore registers
pop dx
pop cx
pop bx
pop ax

ret



;========================================================= _print_score() ====
;; Print the score (in competition mode).

;; Usage:
;; call _print_tried_letters


_print_score:

;Backup registers
push ax
push bx
push cx
push dx

;Check if we are in competition mode
cmp MODE, MODE_COMPETITION
jnz prn_score_end

;Set the scorebar
mov ah, 0x07
mov al, 0         ; Clear
mov bh, COLOR_SCORE
mov ch, header_height + 1  ;y1
mov cl, 0                  ;x1
mov dh, header_height + 1  ;y2
mov dl, COLS               ;x2
int 0x10

;Paste the player name
mov MEMCPY_SRC, offset PLAYER
mov MEMCPY_DEST, offset prn_score_str
add MEMCPY_DEST, 2
mov MEMCPY_LEN, 8
call _memcpy

;Convert the score into string and paste it
mov ax, SCORE
mov I2S_INT, ax
call _inttostr
mov MEMCPY_SRC, offset I2S_STR
add MEMCPY_DEST, 11
mov MEMCPY_LEN, 4
call _memcpy

;Print the string
mov POS_X, 0
mov POS_Y, header_height + 1
call _move_cursor
mov ah, 0x09
mov dx, offset prn_score_str
int 0x21

prn_score_end:

;Restore registers
pop dx
pop cx
pop bx
pop ax

ret


;Data
prn_score_str db " ",0xC0,"12345678",0xD9," ",0xC0,"1234",0xD9,"$"



;========================================================== _game_anima() ====
;; Displays an animation when the player loose or win.

;; Usage:
;; call _game_anima


_game_anima:

;Backup registers
push ax
push bx
push cx
push dx

;Play a sound
cmp GAME_STATUS, GAME_STATUS_WIN
je  game_anima_sndwin
mov SOUND, offset SND_GAME_DIE
jmp game_anima_sndend
game_anima_sndwin:
mov SOUND, offset SND_GAME_GG
game_anima_sndend:
call _play_sound

;Draw the ui
call _draw_ui

;Print the help message
mov HELP_STR, offset game_anima_help
call _print_help

;Flush the input buffer
mov ah, 0x0C
mov al, 0
int 0x21

;Print the word
mov cl, play_word_len
mov bx, offset play_word
mov POS_X, COLS/2
sub POS_X, cl
mov POS_Y, header_height + GIBBET_HEIGHT + 5
mov ah, 0x02
game_anima_pnrloop:
    call _move_cursor
    mov dl, [bx]
    int 0x21 ;print
    inc bx
    add POS_X, 2
    dec cl
    cmp cl, 0
    jne game_anima_pnrloop

;Loop until the player press any key
game_anima_loop0:
mov ch, 4
cmp GAME_STATUS, GAME_STATUS_WIN
je  game_anima_win
mov dx, offset HANGMAN_GAMEOVER_00
jmp game_anima_loop1
game_anima_win:
mov dx, offset HANGMAN_GOODGAME_00
game_anima_loop1:
    ;Check for keystroke
    mov ah, 0x01
    int 0x16
    jnz game_anima_end

    ;Print the animation (step 00)
    mov cl, GIBBET_HEIGHT
    mov ah, 0x09
    mov POS_X, (COLS - GIBBET_WIDTH) / 2
    mov POS_Y, header_height + 3
    game_anima_prnloop00:
        call _move_cursor
        int 0x21 ;Print
        inc POS_Y
        dec cl
        add dx, GIBBET_WIDTH
        cmp cl, 0
        jne game_anima_prnloop00

    ;Sleep
    push cx
    mov ah, 0x86
    mov cx, 3
    int 0x15
    pop cx

    dec ch
    cmp ch, 0
    je  game_anima_loop0

    jmp game_anima_loop1

game_anima_end:

;Check the char
mov ah, 0x00
int 0x16
cmp al, KB_ESC
jne game_anima_chrend
mov GAME_STATUS, GAME_STATUS_ABORT

game_anima_chrend:

;Restore registers
pop dx
pop cx
pop bx
pop ax

ret


;Help
game_anima_help  db "Press any key to continue                          "
                 db "         ",0xDA,"Esc",0xBF," End the game$"

