;主引导程序

SECTION MBR vstart=0x7c00
	mov ax,cs
	mov ds,ax
	mov es,ax
	mov fs,ax
	mov ss,ax
	mov sp,0x7c00
	mov ax,0xb800
	mov gs,ax
;清屏利用0x06号功能, 上卷全部行，则可清屏
;-------------------------------------------------------------------
;INT 0x10 功能号:0x06  功能描述:上卷窗口
;-------------------------------------------------------------------
;输入:
;AH 功能号=0x06
;AL = 上卷的行号(如果为0，表示全部)
;BH = 上卷的属性
;(CL, CH) 窗口左上角的（x,y）
;(DL, DH) 窗口右下角的(x,y)
;无返回值
	mov ax, 0600h
	mov bx, 0700h
	mov cx, 0							;右上角(0,0)
	mov dx, 184f						;左下角(80,25)
										;VGA文本模式中，一行只能容纳80个字符,共25行.
										;下标从0开始，所以0x18=24,0x4f=79
	int	0x10 							;int 0x10

;下面这三行代码获取光标位置;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;.get_cursor获取当前光标位置，在光标位置处打印字符.
	mov ah, 3							;输入:3号子功能是获取光标位置，需要存入ah寄存器
	mov bh, 0							;bh寄存器存储的是待获取光标的页号

	int 0x10 							;输出: ch=光标开始行，cl=光标结束行
										;dh=光标所在行号，dl=光标所在列号

;获取光标位置结束;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;										
	

;打印字符串;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	;还是用10h中断,不过这次调用13号子功能打印字符串
	mov ax, message						;es:bp 为串首地址，es此时同cs一致，
										;开头时已经为sreg初始化

	;光标位置要用到dx寄存器中内容，cx中的光标位置可忽略
	mov cx, 5							;cx为串首长度，不包括结束符0的字符个数
	mov ax, 0x1301						;子功能号13是显示字符及属性，要存入ah寄存器,
										;al设置写字符方式al=01:显示字符串,光标跟随移动
	mov	bx, 0x02 						;bh存储要显示的页号,此处是第0页，
										;bl中是字符属性,属性黑底绿字(bl=02h)
	int 0x10 							;执行BIOS 0x10 号中断
;打印字符串结束;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	jmp $								是程序悬停在此



	message db "1 MBR"
	times 510-($-$$) db 0
	db 0x55,0xaa


																			

;	mov byte [gs:0x00] ,'2'
;	mov byte [gs:0x01] ,0xA4
;	
;	mov byte [gs:0x02] ,' '
;	mov byte [gs:0x03] ,0xA4
;	
;	mov byte [gs:0x04] ,'M'
;	mov byte [gs:0x05] ,0xA4
;
;	mov byte [gs:0x06] ,'B'
;	mov byte [gs:0x07] ,0xA4
;
;	mov byte [gs:0x08] ,'R'
;	mov byte [gs:0x09] ,0xA4
;
;	jmp $
;
;	times 510-($-$$) db 0
;	db 0x55, 0xaa

