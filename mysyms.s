	.section .ktext,"x",@nobits
	.global g_T_foo
        .set g_T_foo, 0xffffffff81001000	 
	.section .ktext,"x",@nobits	
	.global myfoo
myfoo:	.byte 0x00

