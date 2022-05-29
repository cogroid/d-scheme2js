all: results

#ALL_TESTS =  callcc callcc_b callcc_c callcc_d callcc_e \
#	deep_callcc \
#	IO R5RS1 R5RS2 R5RS3 R5RS4 error string expand symbol nodeElim tail inline \
#	constantPropagation varPropagation rmUnusedVars capture while statements \
#	callOptim boolifyOptim varNbOptim runtime_tests \
#	macro module_s module_b moduleD_s moduleD_b bugs\
#	deep_recursive \

ALL_TESTS = IO R5RS1 R5RS2 R5RS3 R5RS4 error string expand symbol nodeElim tail inline \
	constantPropagation varPropagation rmUnusedVars capture while statements \
	callOptim boolifyOptim varNbOptim runtime_tests \
	macro module_s module_b moduleD_s moduleD_b bugs\
	deep_recursive \

TESTS = $(ALL_TESTS)
#TESTS = R5RS4
#TESTS = callcc
#TESTS=inline
#TESTS=trouble
#TESTS=deep_callcc
#TESTS=decl
#TESTS=runtime_tests
#TESTS=capture
#TESTS=beval
#TESTS=deep_recursive

ALL_CALLCC_FLAG = 
CALLCC_FLAG = --call/cc

VERBOSE_FLAG = -g

RHINO_CLASSPATH = $$HOME/NOSAVE/playground/rhino/rhino1_7R1/build/classes
RHINO = ./rhino-sch
RHINO_RUNTIME = rhino-run.js
#SCM2JS = java -jar ../bin/scheme2js.jar
SCM2JS = ../bin/scheme2js
RUNTIME_DIR = ../compiler/runtime
EXPORTER = $(RUNTIME_DIR)/exporter
SCHEME2JS_RUNTIME = $(RUNTIME_DIR)
-include $(RUNTIME_DIR)/Makefile.include
RUNTIME = $(RUNTIME_DIR)/runtime.js $(RUNTIME_DIR)/runtime_interface.js $(RUNTIME_DIR)/runtime_callcc.js $(RUNTIME_DIR)/runtime_interface_callcc.js
TESTS_DIFF=$(TESTS:%=%0.diff) $(TESTS:%=%1.diff) $(TESTS:%=%2.diff) $(TESTS:%=%3.diff)
TESTS_RESULTS=$(TESTS:%=%0.result) $(TESTS:%=%1.result) $(TESTS:%=%2.result) $(TESTS:%=%3.result)
FLAGS0= -O0 --export-globals --js-this $(ALL_CALLCC_FLAG) $(VERBOSE_FLAG)
FLAGS1= -Obench --js-this $(ALL_CALLCC_FLAG) $(VERBOSE_FLAG)
## flags 2 and 3 will test trampoline and line-numbers too... Line numbers are currently deactived.
FLAGS2= -O0 --export-globals --js-this --trampoline --statics-suffix "suffix" $(CALLCC_FLAG) $(VERBOSE_FLAG)
# FLAGS3 is responsible for testing --correct-modulo too
FLAGS3= -Obench --js-this --encapsulate-modules --correct-modulo --trampoline --max-tail-depth 5 $(CALLCC_FLAG) $(VERBOSE_FLAG)


#OVERRIDE_TROUBLE = if [ "$<" = trouble.scm ]; then OVERRIDE="$$OVERRIDE --suspend/resume"; fi;
OVERRIDE_TROUBLE =
OVERRIDE_MODULE_A = if [ "$<" = moduleA_s.scm ]; then OVERRIDE="$$OVERRIDE --no-bigloo-modules"; fi;
OVERRIDE_MODULE_B = if [ "$<" = moduleB_s.scm ]; then OVERRIDE="$$OVERRIDE --no-bigloo-modules"; fi;
OVERRIDE_MODULE_C = if [ "$<" = moduleC_s.scm ]; then OVERRIDE="$$OVERRIDE --no-bigloo-modules"; fi;
OVERRIDE_MODULE_D = if [ "$<" = moduleD_s.scm ]; then OVERRIDE="$$OVERRIDE --no-bigloo-modules"; fi;
OVERRIDE_MODULES = $(OVERRIDE_MODULE_A) $(OVERRIDE_MODULE_B) $(OVERRIDE_MODULE_C) $(OVERRIDE_MODULE_D)
OVERRIDE_DEEP_RECURSIVE = if [ "$<" = deep_recursive.scm ]; then OVERRIDE="$$OVERRIDE --trampoline"; fi;
OVERRIDE_CALLCC_A = if [ "$<" = callcc.scm ]; then OVERRIDE="$$OVERRIDE --call/cc"; fi;
OVERRIDE_CALLCC_B = if [ "$<" = callcc_b.scm ]; then OVERRIDE="$$OVERRIDE --call/cc"; fi;
OVERRIDE_CALLCC_C = if [ "$<" = callcc_c.scm ]; then OVERRIDE="$$OVERRIDE --call/cc"; fi;
OVERRIDE_CALLCC_D = if [ "$<" = callcc_d.scm ]; then OVERRIDE="$$OVERRIDE --call/cc"; fi;
OVERRIDE_CALLCC_E = if [ "$<" = callcc_e.scm ]; then OVERRIDE="$$OVERRIDE --call/cc"; fi;
OVERRIDE_CALLCCS = $(OVERRIDE_CALLCC_A) $(OVERRIDE_CALLCC_B) $(OVERRIDE_CALLCC_C) $(OVERRIDE_CALLCC_D) $(OVERRIDE_CALLCC_E)
OVERRIDE_DEEP_CALLCC = if [ "$<" = deep_callcc.scm ]; then OVERRIDE="$$OVERRIDE --call/cc --trampoline"; fi;
OVERRIDE_SUSPEND = if [ "$<" = suspend.scm ]; then OVERRIDE="$$OVERRIDE --suspend/resume"; fi;
OVERRIDES = OVERRIDE=""; $(OVERRIDE_TROUBLE) $(OVERRIDE_MODULES) $(OVERRIDE_DEEP_RECURSIVE) \
                         $(OVERRIDE_CALLCCS) $(OVERRIDE_DEEP_CALLCC) $(OVERRIDE_SUSPEND)

tests_clean:
	$(MAKE) clean_tests && $(MAKE)

.PHONY: all clean goods commands clean_tests tests_clean js compiler
#.PRECIOUS: $(TESTS_DIFF) $(TESTS:%.good) $(TESTS:%=%0.js) $(TESTS:%=%1.js) $(TESTS:%=%2.js) $(TESTS:%=%3.js)
.PRECIOUS: $(TESTS:%.good)

js: $(ALL_TESTS:%=%0.js) $(ALL_TESTS:%=%1.js) $(ALL_TESTS:%=%2.js) $(ALL_TESTS:%=%3.js)

results: $(TESTS_RESULTS)
	@cat $^ > $@ && \
	echo "OKs: " `grep "*ok*" $@ | wc -l`;

%.js: %.scm
	$(SCM2JS) -o $@ $<

%0.js: %.scm
	@echo $@; \
	$(OVERRIDES) \
	$(SCM2JS) $(FLAGS0) $$OVERRIDE -o $@ $<
%1.js: %.scm
	@echo $@; \
	$(OVERRIDES) \
	$(SCM2JS) $(FLAGS1) $$OVERRIDE -o $@ $<
%2.js: %.scm
	@echo $@; \
	$(OVERRIDES) \
	$(SCM2JS) $(FLAGS2) $$OVERRIDE -o $@ $<
%3.js: %.scm
	@echo $@ ; \
	$(OVERRIDES) \
	$(SCM2JS) $(FLAGS3) $$OVERRIDE -o $@ $<

T%.class.js: $(RUNTIME) $(RHINO_RUNTIME) %.js
	@echo "try {" > $@ && \
	echo "  var RHINO_E = new Object();" >> $@ && \
	cat $^ >> $@ && \
	echo "} catch(e) {" >> $@ && \
	echo "	if (e === RHINO_E)" >> $@ && \
	echo "     e.invoke();" >> $@ && \
	echo "  else { print(e.lineNumber); print(e); throw e; }}" >> $@

T%.class: T%.class.js
	@$(RHINO) $@ $<

module_s%.js: moduleB_s%.js moduleA_s%.js
	@cat $^ > $@
module_b%.js: moduleB_b%.js moduleA_b%.js
	@cat $^ > $@

module_s.good:
	@echo "do-print" > $@;
module_b.good:
	@echo "do-print" > $@;

moduleD_s.good:
	@echo "123yyy" > $@;
moduleD_b.good:
	@echo "123yyy" > $@;

moduleC_s.sch: moduleC.js $(EXPORTER)
	$(EXPORTER) -o $@ --scheme2js-modules --module moduleC_s $<

%.out: T%.class
	@echo $@ && \
	export CLASSPATH=.:$(RHINO_CLASSPATH):$$CLASSPATH && \
	java `echo $< | sed 's/.class//'` > $@;

goods: $(TESTS:%=%.good)

%.bigloo.scm: %.scm
	@echo "(module ttt)" > $@ && \
	echo " (define (js-field . L) #unspecified) " >> $@ && \
	echo " (define (js-field-set! . L) #unspecified) " >> $@ && \
	echo " (define (new . L) #unspecified) " >> $@ && \
	echo " (define (js-call . L) #unspecified) " >> $@ && \
	echo " (define this 'this)" >> $@ && \
	cat $< >> $@

%.bigloo.exec: %.bigloo.scm
	@bigloo -call/cc $^ -o $@

%.good: %.bigloo.exec
	@./$^ > $@;
#	bigloo -call/cc -i $< > $@

callcc_d.good: callcc_d.good.backup
	@cp $< $@

%0.diff: %.good %0.out
	@diff $^ > $@ || echo "ok" > /dev/null

%1.diff: %.good %1.out
	@diff $^ > $@ || echo "ok" > /dev/null

%2.diff: %.good %2.out
	@diff $^ > $@ || echo "ok" > /dev/null

%3.diff: %.good %3.out
	@diff $^ > $@ || echo "ok" > /dev/null

%.result: %.diff %.expected
	@if [ "ok_" = `cmp -s $^ && echo "ok"`_ ]; then echo "*ok*" > $@; else echo "*fail*" > $@ && echo "*** " $@; fi;

#by default expected should be empty.
%.expected:
	@touch $@;

clean:
	@rm -rf *.bigloo.exec *.bigloo.scm *.good *.class *.out *.class.js *[0123].js *.diff *.o *.result results;

clean_tests:
	@rm -rf *.bigloo.exec *.class *.out *.class.js *[0123].js *.diff *.o *.result results;

commands:
	@echo 'function c0() { f=$$1; shift; $(SCM2JS) $(FLAGS0) $$* -o "$$f"0.js $$f.scm }' && \
	echo 'function c1() { f=$$1; shift; $(SCM2JS) $(FLAGS1) $$* -o "$$f"1.js $$f.scm }' && \
	echo 'function c2() { f=$$1; shift; $(SCM2JS) $(FLAGS2) $$* -o "$$f"2.js $$f.scm }' && \
	echo 'function c3() { f=$$1; shift; $(SCM2JS) $(FLAGS3) $$* -o "$$f"3.js $$f.scm }' && \
	echo export CLASSPATH=.:$(RHINO_CLASSPATH):$$CLASSPATH && \
	echo java class;

compiler:
	$(MAKE) -C ../compiler
