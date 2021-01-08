#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include "largescaler.h"

#define CALLDEF(name, n) {#name, (DL_FUNC) &name, n}

static const R_CallMethodDef callEntries[] = {
	CALLDEF(C_port, 0),
	NULL
};

void R_init_port(DllInfo *info)
{
	R_registerRoutines(info, NULL, callEntries, NULL, NULL);
	R_useDynamicSymbols(info, FALSE);
	R_forceSymbols(info, TRUE);
}
