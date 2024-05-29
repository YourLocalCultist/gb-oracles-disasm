.define INT_VBLANK	$01
.define INT_LCD		$02
.define INT_TIMER	$04
.define INT_SERIAL	$08
.define INT_JOYPAD	$10

.define BTN_A		$01
.define BTN_B		$02
.define BTN_SELECT	$04
.define BTN_START	$08
.define BTN_RIGHT	$10
.define BTN_LEFT	$20
.define BTN_UP		$40
.define BTN_DOWN	$80

.define BTN_BIT_A	0
.define BTN_BIT_B	1
.define BTN_BIT_SELECT	2
.define BTN_BIT_START	3
.define BTN_BIT_RIGHT	4
.define BTN_BIT_LEFT	5
.define BTN_BIT_UP	6
.define BTN_BIT_DOWN	7

; Bits in flag register. Need this because contents of flag register get dumped into $cddb
; for certain script-related functions.
.define CPU_CFLAG	$10
.define CPU_ZFLAG	$80

.DEFINE P1    $ff00
.DEFINE SB    $ff01
.DEFINE SC    $ff02
.DEFINE DIV   $ff04
.DEFINE TIMA  $ff05
.DEFINE TMA   $ff06
.DEFINE TAC   $ff07
.DEFINE IF    $ff0f
.DEFINE NR10  $ff10
.DEFINE NR11  $ff11
.DEFINE NR12  $ff12
.DEFINE NR13  $ff13
.DEFINE NR14  $ff14
.DEFINE NR21  $ff16
.DEFINE NR22  $ff17
.DEFINE NR23  $ff18
.DEFINE NR24  $ff19
.DEFINE NR30  $ff1a
.DEFINE NR31  $ff1b
.DEFINE NR32  $ff1c
.DEFINE NR33  $ff1d
.DEFINE NR34  $ff1e
.DEFINE NR41  $ff20
.DEFINE NR42  $ff21
.DEFINE NR43  $ff22
.DEFINE NR44  $ff23
.DEFINE NR50  $ff24
.DEFINE NR51  $ff25
.DEFINE NR52  $ff26
.DEFINE LCDC  $ff40
.DEFINE STAT  $ff41
.DEFINE SCY   $ff42
.DEFINE SCX   $ff43
.DEFINE LY    $ff44
.DEFINE LYC   $ff45
.DEFINE DMA   $ff46
.DEFINE BGP   $ff47
.DEFINE OBP0  $ff48
.DEFINE OBP1  $ff49
.DEFINE WY    $ff4a
.DEFINE WX    $ff4b
.DEFINE KEY1  $ff4d
.DEFINE VBK   $ff4f
.DEFINE HDMA1 $ff51
.DEFINE HDMA2 $ff52
.DEFINE HDMA3 $ff53
.DEFINE HDMA4 $ff54
.DEFINE HDMA5 $ff55
.DEFINE RP    $ff56
.DEFINE BGPI  $ff68
.DEFINE BGPD  $ff69
.DEFINE OBPI  $ff6a
.DEFINE OBPD  $ff6b
.DEFINE SVBK  $4000
.DEFINE IE    $ffff

.DEFINE R_P1    $00
.DEFINE R_SB    $01
.DEFINE R_SC    $02
.DEFINE R_DIV   $04
.DEFINE R_TIMA  $05
.DEFINE R_TMA   $06
.DEFINE R_TAC   $07
.DEFINE R_IF    $0f
.DEFINE R_NR10  $10
.DEFINE R_NR11  $11
.DEFINE R_NR12  $12
.DEFINE R_NR13  $13
.DEFINE R_NR14  $14
.DEFINE R_NR21  $16
.DEFINE R_NR22  $17
.DEFINE R_NR23  $18
.DEFINE R_NR24  $19
.DEFINE R_NR30  $1a
.DEFINE R_NR31  $1b
.DEFINE R_NR32  $1c
.DEFINE R_NR33  $1d
.DEFINE R_NR34  $1e
.DEFINE R_NR41  $20
.DEFINE R_NR42  $21
.DEFINE R_NR43  $22
.DEFINE R_NR44  $23
.DEFINE R_NR50  $24
.DEFINE R_NR51  $25
.DEFINE R_NR52  $26
.DEFINE R_LCDC  $40
.DEFINE R_STAT  $41
.DEFINE R_SCY   $42
.DEFINE R_SCX   $43
.DEFINE R_LY    $44
.DEFINE R_LYC   $45
.DEFINE R_DMA   $46
.DEFINE R_BGP   $47
.DEFINE R_OBP0  $48
.DEFINE R_OBP1  $49
.DEFINE R_WY    $4a
.DEFINE R_WX    $4b
.DEFINE R_KEY1  $4d
.DEFINE R_VBK   $4f
.DEFINE R_HDMA1 $51
.DEFINE R_HDMA2 $52
.DEFINE R_HDMA3 $53
.DEFINE R_HDMA4 $54
.DEFINE R_HDMA5 $55
.DEFINE R_RP    $56
.DEFINE R_BGPI  $68
.DEFINE R_BGPD  $69
.DEFINE R_OBPI  $6a
.DEFINE R_OBPD  $6b
.DEFINE R_SVBK  $70
.DEFINE R_IE    $ff
