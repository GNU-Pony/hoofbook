PROGRAM = hoofbook
PKGNAME = hoofbook
TEXINFO_DIR = .

PREFIX = /usr
DATA = /share



.PHONY: all
all:


%.gz: %
	gzip -9c < "$<" > "$@"

%.bz2: %
	bzip2 -9c < "$<" > "$@"

%.xz: %
	xz -e9 < "$<" > "$@"


.PHONY: install
install:

.PHONY: uninstall
uninstall:

.PHONY: clean
clean:
	-rn -r -- bin obj

## Texinfo manual section

.PHONY: doc
all: doc
doc: info pdf ps dvi

.PHONY: info pdf ps dvi
info: $(PROGRAM).info.gz
pdf: $(PROGRAM).pdf.gz
ps: $(PROGRAM).ps.gz
dvi: $(PROGRAM).dvi.gz

logo.pdf: logo.svg
	rsvg-convert --format=pdf "$<" > "$@"

logo.eps: logo.ps
	ps2eps "$<"

logo.ps: logo.svg
	rsvg-convert --format=pdf "$<" > "$@"

$(PROGRAM).info: $(TEXINFO_DIR)/$(PROGRAM).texinfo
	mkdir -p obj
	cd obj && $(MAKEINFO) "../$<" && mv "$@" ..

$(PROGRAM).pdf: $(TEXINFO_DIR)/$(PROGRAM).texinfo logo.pdf
	mkdir -p obj
	cd obj && texi2pdf "../$<" && texi2pdf "../$<" && mv "$@" ..

$(PROGRAM).dvi: $(TEXINFO_DIR)/$(PROGRAM).texinfo logo.eps
	mkdir -p obj
	cd obj && $(TEXI2DVI) "../$<" && $(TEXI2DVI) "../$<" && mv "$@" ..

$(PROGRAM).ps: $(TEXINFO_DIR)/$(PROGRAM).texinfo logo.eps
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

