/*
	EMAIN.TEMPLATE - Main entry point template for Windows. 
*/

#ifdef __cplusplus
extern "C" {
#endif

#include <windows.h>

#include "eif_macros.h"
#include "eif_sig.h"
#include "eif_main.h"

extern void emain(int, char **);
extern int main(void);
extern void egc_init_plug (void); 
extern void egc_rcdt_init (void); 
extern void eif_retrieve_root (int *argc, char **argv);
extern void eif_init_root (void);

#ifndef GetEnvironmentStringsA 
 extern LPVOID WINAPI GetEnvironmentStringsA(void);
#endif

int APIENTRY WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
	return main();
}

int main (void)
{
	int argc;
	char **argv;
	char **envp;

		/* These variables are used by the WEL library */
	ghInstance = GetModuleHandle(NULL);
	eif_hInstance = GetModuleHandle(NULL);
	eif_hPrevInstance = NULL;
	eif_lpCmdLine = GetCommandLine();
	eif_nCmdShow = SW_SHOW;

		/* Initialization of the command line which is going to be passed to eiffel */
	get_argcargv (&argc, &argv);
		/* We get ANSI version of environment variables */
	envp = (char **) GetEnvironmentStringsA();

	eif_alloc_init();
#ifdef EIF_THREADS
	eif_thr_init_root();
#endif
	{
		GTCX
		struct ex_vect *exvect;
		jmp_buf exenv;
	
		egc_init_plug();
		initsig();
		initstk();
		exvect = exset((char *) 0, 0, (char *) 0);
		exvect->ex_jbuf = &exenv;
		if (setjmp(exenv))
			failure();
	
		eif_retrieve_root (&argc, argv);
		eif_rtinit(argc, argv, envp);
		eif_init_root();
		egc_rcdt_init();
		emain(argc, argv);
		free_argv (&argv);
		reclaim();
	}
	FreeEnvironmentStringsA ((LPSTR) envp);

	exit(0);
	return 0;
}

#ifdef __cplusplus
}
#endif
