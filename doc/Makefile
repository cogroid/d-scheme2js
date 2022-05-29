include Makefile.doc
include ../etc/Makefile.scheme2jsconfig

install: scheme2js.1
	mkdir -p $(DESTDIR)$(SCHEME2JSMANDIR) && \
	install -m a+r $< $(DESTDIR)$(SCHEME2JSMANDIR)/$<

uninstall:
	- $(RM) -f $(MANDIR)/scheme2js.1

clean:
	- $(RM) -f index.html man.tex scheme2js.1
