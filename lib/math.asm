MATH_hexdec_convert:
  ; Store input number in the MATH_HEXDEC_VAL address before running
  lda #0
  sta MATH_HEXDEC_OUT
divide:
  ; Initialize the remainder to be zero
  lda #0
  sta MATH_HEXDEC_MOD
  sta MATH_HEXDEC_MOD + 1
  ldx #16
  clc
div_loop:
  ; Rotate quotient and remainder
  rol MATH_HEXDEC_VAL
  rol MATH_HEXDEC_VAL + 1
  rol MATH_HEXDEC_MOD
  rol MATH_HEXDEC_MOD + 1
  ; a,y = dividend - divisor
  sec
  lda MATH_HEXDEC_MOD
  sbc #10
  tay ; save low byte in y
  lda MATH_HEXDEC_MOD+1
  bcc ignore_result ; branching if dividend < divisor
  sty MATH_HEXDEC_MOD
  sta MATH_HEXDEC_MOD+1
ignore_result:
  dex 
  bne div_loop
  rol MATH_HEXDEC_VAL ; shift in the last bit of the quotient
  rol MATH_HEXDEC_VAL + 1
  lda MATH_HEXDEC_MOD
  clc
  adc #'0'
  jsr MATH_append_output
  ; if value != 0, then continue dividing
  lda MATH_HEXDEC_VAL
  ora MATH_HEXDEC_VAL + 1
  bne divide ; branch if value not zero
  ldx #0
  rts

; Add the caracter in the A register to the beginning of the null-terminated string `message`
MATH_append_output:
  pha ; Push first character onto the stack
  ldy #0
append_loop:
  lda MATH_HEXDEC_OUT,y ; Get char from the string and push it into x
  tax
  pla 
  sta MATH_HEXDEC_OUT,y ; Pull char off stack and add it onto the string
  iny
  txa
  pha              ; Push char from string onto stack
  bne append_loop
  pla
  sta MATH_HEXDEC_OUT,y ; Pull the null off the stack and add to the end of the string
  rts

MATH_fibonacci:
  lda MATH_INPUT_2
  sta MATH_INPUT_1
  lda MATH_INPUT_2 + 1
  sta MATH_INPUT_1 + 1
  
  lda MATH_OUTPUT
  sta MATH_INPUT_2
  lda MATH_OUTPUT + 1
  sta MATH_INPUT_2 + 1

  jsr MATH_add

  rts

MATH_add:
  clc
  
  lda MATH_INPUT_1
  adc MATH_INPUT_2
  sta MATH_OUTPUT

  lda MATH_INPUT_1 + 1
  adc MATH_INPUT_2 + 1
  sta MATH_OUTPUT + 1

  lda #0
  adc #0
  sta MATH_OUTPUT + 2

  rts
MATH_sub:
  sec
  lda MATH_INPUT_1
  sbc MATH_INPUT_2
  sta MATH_OUTPUT

  lda MATH_INPUT_1 + 1
  sbc MATH_INPUT_2 + 1
  sta MATH_OUTPUT + 1

  lda #0
  sbc #0
  sta MATH_OUTPUT + 2
  clc
  rts 