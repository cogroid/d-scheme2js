#*=====================================================================*/
#*    The Makefile to build scheme2js.                                 */
#*=====================================================================*/
.PHONY: do 

do: build

SCHEME2JSTMPDIR = /tmp
SCHEME2JSDISTRIBDIR = "$$HOME/distribs/scheme2js"
HG = /usr/bin/hg

#*---------------------------------------------------------------------*/
#*    Standard Bigloo configuration                                    */
#*---------------------------------------------------------------------*/
-include etc/Makefile.scheme2jsconfig
#include etc/Makefile.version
-include $(BIGLOOLIBDIR)/Makefile.config

#*---------------------------------------------------------------------*/
#*    POPULATION                                                       */
#*---------------------------------------------------------------------*/
POPULATION	= Makefile LICENSE INSTALL configure .scheme2jsrelease
POPDIRS		= compiler

#*---------------------------------------------------------------------*/
#*    build                                                            */
#*---------------------------------------------------------------------*/
.PHONY: bindir bin lib doc tests tests_clean

build: showflags bindir bin

bindir:
	mkdir -p bin

bin:	
	(cd compiler && $(MAKE))

tests:
	(cd tests && $(MAKE))

tests_clean:
	(cd tests && $(MAKE) clean_tests && $(MAKE))

#*---------------------------------------------------------------------*/
#*    dep                                                              */
#*---------------------------------------------------------------------*/
dep:
	(cd compiler && $(MAKE) dep)

#*---------------------------------------------------------------------*/
#*    ude                                                              */
#*---------------------------------------------------------------------*/
ude:
	(cd compiler && $(MAKE) ude)

#*---------------------------------------------------------------------*/
#*    install                                                          */
#*---------------------------------------------------------------------*/
install:
	(cd compiler && $(MAKE) install)
	(cd doc && $(MAKE) install)

#*---------------------------------------------------------------------*/
#*    uninstall                                                        */
#*---------------------------------------------------------------------*/
uninstall:
	(cd compiler && $(MAKE) uninstall)
	(cd doc && $(MAKE) uninstall)

#*---------------------------------------------------------------------*/
#*    clean                                                            */
#*---------------------------------------------------------------------*/
clean:
	(cd compiler && $(MAKE) clean)
	(cd doc && $(MAKE) clean)

devclean: clean

distclean: clean devclean
	/bin/rm -f etc/Makefile.scheme2jsconfig

cleanall: distclean

doc:
	(cd doc; $(MAKE) -f Makefile.doc)

#*---------------------------------------------------------------------*/
#*    distrib:                                                         */
#*---------------------------------------------------------------------*/
distrib_release:
	version=`date '+%Y%m%d'`; \
	echo $$version; \
	if [ -f $(SCHEME2JSTMPDIR)/scheme2js-$$version ]; then \
	  echo "*** ERROR: $(SCHEME2JSTMPDIR)/scheme2js-$$version exists!"; \
	  exit 1; \
	else \
	  $(HG) tag --remove $$version; \
          $(HG) tag $$version && \
	  $(MAKE) distrib; \
	fi

distrib:
	version=`date '+%Y%m%d'`; \
	echo $$version; \
	if [ -f $(SCHEME2JSTMPDIR)/scheme2js-$$version ]; then \
	  echo "*** ERROR: $(SCHEME2JSTMPDIR)/scheme2js-$$version exists!"; \
	  exit 1; \
	else \
	  ./configure --backend=jvm && make -j && \
	  $(HG) clone . $(SCHEME2JSTMPDIR)/scheme2js-$$version && \
	  _TMP_BRANCH=`$(HG) branch` && echo "BRANCH: " $$_TMP_BRANCH && \
	  (cd $(SCHEME2JSTMPDIR)/scheme2js-$$version && \
	  $(HG) update -C $$_TMP_BRANCH && \
	  echo "(define *version* $$version)" > $(SCHEME2JSTMPDIR)/scheme2js-$$version/compiler/version.sch && \
	  $(MAKE) doc) && \
	  sed -i "s/!VERSION!/$$version/g" $(SCHEME2JSTMPDIR)/scheme2js-$$version/doc/index.html && \
	  cp $(SCHEME2JSTMPDIR)/scheme2js-$$version/doc/index.html $(SCHEME2JSDISTRIBDIR) && \
	  cp $(SCHEME2JSTMPDIR)/scheme2js-$$version/doc/scheme2js-man.html $(SCHEME2JSDISTRIBDIR) && \
	  tar -cvzf $(SCHEME2JSTMPDIR)/scheme2js-$$version.tar.gz --exclude .hg -C $(SCHEME2JSTMPDIR) scheme2js-$$version && \
	  $(RM) -rf $(SCHEME2JSTMPDIR)/scheme2js-$$version && \
	  mv $(SCHEME2JSTMPDIR)/scheme2js-$$version.tar.gz $(SCHEME2JSDISTRIBDIR) && \
	  cp bin/scheme2js.jar $(SCHEME2JSDISTRIBDIR)/scheme2js-$$version.jar && \
	  echo && echo "**** Created Distrib for: " $$_TMP_BRANCH; \
	fi
