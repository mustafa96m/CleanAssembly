JUMPS
;;;;;;;;;; JUMP MODE boosted ;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     Helper Functions      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SET_BG_COLOR MACRO X
    MOV AX,0600h 
    MOV BH,X   
    MOV CX,0000h  
    MOV DX,184Fh  
    INT 10h
ENDM
SET_CUR MACRO X,Y
    mov ah, 2
    mov bh, 0
    mov dh, Y
    mov dl, X
    int 10h
ENDM
PRINT MACRO MSG
    push ax ; push the value of ax into the stack
    push dx ; push the value of dx into the stack
    lea dx, MSG
    mov ah, 09h
    int 21h
    pop dx ; remove it from the stack
    pop ax ; remove it from the stack
ENDM 

CHOICE_READ_MODE MACRO
    MOV AH,1
    INT 21H
    MOV CHOICE_INPUT_NUMBER,AL
ENDM

EXIT MACRO
    MOV AX,4C00h
    INT 21h
ENDM

;;;;; THEME MACROS ;;;;;

DRAW_BOARDER MACRO
    mov cx, 24 ; loop for Screen height  - 1
    draw_left_v_line:
        SET_CUR 0 cl   ;set cursor to X=0,Y= Cl 
        PRINT VERTICAL_BOARDER_LINE_CHAR ;print |
        SET_CUR 79 cl   ;set cursor to X=79 (The width of screen - 1 (last pixel)), Y= Cl 
        PRINT VERTICAL_BOARDER_LINE_CHAR  ; print |
    loop draw_left_v_line
    
    SET_CUR 0 0 ; reset to first pixel
    mov cx, 80 ; loop for Screen width
    draw_top_h_line:
        PRINT HORIZONTAL_BOARDER_LINE_CHAR 
    loop draw_top_h_line


    SET_CUR 0 23 ; reset to last pixel (25-3) after a little bit of tunning
    mov cx, 80 ; loop for screen width
    draw_bottom_h_line:
        PRINT HORIZONTAL_BOARDER_LINE_CHAR 
    loop draw_bottom_h_line
ENDM


DRAW_MENU_AT MACRO
    SET_CUR 20 12;
    PRINT NEWLINE_CHAR
    
    INC DH
    SET_CUR 20 DH;
    PRINT MENU_OPTION_1
    
    INC DH
    SET_CUR 20 DH;
    PRINT MENU_OPTION_2
    
    INC DH
    SET_CUR 20 DH;
    PRINT MENU_OPTION_3
    
    INC DH
    SET_CUR 20 DH;
    PRINT MENU_OPTION_4
    
    INC DH
    SET_CUR 20 DH;
    PRINT MENU_OPTION_5
    
    INC DH
    SET_CUR 20 DH;    
    PRINT MENU_CHOICE_PROMPT_MESSAGE
    
ENDM

;;;;;;;;;;;;User Input Functions;;;;;;;;;;;;;;

ENGAGE_USER MACRO
    CHOICE_READ_MODE 
    CMP CHOICE_INPUT_NUMBER,'1'; Going to subtract value of 1 from AH thus if the result is 0 then we can assure eqauvalancy 
    JNE choice_2
    
    SET_BG_COLOR 11
    
    SET_CUR 0 0
    
    DRAW_TOP_TRIANGLE_SHAPE
    DRAW_BOTTOM_TRIANGLE_SHAPE
    
    SET_CUR 25 20
    PRINT INTERACTION_MESSAGE
    
    CHOICE_READ_MODE
    JMP start
    
    choice_2:
    CMP CHOICE_INPUT_NUMBER,'2'
    JNE choice_3
    SET_BG_COLOR 22
    
    SET_CUR 0 0
    DRAW_PATTERN
    
    SET_CUR 25 20
    PRINT INTERACTION_MESSAGE
    
    CHOICE_READ_MODE
    JMP start
    
    choice_3:
    CMP CHOICE_INPUT_NUMBER,'3'
    JNE choice_4
    SET_BG_COLOR 71
    
    SET_CUR 30 5
    DRAW_BOX_SHAPE 
    
    SET_CUR 25 20
    PRINT INTERACTION_MESSAGE
    
    CHOICE_READ_MODE
    JMP start
    
    choice_4:
    CMP CHOICE_INPUT_NUMBER,'4'
    JNE choice_5
    SET_BG_COLOR 04
    
    SET_CUR 0 0
    DRAW_NESTED_LOOPS
    
    SET_CUR 25 20
    PRINT INTERACTION_MESSAGE
    
    CHOICE_READ_MODE
    JMP start
    
    
    choice_5:
    CMP CHOICE_INPUT_NUMBER,'5'
    JNE invalid
    EXIT
    
    invalid:
    SET_BG_COLOR 0Ch
    PRINT INVALID_INPUT_MESSAGE
    CHOICE_READ_MODE
    JMP start    
ENDM


;;;;;;;;;;;Shapes Functions;;;;;;;;;;;;;

DRAW_TOP_TRIANGLE_SHAPE MACRO 
    PRINT NEWLINE_CHAR
    
    MOV SHAPE_COUNTER,1
    MOV SPACE_COUNTER,38
    
    mov cx,9
    outer_loop:
        push cx
        mov cx,SPACE_COUNTER
        spaces_loop:
            PRINT SPACE_CHAR
        loop spaces_loop
        DEC SPACE_COUNTER
        POP CX
        PUSH CX
        MOV cx,SHAPE_COUNTER
        shapes_loop:
            CMP SHAPE_COUNTER,18
            JE done
            PRINT STAR_SHAPE
        loop shapes_loop
        INC SHAPE_COUNTER
        INC SHAPE_COUNTER
        done:
        POP CX
        PRINT NEWLINE_CHAR
    loop outer_loop
    
    
ENDM

DRAW_BOTTOM_TRIANGLE_SHAPE MACRO
    MOV SPACE_COUNTER,31
    MOV SHAPE_COUNTER,15
    
    mov cx,8 ; top triangle - 1 (base)
    outer_loop1:
        push cx
        mov cx,SPACE_COUNTER
        spaces_loop1:
        CMP SPACE_COUNTER,39
            JE done1
            PRINT SPACE_CHAR
            loop spaces_loop1
            INC SPACE_COUNTER
           done1:
            pop CX
        push cx
        mov cx,SHAPE_COUNTER
        shapes_loop1:
            PRINT STAR_SHAPE
        loop shapes_loop1
        DEC SHAPE_COUNTER
        DEC SHAPE_COUNTER
        POP CX
            PRINT NEWLINE_CHAR
    loop outer_loop1
ENDM

;;;;;;; 3 Draw Box

DRAW_BOX_SHAPE MACRO 
    mov cx, 10 ; Height           
    outer:                  
        push cx              
        mov cx,10 ; Width            
        inner:                  
            ;do stuff
            PRINT STAR_SHAPE
            PRINT SPACE_CHAR
        loop inner
        pop cx               
        INC DH
        SET_CUR DL DH
    loop outer
ENDM

DRAW_NESTED_LOOPS MACRO
    ;;; First Shape
    MOV SPACE_COUNTER,38 
    
    MOV cx,5
    MOV bx,5
    l1:
        push cx
        mov cx,SPACE_COUNTER
        t1ls:
            PRINT SPACE_CHAR
        loop t1ls
        
        POP CX
        
        PUSH CX
        MOV CX, bx
        l2:
            PRINT STAR_SHAPE
            LOOP l2
            DEC BX
        POP CX
        PRINT NEWLINE_CHAR
    LOOP l1
    
    PRINT NEWLINE_CHAR
    
    MOV SPACE_COUNTER,38    
    
    ;;; Second Shape
    MOV cx,5
    MOV bx,1
    t2l1:
        push cx
        mov cx,SPACE_COUNTER
        t2ls:
            PRINT SPACE_CHAR
        loop t2ls
        POP CX
        PUSH CX
        MOV CX, bx
        t2l2:
            CMP BX,6
            JE t2breakout
            PRINT STAR_SHAPE
            LOOP t2l2
            INC BX
        POP CX
        PRINT NEWLINE_CHAR
    LOOP t2l1
    t2breakout:
    PRINT NEWLINE_CHAR
    
    
    
    
    ;;; Third Shape
    MOV SPACE_COUNTER,38
    mov cx,5
    
     t3l1:
        push cx
        mov cx,SPACE_COUNTER
        t3l2:
            PRINT SPACE_CHAR
        loop t3l2
        DEC SPACE_COUNTER
        POP CX
        PUSH CX
        MOV cx,SHAPE_COUNTER
        t3l3:
            CMP SHAPE_COUNTER,18
            JE t3done
            PRINT STAR_SHAPE
        loop t3l3
        INC SHAPE_COUNTER
        ;INC SHAPE_COUNTER
        t3done:
        POP CX
        PRINT NEWLINE_CHAR
    loop t3l1

ENDM

DRAW_PATTERN MACRO 
    ;; Draw top Tail
    
 
    MOV CX,6
    MOV bx,1
    t4l1:
    PUSH CX
        MOV CX, bx
        t4l2:
            CMP BX,6
            JE t4breakout
            PRINT DASH_SHAPE
            LOOP t4l2
            INC BX
        POP CX
        PRINT STAR_SHAPE
        PRINT NEWLINE_CHAR
    loop t4l1
    t4breakout:
    
    ;; Draw Bottom Tail
    

    MOV CX,7
    MOV bx,6
    t5l1:
    PUSH CX
        MOV CX, bx
        t5l2:
            CMP BX,0
            JE t5breakout
            PRINT DASH_SHAPE
            LOOP t5l2
            DEC BX
        POP CX
        PRINT STAR_SHAPE
        PRINT NEWLINE_CHAR
    loop t5l1
    t5breakout:    
    
    
    ;; Draw Body
    SET_CUR 7 2
    
    mov cx, 7 ; Height           
    t6l1:                  
        push cx              
        mov cx,9 ; Width            
        t6l2:                  
            ;do stuff
            PRINT STAR_SHAPE
            PRINT DASH_SHAPE
        loop t6l2
        pop cx               
        INC DH
        SET_CUR DL DH
    loop t6l1
    
    
    
    ;; Draw Head
    SET_CUR 26 3
    MOV CX,7
    MOV BX,1
    t7l1:
    PUSH CX
        MOV CX, bx
        t7l2:
            CMP BX,6
            JE t7breakout
            PRINT DASH_SHAPE
            LOOP t7l2
            INC BX
        POP CX
        PRINT STAR_SHAPE
        INC DH
        SET_CUR DL,DH
        loop t7l1
        t7breakout:
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.model small
.stack 1000h
.data 
    ;;;;; Helper Strings ;;;;;
    NEWLINE_CHAR DB 10,"$"
    SPACE_CHAR DB " $"
    ;;;;;  Boarder String ;;;;;
    VERTICAL_BOARDER_LINE_CHAR db "|$"
    HORIZONTAL_BOARDER_LINE_CHAR db "-$"
    
    ;;;;; Main Menu Strings ;;;;
    WLCM_MSG db "Shape Generator v1!$"
    WLCM_DESC db "Howdy Human, Kindly pick your choice: [1-5]$",10,13
    
    ;;;;; Menu Strings ;;;;
    MENU_OPTION_1 db "[1] Draw Number Pattern (Diamond Shape) $"
    MENU_OPTION_2 db "[2] Draw Design Pattern (Fish Shape) $"
    MENU_OPTION_3 db "[3] Draw Box Type Pattern (Square) $"    
    MENU_OPTION_4 db "[4] Draw Nested Loop Patterns (Triangles) $"  
    MENU_OPTION_5 db "[5] Exit $",10
    MENU_CHOICE_PROMPT_MESSAGE DB "Your Choice: $"   
    INVALID_INPUT_MESSAGE DB "Invalid Input$"
    INTERACTION_MESSAGE DB "Press any key to go back... $"
    
    
    ;;;;; Global Variables ;;;;;;
    CHOICE_INPUT_NUMBER DB 0
    
        
    ;;;;; Answers ;;;;;
    CH1_MSG db "Choice One!$"
    
    
    ;;;; Shape 1 ;;;;;
    STAR_SHAPE db "*$"
    DASH_SHAPE db "-$"
    SPACE_COUNTER DW 8 ; Decrementing
    SHAPE_COUNTER DW 1   ; Incrementing
    
.code
main PROC
    
start:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Setting up welcome Screen ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       VIDEO MODE IS       ;
;    UNDER 80x25 COLORED    ;
;---------------------------;

MOV AX,@DATA
MOV DS,AX

;;;; Reset Values ;;;;
MOV SHAPE_COUNTER,1
MOV SPACE_COUNTER,38

SET_BG_COLOR 10 ; Matrix Theme
DRAW_BOARDER

SET_CUR 30 10 ; Move Cursor to X=30,Y=10
PRINT WLCM_MSG ;

SET_CUR 19 11 ; X=30,Y=10
PRINT WLCM_DESC

DRAW_MENU_AT
   
ENGAGE_USER

jmp start

SET_CUR 100 100 ; Set The cursor far away to remove compiler message away

main ENDP 
END main
proc draw_shape FAR

draw_shape ENDP
END draw_shape