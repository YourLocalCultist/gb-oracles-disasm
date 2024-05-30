 m_section_free Interaction_Code_Group4 NAMESPACE commonInteractions4

; ==============================================================================
; INTERACID_VASU
;
; Variables:
;   var36: Nonzero if TREASURE_RING_BOX is obtained
;   var37: Nonzero if Link has unappraised rings?
;   var38: Nonzero if Link has rings in the ring list?
; ==============================================================================
interactionCode89:
	ld a,(wTextIsActive)
	or a
	jr nz,++

	; Textboxes are always on the bottom in Vasu's shop
	ld a,$02
	ld (wTextboxPosition),a
	ld a,TEXTBOXFLAG_DONTCHECKPOSITION
	ld (wTextboxFlags),a
++
	call @updateState
	ld e,Interaction.subid
	ld a,(de)
	or a
	jp nz,objectSetPriorityRelativeToLink_withTerrainEffects
	jp interactionPushLinkAwayAndUpdateDrawPriority

@updateState:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5


; State 0: Initialization of vasu or snake
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	ld a,>TX_3000
	call interactionSetHighTextIndex
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr z,@@initVasu

@@initSnake:
	ld a,$06
	call objectSetCollideRadius
	call objectGetTileCollisions
	ld (hl),$0f
	ld a,(de)
	call interactionSetAnimation
	ld e,Interaction.pressedAButton
	jp objectAddToAButtonSensitiveObjectList

@@initVasu:
	ld a,$04
	ld e,Interaction.state
	ld (de),a
	ld hl,mainScripts.vasuScript
	jp interactionSetScript


; State 1: Snake waiting for Link to talk?
@state1:
	; Hide snake if Link is within a certain distance
	ld c,$18
	call objectCheckLinkWithinDistance
	ld e,Interaction.subid
	ld a,(de)
	jp nc,interactionSetAnimation

	call interactionAnimate
	ld h,d
	ld l,Interaction.pressedAButton
	ld a,(hl)
	or a
	ret z

	; Linked talked to snake
	xor a
	ld (hl),a
	inc a
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a

	ld e,l
	call objectRemoveFromAButtonSensitiveObjectList

	ld h,d
	ld l,Interaction.state
	ld a,$02
	ldd (hl),a
	dec l
	ld a,(hl)
	inc a
	jp interactionSetAnimation


; State 2: Just talked to snake
@state2:
	call @checkRingBoxAndRingsObtained
	call interactionAnimate
	ld e,Interaction.subid
	ld a,(de)
	and $04
	ld b,a
	ld c,$00
	ld e,Interaction.var36
	ld a,(de)
	or a
	jr z,@loadPrelinkedScript

	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jr nz,@loadLinkedScript

	ld hl,wFileIsLinkedGame
	ldi a,(hl)
	or (hl)
	jr nz,@loadLinkedScript

@loadPrelinkedScript:
	ld c,$02
@loadLinkedScript:
	ld a,b
	add c
	ld hl,@scriptTable
	rst_addAToHl
	ldi a,(hl)
	ld h,(hl)
	ld l,a

@setScriptAndGotoState4:
	call interactionSetScript
	ld e,Interaction.state
	ld a,$04
	ld (de),a
	ret

@scriptTable:
	.dw mainScripts.blueSnakeScript_linked
	.dw mainScripts.blueSnakeScript_preLinked
	.dw mainScripts.redSnakeScript_linked
	.dw mainScripts.redSnakeScript_preLinked


; State 3: Cleaning up after a script?
@state3:
	call interactionAnimate
	ld e,Interaction.animParameter
	ld a,(de)
	or a
	ret z

	xor a
	ld (wMenuDisabled),a
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ld e,Interaction.subid

	; For snakes only, reset animation, do stuff with A button?
	ld a,(de)
	or a
	ret z
	call interactionSetAnimation
	ld e,Interaction.pressedAButton
	jp objectAddToAButtonSensitiveObjectList


; State 4: Running script for Vasu or snake
@state4:
	call @checkRingBoxAndRingsObtained
	call interactionAnimate
	call interactionRunScript
	ret nc

	; Script finished
	xor a
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a

	; If this is a snake, set the animation, revert to state 3?
	ld e,Interaction.subid
	ld a,(de)
	or a
	ret z

	add $02
	call interactionSetAnimation

	ld e,Interaction.state
	ld a,$03
	ld (de),a
	ret


; State 5: Linking with blue snake?
@state5:
	call interactionAnimate
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @state5Substate0
	.dw @state5Substate1
	.dw @state5Substate2
	.dw @state5Substate3
	.dw @state5Substate4

@state5Substate0:
	call retIfTextIsActive
	call interactionIncSubstate
	xor a
	ld l,Interaction.counter1
	ld (hl),a
	ld l,Interaction.counter2
	ld (hl),$02
	ld a,$04
	jp interactionSetAnimation

@state5Substate1:
	call interactionDecCounter1
	jr nz,@label_0a_036
	inc l
	dec (hl)
	jr nz,@label_0a_036
	xor a
	ld ($ff00+R_SB),a
	ld hl,mainScripts.blueSnakeExitScript_cableNotConnected
	ld b,$80
	jr @setBlueSnakeExitScript

@label_0a_036:
	ldh a,(<hSerialInterruptBehaviour)
	or a
	jp z,serialFunc_0c73

	and $01
	add $01
	ldh (<hFFBE),a
	call interactionIncSubstate

	ld l,Interaction.counter1
	ld (hl),180
	ld bc,TX_3030
	jp showTextNonExitable

@state5Substate2:
	call serialFunc_0c8d
	ldh a,(<hSerialInterruptBehaviour)
	or a
	ret nz

	ld a,(wSRAMBank)
	push af
	ld a,:w4RingFortuneStuff
	call changeSRAMBank
	ldh a,(<hFFBD)
	ld b,a
	ld a,($cbc2)
	ld e,a
	ld a,(w4RingFortuneStuff)
	ld c,a

	pop af
	call changeSRAMBank

	ld a,b
	or e
	jr nz,@blueSnakeErrorCondition

	; Put 'c' into var3a (ring to get from fortune)
	ld e,Interaction.var3a
	ld a,c
	ld (de),a
	call interactionDecCounter1
	ret nz
	ld hl,mainScripts.blueSnakeScript_successfulFortune
	jr @setBlueSnakeExitScript

@blueSnakeErrorCondition:
	ld hl,mainScripts.blueSnakeScript_doNotRemoveCable
	ld a,e
	cp $8f
	jr z,@setBlueSnakeExitScript
	ld hl,mainScripts.blueSnakeExitScript_noValidFile
	cp $85
	jr z,@setBlueSnakeExitScript
	ld hl,mainScripts.blueSnakeExitScript_linkFailed

@setBlueSnakeExitScript:
	xor a
	ld (wDisabledObjects),a
	call @setScriptAndGotoState4
	ld a,$02
	jp interactionSetAnimation

@state5Substate3:
	call retIfTextIsActive

	; Open linking menu
	ld a,$08
	call openMenu
	jp interactionIncSubstate

@state5Substate4:
	ld a,(wSRAMBank)
	push af
	ld a,:w4RingFortuneStuff
	call changeSRAMBank

	ldh a,(<hFFBD)
	ld b,a
	ld a,($cbc2)
	ld e,a

	pop af
	call changeSRAMBank

	ld a,b
	or e
	jr nz,@blueSnakeErrorCondition

	ld hl,mainScripts.blueSnakeScript_successfulRingTransfer
	jr @setBlueSnakeExitScript


; Populates var36, var37, var38 as described in the variable list.
@checkRingBoxAndRingsObtained:
	ld a,TREASURE_RING_BOX
	call checkTreasureObtained
	ld a,$00
	rla
	ld e,Interaction.var36
	ld (de),a

	ld a,(wNumUnappraisedRingsBcd)
	inc e
	ld (de),a
	ld hl,wRingsObtained
	ld b,$08
	xor a
@@nextRing:
	or (hl)
	inc l
	dec b
	jr nz,@@nextRing
	inc e
	ld (de),a
	ret


; ==============================================================================
; INTERACID_BUBBLE
;
; Variables:
;   var30: Value to add to angle
;   var31: Number of times to add [var30] to angle before switching direction
; ==============================================================================
interactionCode91:
	ld e,Interaction.subid
	ld a,(de)
	or a
	ld e,Interaction.state
	ld a,(de)
	jp nz,@subid01

@subid00:
	or a
	jr z,@@state0

@@state1:
	call @checkDelete
	jp c,interactionDelete

	call objectApplySpeed
	ld e,Interaction.yh
	ld a,(de)
	cp $f0
	jp nc,interactionDelete

	call interactionDecCounter1
	ret nz

	ld (hl),$04
	ld l,Interaction.var31
	dec (hl)
	jr nz,++

	ld (hl),$08
	ld l,Interaction.var30
	ld a,(hl)
	cpl
	inc a
	ld (hl),a
++
	ld e,Interaction.angle
	ld a,(de)
	ld l,Interaction.var30
	add (hl)
	and $1f
	ld (de),a
	ret

@@state0:
	call @checkDelete
	jp c,interactionDelete

	call interactionInitGraphics
	call interactionIncState
	ld l,Interaction.speed
	ld (hl),SPEED_80

	ld l,Interaction.counter1
	ld a,$04
	ldi (hl),a
	ld (hl),180 ; [counter2] = 180

	ld l,Interaction.var31
	inc a
	ldd (hl),a
	call getRandomNumber
	and $01
	jr nz,+
	dec a
+
	ld (hl),a
	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	jp nz,objectSetVisible83

@randomNumberFrom0To4:
	call getRandomNumber_noPreserveVars
	and $07
	cp $05
	jr nc,@randomNumberFrom0To4

	; Set random initial angle
	sub $02
	and $1f
	ld e,Interaction.angle
	ld (de),a
	jp objectSetVisible81

@subid01:
	or a
	jr z,@@state0

@@state1:
	ld a,Object.collisionType
	call objectGetRelatedObject1Var
	bit 7,(hl)
	jp z,interactionDelete
	call objectTakePosition
	call interactionDecCounter1
	ret nz
	ld (hl),90
	ld b,INTERACID_BUBBLE
	jp objectCreateInteractionWithSubid00

@@state0:
	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),30
	ret

;;
; @param[out]	cflag	c if bubble should be deleted (no longer in water)
@checkDelete:
	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	jp nz,@@sidescrolling

@@topDown:
	call interactionDecCounter2
	ld a,(hl)
	cp 60
	ret nc
	or a
	scf
	ret z

	; In last 60 frames, flicker
	ld l,Interaction.visible
	ld a,(hl)
	xor $80
	ld (hl),a
	ret

@@sidescrolling:
	; Check if it's still in water
	call objectGetTileAtPosition
	ld hl,hazardCollisionTable
	call lookupCollisionTable
	ccf
	ret

.ends
