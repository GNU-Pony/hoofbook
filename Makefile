PROGRAM = hoofbook
PKGNAME = hoofbook

TEXIFLAGS = #--force

ALL_COMPRESS = #.gz
PDF_COMPRESS = $(ALL_COMPRESS)
PS_COMPRESS = $(ALL_COMPRESS)
DVI_COMPRESS = $(ALL_COMPRESS)

PREFIX = /usr
DATA = /share


MANE_SRC = $(PROGRAM).texinfo
INCLUDED_SRC = $(shell find chap | grep '\.texinfo$$') $(shell find appx | grep '\.texinfo$$')



# basic invokable rules
.PHONY: all
all:

.PHONY: install
install:

.PHONY: uninstall
uninstall:

.PHONY: clean
clean:
	-rm -r -- bin obj

# compressions
%.gz: %
	gzip -9c < "$<" > "$@"

%.bz2: %
	bzip2 -9c < "$<" > "$@"

%.xz: %
	xz -e9 < "$<" > "$@"



## Texinfo manual section

.PHONY: doc doc.gz
all: doc
doc: info pdf$(PDF_COMPRESS) ps$(PS_COMPRESS) dvi$(DVI_COMPRESS)

# invokable rules for specific files

.PHONY: info
info: $(PROGRAM).info.gz

.PHONY: pdf pdf.gz pdf.bz2 pdf.xz
pdf: $(PROGRAM).pdf
pdf.gz: $(PROGRAM).pdf.gz
pdf.bz2: $(PROGRAM).pdf.bz2
pdf.xz: $(PROGRAM).pdf.xz

.PHONY: ps ps.gz ps.bz2 ps.xz
ps: $(PROGRAM).ps
ps.gz: $(PROGRAM).ps.gz
ps.bz2: $(PROGRAM).ps.bz2
ps.xz: $(PROGRAM).ps.xz

.PHONY: dvi dvi.gz dvi.bz2 dvi.xz
dvi: $(PROGRAM).dvi
dvi.gz: $(PROGRAM).dvi.gz
dvi.bz2: $(PROGRAM).dvi.bz2
dvi.xz: $(PROGRAM).dvi.xz

# rules for creating the logo

obj/logo.pdf: logo.svg
	mkdir -p obj
	rsvg-convert --format=pdf "$<" > "$@"

obj/logo.eps: obj/logo.ps
	ps2eps "$<"

obj/logo.ps: logo.svg
	mkdir -p obj
	rsvg-convert --format=ps "$<" > "$@"

# rules for compile the manual to diffent formats

$(PROGRAM).info: $(MANE_SRC) $(INCLUDED_SRC)
	mkdir -p obj
	cd obj && $(MAKEINFO) $(TEXIFLAGS) "../$<" && mv "$@" ..

$(PROGRAM).pdf: $(MANE_SRC) $(INCLUDED_SRC) obj/logo.pdf
	cd obj && texi2pdf $(TEXIFLAGS) "../$<" && texi2pdf "../$<" && mv "$@" ..

$(PROGRAM).dvi: $(MANE_SRC) $(INCLUDED_SRC) obj/logo.eps
	cd obj && $(TEXI2DVI) $(TEXIFLAGS) "../$<" && $(TEXI2DVI) "../$<" && mv "$@" ..

$(PROGRAM).ps: $(MANE_SRC) $(INCLUDED_SRC) obj/logo.eps
	cd obj && texi2pdf $(TEXIFLAGS) --ps "../$<" && texi2pdf --ps "../$<" && mv "$@" ..

# rules for installing the manual

.PHONY: install-info
install: install-info
install-info: $(PROGRAM).info.gz
	install -Dm644 "$<" -- "$(DESTDIR)$(PREFIX)$(DATA)/info/$(PKGNAME).info.gz"

.PHONY: install-pdf
install: install-pdf
install-pdf: $(PROGRAM).pdf$(PDF_COMPRESS)
	install -Dm644 "$<" -- "$(DESTDIR)$(PREFIX)$(DATA)/doc/$(PKGNAME).pdf$(PDF_COMPRESS)"

.PHONY: install-dvi
install: install-dvi
install-dvi: $(PROGRAM).dvi$(DVI_COMPRESS)
	install -Dm644 "$<" -- "$(DESTDIR)$(PREFIX)$(DATA)/doc/$(PKGNAME).dvi$(DVI_COMPRESS)"

.PHONY: install-ps
install: install-ps
install-ps: $(PROGRAM).ps$(PS_COMPRESS)
	install -Dm644 "$<" -- "$(DESTDIR)$(PREFIX)$(DATA)/doc/$(PKGNAME).ps$(PS_COMPRESS)"

# rules for uninstalling the manual

.PHONY: uninstall-info
uninstall: uninstall-info
uninstall-info:
	-rm -- "$(DESTDIR)$(PREFIX)$(DATA)/doc/$(PKGNAME).info.gz"

.PHONY: uninstall-pdf
uninstall: uninstall-pdf
uninstall-pdf:
	-rm -- "$(DESTDIR)$(PREFIX)$(DATA)/doc/$(PKGNAME).pdf$(PDF_COMPRESS)"

.PHONY: uninstall-dvi
uninstall: uninstall-dvi
uninstall-dvi:
	-rm -- "$(DESTDIR)$(PREFIX)$(DATA)/doc/$(PKGNAME).dvi$(DVI_COMPRESS)"

.PHONY: uninstall-ps
uninstall: uninstall-ps
uninstall-ps:
	-rm -- "$(DESTDIR)$(PREFIX)$(DATA)/doc/$(PKGNAME).ps$(PS_COMPRESS)"

# rules for clean

.PHONY: clean-texinfo
clean: clean-texinfo
clean-texinfo:
	-rm -- *.{info,pdf,ps,dvi}{,.gz,.bz2,.xz} 2>/dev/null
	-rm -- *.{aux,cp,cps,fn,ky,log,pg,pgs,toc,tp,vr,vrs,eps,op,ops} 2>/dev/null


## License section

.PHONY: install-license
install: install-license
install-license:
	install -d -- "$(DESTDIR)$(PREFIX)$(DATA)/licenses/$(PKGNAME)"
	install -m644 LICENSE -- "$(DESTDIR)$(PREFIX)$(DATA)/licenses/$(PKGNAME)"

.PHONY: uninstall-license
uninstall: uninstall-license
uninstall-license:
	-rm -- "$(DESTDIR)$(PREFIX)$(DATA)/licenses/$(PKGNAME)/LICENSE"
	-rmdir -- "$(DESTDIR)$(PREFIX)$(DATA)/licenses/$(PKGNAME)"

