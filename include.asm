incsrc define.asm
; data
text_rng:		db "RNG: ",0
text_igt:		db "IGT: ",0
text_xpos:		db "X: ",0
text_ypos:		db "Y: ",0
text_timereset: db "TIMER RESETS IN EACH STAGE!",0

; functions
status_update:
	STZ !p1_update
	STZ !p2_update
	RTS

status_setXYpos:
	REP #$30
	TYA
	ASL #5
	PHX
	ORA $01,s
	PLX
	ADC #$4C00
	STA $2116
	SEP #$30
	RTS

status_write:
	PHA
	LSR #4
	JSR num_to_ascii
	STA $2118
	LDA !last_color
	STA $2119
	PLA
	AND #$0F
	JSR num_to_ascii
status_writeraw:
	STA $2118
	LDA !last_color
	STA $2119
	RTS

num_to_ascii:
    CLC
    ADC #$30
    CMP #$3A
    BCC +
    ADC.b #$41-$3A-1
+	RTS

hex2dec:
	PHP
	PHX
	SED
	TAX
	LDA #00

-	DEX
	CPX #00
	BMI +
	CLC
	ADC #01
	BRA -

+	PLX
	PLP
	RTS

; macros
macro print_text(text)
  	LDX #$00
-	LDA.L <text>,x
	BEQ +
	JSR status_writeraw
	INX
	BRA -
+
endmacro

macro print_char(chr)
	db $A9 
	db "<chr>"
	JSR status_writeraw
endmacro

macro print_hex(addr, size)
  	LDX #0
-	LDA.L <addr>,x
	JSR status_write
	INX
	CPX #<size>
	BNE -
endmacro

macro print_dec(addr)
	LDA <addr>
	JSR hex2dec
	JSR status_write
endmacro

macro print_dec_sub(addr, num)
	LDA #<num>
	SBC <addr>
	JSR hex2dec
	JSR status_write
endmacro

macro status_pos(x, y)
	LDX #<x>
	LDY #<y>
	JSR status_setXYpos
endmacro

macro status_color(color)
	LDA <color>
	STA !last_color
endmacro

macro save_registers()
    php
    pha
    phx
    phy
endmacro

macro load_registers()
    ply
    plx
    pla
    plp
endmacro