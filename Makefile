# -*- mode:makefile-gmake -*-

all:
.PHONY: all

directories+=out
out/GenCatTable.txt: ExtractGeneralCategory.awk UCD/UnicodeData.txt | out
	gawk -f ExtractGeneralCategory.awk UCD/UnicodeData.txt > $@

all: out/gencat.js
out/gencat.js: create_gencat_js.sh out/GenCatTable.txt | out
	./$<

#
# unicode data
#

clean-data:
	-/bin/rm -f UCD/*

directories+=UCD
UCD/UnicodeData.txt: | UCD
	wget -O $@ http://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt


#
# common operations
#

$(directories):
	mkdir -p $@
