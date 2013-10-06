PROGRAM = hoofbook
PKGNAME = hoofbook
TEXINFO_DIR = .

ALL_COMPRESS = #.gz
PDF_COMPRESS = $(ALL_COMPRESS)
PS_COMPRESS = $(ALL_COMPRESS)
DVI_COMPRESS = $(ALL_COMPRESS)

PREFIX = /usr
DATA = /share



.PHONY: all
all:


%.gz: %
	gzip -9f  "$<"

%.bz2: %
	bzip2 -9f "$<"

%.xz: %
	xz -e9f "$<"


.PHONY: install
install:

.PHONY: uninstall
uninstall:

.PHONY: clean
clean:
	-rm -r -- bin obj

## Texinfo manual section

.PHONY: doc doc.gz
all: doc
doc: info pdf$(PDF_COMPRESS) ps$(PS_COMPRESS) dvi$(DVI_COMPRESS)

.PHONY: info pdf ps dvi pdf.gz ps.gz dvi.gz
info: $(PROGRAM).info.gz
pdf: $(PROGRAM).pdf
pdf.gz: $(PROGRAM).pdf.gz
ps: $(PROGRAM).ps
ps.gz: $(PROGRAM).ps.gz
dvi: $(PROGRAM).dvi
dvi.gz: $(PROGRAM).dvi.gz

obj/logo.pdf: logo.svg
	rsvg-convert --format=pdf "$<" > "$@"

obj/logo.eps: obj/logo.ps
	ps2eps "$<"

obj/logo.ps: logo.svg
	rsvg-convert --format=ps "$<" > "$@"

$(PROGRAM).info: $(TEXINFO_DIR)/$(PROGRAM).texinfo
	mkdir -p obj
	cd obj && $(MAKEINFO) "../$<" && mv "$@" ..

$(PROGRAM).pdf: $(TEXINFO_DIR)/$(PROGRAM).texinfo obj/logo.pdf
	mkdir -p obj
	cd obj && texi2pdf "../$<" && texi2pdf "../$<" && mv "$@" ..

$(PROGRAM).dvi: $(TEXINFO_DIR)/$(PROGRAM).texinfo obj/logo.eps
	mkdir -p obj
	cd obj && $(TEXI2DVI) "../$<" && $(TEXI2DVI) "../$<" && mv "$@" ..

$(PROGRAM).ps: $(TEXINFO_DIR)/$(PROGRAM).texinfo obj/logo.eps
	mkdir -p obj
	cd obj && texi2pdf --ps "../$<" && texi2pdf --ps "../$<" && mv "$@" ..

.PHONY: install-info
install: install-info
install-info: $(PROGRAM).info.gz
	install -Dm644 "$<" -- "$(DESTDIR)$(PREFIX)$(DATA)/info/$(PKGNAME).info.gz"

.PHONY: uninstall-info
uninstall: uninstall-info
uninstall-info:
	-rm -- "$(DESTDIR)$(PREFIX)$(DATA)/info/$(PKGNAME).info.gz"

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

