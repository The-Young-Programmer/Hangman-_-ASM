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
;; Contains the function for playing sounds.
;;
;; Index:
;;     _play_sound(SOUND) -- Plays a sound.
;;



;===================================================== _play_sound(SOUND) ====
;; Plays a sound.

;; Usage:
;; mov SOUND, offset <mysound>
;; call _play_sound

;; Function arg:
SOUND dw 0 ;The adress of the sound to play.


_play_sound:

;Backup registers
push ax
push bx
push cx
push dx

;Turn speaker on
mov  dx, 0x61
in   al, dx
or   al, 0x03
out  dx, al

;Sound loop
mov bx, SOUND
mov dx, 0

sound_loop:
    ;Play sound
    mov ax, [bx]
    or  ax, 3
    out 0x42, al ;output low
    xchg ah, al
    out 0x42, al ;output high

    ;Point to the next field (duration)
    inc bx
    inc bx

    ;Sleep during the given duration
    push ax
    mov cx, [bx]
    mov ah, 0x86
    int 0x15
    pop ax

    ;Point to the next field (sound)
    inc bx
    inc bx

    ;Check if it is finished or not
    cmp [bx], 0
    jne sound_loop

;Turn speaker off
mov  dx, 0x61
in   al, dx
and  al, 0xfc
out  dx, al

;Restore registers
pop dx
pop cx
pop bx
pop ax

ret

