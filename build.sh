#!/bin/sh

recursive_build_call() {
	$(cd $1;
	./build.sh $2)
}

build_dep() {
	recursive_build_call ./scripts/gen_cpio build
}

build_generic_cpiolist() {
	./scripts/gen_initramfs_list/gen_initramfs_list.sh $(pwd)/generic/initramfs > cpiolist
	cat ./generic/initramfs_squashed >> cpiolist
}

build_cpio() {
	./scripts/gen_cpio/gen_cpio ./cpiolist > initramfs
	gzip initramfs
}

build() {
	build_i686
}

build_i686() {
	build_dep
	build_generic_cpiolist
	./scripts/gen_initramfs_list/gen_initramfs_list.sh $(pwd)/i686/initramfs >> cpiolist
	build_cpio
}

clean() {
	recursive_build_call ./scripts/gen_cpio clean
	rm cpiolist &>/dev/null
	rm initramfs &>/dev/null
	rm initramfs.gz &>/dev/null
	rm -rf initramfs.d &>/dev/null
}

qemu_i686() {
	qemu -kernel ./i686/kernel/kernel -initrd ./initramfs.gz -append "ifmod=ne2k-pci ip=10.0.0.2 server=192.168.1.23:/storage/bla"
}

extract_initramfs() {
	mkdir initramfs.d
	cd initramfs.d
	zcat ../initramfs.gz | cpio --extract --no-absolute-filenames
}

TARGET=${1-build}

$TARGET
