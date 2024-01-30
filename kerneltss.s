	.global current_task
	.section .tbss,"awT",@nobits
	. = 0x000000000001fbc0
current_task:	
	.quad 0x0
