; Goof Troop - Practice Cart
; description: global variables definition 
; author: FURiOUS

; game addresses
!rng 			= $1A58
!level_id	 	= $B7
!load_status 	= $A2
!gamemode	 	= $A0
!paused		 	= $AB

!timer_enemies	= $023E
!igt_frm		= $F0
!igt_sec		= $F1
!igt_min		= $F2
!igt_hr			= $F3

!p1_pad			= $44
!p1_pad_frame	= $48
!p1_status 		= $0100 ; 0 = hide, 1 = show, 3 = iframes
!p1_item 		= $0142
!p1_hp	 		= $011D
!p1_lives 		= $0157
!p1_Xpos		= $0111
!p1_subXpos		= $0110
!p1_Ypos		= $0114
!p1_subYpos		= $0113
!p1_update		= $013F

!p2_pad			= $4A
!p2_pad_frame	= $4E
!p2_status 		= $0180
!p2_item 		= $01C2
!p2_hp	 		= $019D
!p2_lives 		= $01D7
!p2_Xpos		= $0191
!p2_subXpos		= $0190
!p2_Ypos		= $0194
!p2_subYpos		= $0193
!p2_update		= $01BF

; game text palletes
!white			= #$20
!red			= #$24
!blue			= #$28
!yellow			= #$30
!green			= #$38


; patch addresses
!last_input		= $7FFFF0
!last_rng		= $7FFFF2
!last_room		= $7FFFF4
!igt_last_min	= $7FFFF6
!igt_last_sec	= $7FFFF7
!igt_last_frm	= $7FFFF8
!igt_room_min	= $7FFFE6
!igt_room_sec	= $7FFFE7
!igt_room_frm	= $7FFFE8
!last_color		= $7FFFFF