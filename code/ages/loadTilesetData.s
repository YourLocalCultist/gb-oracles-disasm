;;
; Called from loadTilesetData in bank 0. Function differs substantially in Ages and Seasons.
loadTilesetData_body:
	call getAdjustedRoomGroup

	ld hl,roomTilesetsGroupTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(wActiveRoom)
	rst_addAToHl
	ld a,(hl)
	ldh (<hFF8D),a
	call @func_6d94
	call func_6de7
	ret nc
	ldh a,(<hFF8D)
@func_6d94:
	and $80
	ldh (<hFF8B),a
	ldh a,(<hFF8D)

	and $7f
	call multiplyABy8
	ld hl,tilesetData
	add hl,bc

	ldi a,(hl)
	ld e,a
	ldi a,(hl)
	ld (wTilesetFlags),a
	bit TILESETFLAG_BIT_DUNGEON,a
	jr z,+

	ld a,e
	and $0f
	ld (wDungeonIndex),a
	jr ++
+
	ld a,$ff
	ld (wDungeonIndex),a
++
	ld a,e
	swap a
	and $07
	ld (wActiveCollisions),a

	ld b,$06
	ld de,wTilesetUniqueGfx
@copyloop:
	ldi a,(hl)
	ld (de),a
	inc e
	dec b
	jr nz,@copyloop

	ld e,wTilesetUniqueGfx&$ff
	ld a,(de)
	ld b,a
	ldh a,(<hFF8B)
	or b
	ld (de),a
	ret

;;
; Returns the group to load the room layout from, accounting for bit 0 of the room flag
; which tells it to use the underwater group
;
; @param[out]	a,b	The corrected group number
getAdjustedRoomGroup:
	ld a,(wActiveGroup)
	ld b,a
	cp $02
	ret nc
	call getThisRoomFlags
	rrca
	jr nc,+
	set 1,b
+
	ld a,b
	ret

;;
; Modifies hFF8D to indicate changes to a room (ie. jabu flooding)?
func_6de7:
	call @func_04_6e0d
	ret c

	call @checkJabuFlooded
	ret c

	ld a,(wActiveGroup)
	or a
	jr nz,@xor

	ld a,(wLoadingRoomPack)
	cp $7f
	jr nz,@xor

	ld a,(wAnimalCompanion)
	sub SPECIALOBJECTID_RICKY
	jr z,@xor

	ld b,a
	ldh a,(<hFF8D)
	add b
	ldh (<hFF8D),a
	scf
	ret
@xor:
	xor a
	ret

;;
@func_04_6e0d:
	ld a,(wActiveGroup)
	or a
	ret nz

	ld a,(wActiveRoom)
	cp $38
	jr nz,+

	ld a,($c848)
	and $01
	ret z

	ld hl,hFF8D
	inc (hl)
	inc (hl)
	scf
	ret
+
	xor a
	ret

;;
; @param[out]	cflag	Set if the current room is flooded in jabu-jabu?
@checkJabuFlooded:
	ld a,(wDungeonIndex)
	cp $07
	jr nz,++

	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	jr nz,++

	ld a,$11
	ld (wDungeonFirstLayout),a
	callab bank1.findActiveRoomInDungeonLayoutWithPointlessBankSwitch
	ld a,(wJabuWaterLevel)
	and $07
	ld hl,@data
	rst_addAToHl
	ld a,(wDungeonFloor)
	ld bc,bitTable
	add c
	ld c,a
	ld a,(bc)
	and (hl)
	ret z

	ldh a,(<hFF8D)
	inc a
	ldh (<hFF8D),a
	scf
	ret
++
	xor a
	ret

@data:
	.db $00 $01 $03


; Remainder of functions maybe don't belong in this file, idk...


;;
; Ages only: For tiles 0x40-0x7f, in the past, replace blue palettes (6) with red palettes (0). This
; is done so that tilesets can reuse attribute data for both the past and present tilesets.
;
; This is annoying so it's disabled in the hack-base branch, which separates all tileset data
; anyway.
setPastCliffPalettesToRed:
	ld a,(wActiveCollisions)
	or a
	jr nz,@done

	ld a,(wTilesetFlags)
	and TILESETFLAG_PAST
	jr z,@done

	ld a,(wActiveRoom)
	cp <ROOM_AGES_138
	ret z

	; Replace all attributes that have palette "6" with palette "0"
	ld a,:w3TileMappingData
	call changeSRAMBank
	ld hl,w3TileMappingData + $204
	ld d,$06
---
	ld b,$04
--
	ld a,(hl)
	and $07
	cp d
	jr nz,+

	ld a,(hl)
	and $f8
	ld (hl),a
+
	inc hl
	dec b
	jr nz,--

	ld a,$04
	rst_addAToHl
	ld a,h
	cp $d4
	jr c,---
@done:
	xor a
	call changeSRAMBank
	ret


;;
func_04_6e9b:
	ld a,$02
	call changeSRAMBank
	ld hl,wRoomLayout
	ld de,$d000
	ld b,$c0
	call copyMemory
	ld hl,wRoomCollisions
	ld de,$d100
	ld b,$c0
	call copyMemory
	ld hl,$df00
	ld de,$d200
	ld b,$c0
--
	ld a,$03
	call changeSRAMBank
	ldi a,(hl)
	ld c,a
	ld a,$02
	call changeSRAMBank
	ld a,c
	ld (de),a
	inc de
	dec b
	jr nz,--

	xor a
	call changeSRAMBank
	ret

;;
func_04_6ed1:
	ld a,$02
	call changeSRAMBank
	ld hl,wRoomLayout
	ld de,$d000
	ld b,$c0
	call copyMemoryReverse
	ld hl,wRoomCollisions
	ld de,$d100
	ld b,$c0
	call copyMemoryReverse
	ld hl,$df00
	ld de,$d200
	ld b,$c0
--
	ld a,$02
	call changeSRAMBank
	ld a,(de)
	inc de
	ld c,a
	ld a,$03
	call changeSRAMBank
	ld a,c
	ldi (hl),a
	dec b
	jr nz,--

	xor a
	call changeSRAMBank
	ret

;;
func_04_6f07:
	ld hl,$d800
	ld de,$dc00
	ld bc,$0200
	call @locFunc
	ld hl,$dc00
	ld de,$de00
	ld bc,$0200
@locFunc:
	ld a,$03
	call changeSRAMBank
	ldi a,(hl)
	ldh (<hFF8B),a
	ld a,$06
	call changeSRAMBank
	ldh a,(<hFF8B)
	ld (de),a
	inc de
	dec bc
	ld a,b
	or c
	jr nz,@locFunc
	ret

;;
func_04_6f31:
	ld hl,$dc00
	ld de,$d800
	ld bc,$0200
	call @locFunc
	ld hl,$de00
	ld de,$dc00
	ld bc,$0200
@locFunc:
	ld a,$06
	call changeSRAMBank
	ldi a,(hl)
	ldh (<hFF8B),a
	ld a,$03
	call changeSRAMBank
	ldh a,(<hFF8B)
	ld (de),a
	inc de
	dec bc
	ld a,b
	or c
	jr nz,@locFunc
	ret
