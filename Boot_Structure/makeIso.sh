#!/bin/bash

. ../CONFIG

function main() {
mkisofs -o ../"${NAME}".iso \
   -b isolinux/isolinux.bin -c isolinux/boot.cat \
   -no-emul-boot -boot-load-size 4 -boot-info-table \
   .
}
main;
