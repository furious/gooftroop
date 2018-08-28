incsrc define.asm

lorom

org $FFD5
    db $02
	
org $FFD8
	db $08
	
org $8024
	NOP #3

org $3D4AA
	db "ROMHACK 1.1 ",$40,"FURIOUS"


; HIJACKS
;org $BE59
;	JMP routine
org $8302
	JSR nmi
org $AA90
	JSR vblank

org $F380
incsrc include.asm
routine:
	SEP #$20
	PHP
	REP #$30
	LDA $4218
	CMP !last_input
	BNE	+
	PLP
	JSR $BDFF
	JMP return
+	PLP
	LDA $4219
	BIT #$10
	BNE .start_axlr
	JSR $BDFF
	JMP return

; test	84218421
; 		axlr....
.start_axlr
	STZ !p1_pad_frame
	STZ !p2_pad_frame
	LDA $4218
	BIT #$10 ;R
	BNE .fix_audio
	BIT #$40 ;X
	BNE .change_rng
	BIT #$80 ;A
	BNE .disable_darkroom
	BRA .start_byetudlr

; ACTIONS AXLR
.fix_audio ; (superufo)
	LDA $2142
	STA $7FFF09
	JMP return

.change_rng
	JSL $808859
	JSR $9553
	;LDA !rng
	;STA !last_rng
	JMP return

.disable_darkroom
	JSR $A87F
	JMP return


; test	84218421
; 		byetudlr
.start_byetudlr
	LDA $4219
	BIT #$08 ;Up
	BNE .next_room
	BIT #$20 ; Select
	BNE .reset_room

	;BIT #$80 ;B
	;BNE .change_item
	BIT #$80 ;B
	BNE .cicle_hearts
	BIT #$40 ;Y
	BNE .cicle_lives
	JSR $BDFF 
	JMP return

; ACTIONS BYETUDLR
.next_room ; next room
	LDA #$06
	STA !load_status
	JMP return

.reset_room ; reset room
	PHP
	REP #$30
	LDA !last_rng
	STA !rng
	PLP
	;LDA !last_room
	;STA !level_id
	;LDA #$06
	;STA !load_status
	;JSL $80E56A
    ;STZ $2100
    STZ !load_status
	JMP return
	;JMP $AA90

.change_item ; change item
	;LDA !p1_item
	;CMP #$FF
	;BEQ +
	INC !p1_item
	INC !p2_item
	;BRA ++
;+	STZ $0142
;++	
	JSR status_update
	JMP return

.cicle_lives ; change item
	LDA !p1_lives
	CMP #10
	BEQ +
	INC !p1_lives
	INC !p2_lives
	BRA ++
+	LDA #1
	STA !p1_lives
	STA !p2_lives
++	JSR status_update
	JMP return

.cicle_hearts ; change hearts
	LDA !p1_hp
	CMP #$06
	BEQ +
	INC !p1_hp
	INC !p2_hp
	BRA ++
+	STZ !p1_hp
	STZ !p2_hp
++	STZ !p1_update
	STZ !p2_update
	JMP return

return:	
	PHP
	REP #$30
	LDA $4218 ; last input
	STA !last_input

	LDA !load_status
	CMP #$0008
	BEQ .room_loaded
	CMP #$0006
	BEQ .room_loading
	BRA +
.room_loaded
	LDA !rng ; last rng
	STA !last_rng
;.room_loading
	LDA !level_id ; last room
	STA !last_room
	BRA +
.room_loading
	LDA !igt_frm
	STA !igt_last_frm
	LDA !igt_sec
	STA !igt_last_sec
	LDA !igt_min
	STA !igt_last_min
+
	LDA !gamemode
	CMP #$0206
	BEQ .map_loaded
	BRA +
.map_loaded
	STZ !igt_frm
	STZ !igt_sec
	STZ !igt_min

+	PLP
	RTS

; other hooks
vblank:
	;JSR $BDFF ; hijacked routine
	JSR routine
	RTS
nmi:
	JSR $838D ; hijacked routine
	;RTS
	;%save_registers()
	REP #$20
	LDA !gamemode
	CMP #$0008
	BEQ .playing
	CMP #$0206
	BEQ .map_loaded
	JMP end
.map_loaded
	SEP #$20
	%status_color(!red)
	%status_pos(3, 26)
	%print_text(text_timereset)
	JMP end
.playing
	SEP #$20
	;PRINT P1 INFO
	;%status_color(!blue)
	;%status_pos(1, 4)
	;%print_text(text_xpos)
	;%print_hex(!p1_Xpos, 1)
	;%status_pos(1, 5)
	;%print_text(text_ypos)
	;%print_hex(!p1_Ypos, 1)

	;PRINT P2 INFO

	;PRINT RNG
	%status_color(!blue)
	%status_pos(1, 26)
	%print_text(text_rng)
	%status_color(!white)
	%print_hex(!rng, 2)

	;PRINT IGT
	%status_color(!red)
	%status_pos(18, 26)
	%print_text(text_igt)
	%status_color(!white)
	%print_hex(!igt_min, 1)
	%print_char(":")
	%print_hex(!igt_sec, 1)
	%print_char(".")
	%print_dec_sub(!igt_frm, 60)

	;%status_pos(23, 25)
	;PHP
	;SED
	;LDA !igt_min
	;SBC !igt_last_min
	;STA !igt_room_min
	;%print_hex(!igt_room_min, 1)
	;%print_char(":")
	;LDA !igt_sec
	;SBC !igt_last_sec
	;STA !igt_room_sec
	;%print_hex(!igt_room_sec, 1)
	;%print_char(".")
	;LDA !igt_frm
	;SBC !igt_last_frm
	;STA !igt_room_frm
	;%print_dec_sub(!igt_room_frm, 60)
	;PLP
	;%load_registers()
end:
	SEP #$20
	RTS

print "Total space used: ",pc