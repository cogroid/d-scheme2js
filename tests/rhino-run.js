SC_DEFAULT_OUT = new sc_GenericOutputPort(
    function(s) {
	java.lang.System.out.print(s);
    });
SC_ERROR_OUT = SC_DEFAULT_OUT;

var RHINO_K = undefined;
function rhinoSaveK(k) {
    RHINO_K = k;
}

sc_EMPTY_CALLCC = function(ignored) {
    RHINO_E.invoke = function() {
	while (true) {
	    try {
		return RHINO_K("resumed from RHINO");
	    } catch(e) {
		if (e !== RHINO_E)
		    throw e;
	    }
	}
    };
    throw RHINO_E;
};


function bench(name, f, expected, tmp) {
    if (typeof name == "function") // CPS
	return bench(f,
		     function() { return expected(name); },
		     tmp);

    print(f() + " " + expected);
}
