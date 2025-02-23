/* static char sccsid[] = "@(#)pk.p	4.1 (decvax!larry) 7/2/90"; */

/*
 * OLD-OLD-OLD-OLD
 * #defines that permit the pk routines to be used in the kernel
 * or user space.  Has not been tested in kernel space.
 * OLD-OLD-OLD-OLD
 * 
 * The new packet driver comes from 4.3 and doesn't use anything
 * in this file except the PKASSERT() macro.  - decvax!marc Jan-28-1987
 *
 */

/*
 * kernel level
 */
#ifdef	KERNEL

#define PADDR		((struct pack *)tp->t_linep)
#define TURNOFF		pkturnoff(tp)
#define UCOUNT		u.u_count
#define S		tp
#define P		pk->p_ttyp
#define SDEF		struct tty *tp
#define FS		, tp

#define SIGNAL		signal(pk->p_ttyp->t_pgrp, SIGPIPE)
#define TERROR		pk->p_istate == R_ERROR
#define SETERROR	u.u_error = EIO
#define OBUSY		tp->t_state&BUSY
#define	ODEAD		((tp->t_state&CARR_ON)==0)
#define GETEPACK	getepack(pk->p_bits)
#define FREEPACK(a,b)	freepack(a, b)


#define q1	tp->t_rawq
#define q2	tp->t_canq
#define q3	tp->t_outq

#define LOCK		s = spl6()
#define UNLOCK		splx(s)
#define DSYSTEM		struct tty *p_ttyp
#define ISYSTEM		tp = pk->p_ttyp
#define SLEEP(a, b)	sleep(a, b)
#define	SLEEPNO		(tp->t_chan!=NULL)
#define WAKEUP(a)	wakeup(a)
#define IOMOVE(p, c, f) iomove(p, c, f)
#define PKGETPKT(p)
#define DTOM(a)		dtom(a)
#include "../h/param.h"
#include "../h/dir.h"
#include "../h/user.h"
#include "../h/tty.h"
#include "../h/buf.h"
#include "../h/proc.h"

#endif
/*
 * user level
 */
#ifdef	USER
#define SLEEP(a, b) 
#define SIGNAL
#define WAKEUP(a)
#define DSYSTEM		int p_ifn, p_ofn
#define ISYSTEM
#define GETEPACK	malloc((unsigned)pk->p_xsize)
#define FREEPACK(a, b)	free((char *)a)
#define OBUSY		0
#define PKGETPKT(p)	pkgetpack(p);
#define DTOM(a)		1;
#define S		ipk, ibuf, icount
#define SDEF		int icount; char *ibuf; struct pack *ipk
#define UCOUNT		icount
#define IOMOVE(p, c, f)	pkmove(p, ibuf, c, f) ; ibuf += c; UCOUNT -= c
#define PADDR		ipk
#define TURNOFF
#define LOCK
#define UNLOCK
#define SETERROR
#ifndef PACKSIZE
#define	PACKSIZE	64
#endif
#define	WINDOWS		3
#define	PKDEBUG(l, f, s) { extern Pkdebug; if (Pkdebug >= l) fprintf(stderr, f, s);}
#define	PKASSERT(e, s1, s2, i1) if (!(e)) {\
assert(s1, s2, i1);\
pkfail();} else
#endif
