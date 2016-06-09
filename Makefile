# -*- mode:makefile-gmake -*-

all: gencat.js
.PHONY: all

GenCatTable.txt: ExtractGeneralCategory.awk UNIDATA/UnicodeData.txt
	gawk -f ExtractGeneralCategory.awk UNIDATA/UnicodeData.txt > $@

gencat.js: create_gencat_js.sh GenCatTable.txt
	./$<
