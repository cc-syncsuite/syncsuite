#!/bin/sh

build() {
	gcc gen_cpio.c -o gen_cpio
}

clean() {
	rm gen_cpio &>/dev/null
}

TARGET=${1-build}

$TARGET
