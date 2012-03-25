#!/bin/sh
#
# Script Kernel Overclock Tablet Zenithink
# Hack by Johane
# fix for Tablet C71 by Morfes
#

rm kernel*
rm *.dump

dd if=ZT280.kernel of=kernel1.lzma bs=128 skip=1

lzcat < kernel1.lzma > kernel1

hexdump -C kernel1 > stock.dump

#Do camera patch for rom C91
#sed 's/\xee\xa0\xef\x40/\xee\xff\xef\xff/' kernel1 > kernel2

#Do overclock patch to 1000Mhz for rom C91 (search for 60000000, 200000000, 800000000 and patch to 60000000, 200000000, 1000000000 (0x3B9ACA00) )
#sed 's/\x00\x46\xc3\x23\x00\xc2\xeb\x0b\x00\x08\xaf\x2f/\x00\x46\xc3\x23\x00\xc2\xeb\x0b\x00\xca\x9a\x3b/' kernel2 > kernel3

##Do overclock patch to 900Mhz (0x35A4E900) for rom C71
sed 's/\x00\x46\xc3\x23\x00\xc2\xeb\x0b\x00\x08\xaf\x2f/\x00\x46\xc3\x23\x00\xc2\xeb\x0b\x00\xe9\xa4\x35/' kernel1 > kernel3

##Don't do oc patch
#cp kernel2 kernel3

hexdump -C kernel3 > mod.dump

#Kernel backup
cp ZT280.kernel ZT280.kernel_backup

java -Xmx512m -jar JLzma.jar e kernel3 kernel.patched.lzma
mkimage -A arm -O linux -T kernel -C lzma -a 80008000 -e 80008000 -d kernel.patched.lzma -n Linux-2.6.34 kernel.patched.uImage
mkimage -A arm -O linux -T firmware -C none -a ffffffff -e 00000000 -d kernel.patched.uImage -n LK:ZT280_E7_2m ZT280.kernel

diff mod.dump stock.dump
