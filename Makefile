SHELL=/bin/bash

EXTRACTVMLINUXURL=https://raw.githubusercontent.com/torvalds/linux/master/scripts/extract-vmlinux
KERNELRELEASE=$(shell uname -r)
VMLINUZ=/boot/vmlinuz-${KERNELRELEASE}
SYSMAP=/boot/System.map-${KERNELRELEASE}
KALLSYMS=/proc/kallsyms
KTEXTADDR=$(shell sudo grep " _text$$" ${KALLSYMS} | while read a t n; do echo $$a; done)
KSYMS=printk ksys_write


ELFSYMTOOLREPO=git@github.com:jappavoo/elfsymtool.git
.PHONY: all clean dist-clean

externals=ext/extract-vmlinux ext/elfsymtool/elfsymtool
targets=vmlinux symtypes testmysyms testlibkernel

#KLDFLAGS=-Wl,--section-start=.ktext=0xffffffff81000000 \
#	-Wl,--section-start=.rodata=0xffffffff82000000 
#KLDFLAGS=-Wl,-T mysyms.ld
#KLDFLAGS=-Wl,--section-start=.ktext=0x0 \
#	-Wl,--section-start=.rodata=0x0

#all: test.o test.s mysyms.o libkernel.so callfoo libkernel.so

all: ${externals} ${targets}
	@echo "KTEXTADDR=${KTEXTADDR}"

testlibkernel: testlibkernel.c libkernel.so
	gcc -o $@ $< -L./ -lkernel

kernel.s:
	-rm -rf $(wildcard$@)
	$(shell ./mkksrc $@ ${KSYMS})

kernel.o: kernel.s
	gcc -c $< -o $@

libkernel.so: kernel.o
	gcc -nostdlib -nodefaultlibs -shared ${KLDFLAGS} -o $@ $^

mysyms.o: mysyms.s
	gcc -c $< -o $@

libmysyms.so: mysyms.o
	gcc -nostdlib -nodefaultlibs -shared ${KLDFLAGS} -o $@ $^

testmysyms: testmysyms.c libmysyms.so
	gcc -o $@ $< -L ./ -lmysyms

symtypes.s: symtypes.c
	gcc -S $< -o $@

symtypes.o: symtypes.s
	gcc -c $< -o $@

symtypes: symtypes.o
	gcc $< -o $@

ext/elfsymtool/Makefile:
	git clone git@github.com:jappavoo/elfsymtool.git ext/elfsymtool

ext/elfsymtool/elfsymtool: ext/elfsymtool/Makefile
	make -C ext/elfsymtool

vmlinux: ext/extract-vmlinux ${VMLINUZ}
	./ext/extract-vmlinux ${VMLINUZ} > $@

ext/extract-vmlinux:
	cd ext && wget ${EXTRACTVMLINUXURL}
	chmod +x $@

clean:
	-rm -rf $(wildcard ${targets} *.o *.so kernel.s symtypes.s)

dist-clean: clean
	-rm -rf $(wildcard ${externals})
