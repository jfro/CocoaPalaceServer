/*
 *  Local.h
 *  CocoaPServer
 *
 *  Created by Jeremy Knope on Sat Mar 13 2004.
 *  Copyright (c) 2004 JfroWare. All rights reserved.
 *
 */
 
 /* notes
 Another common technique is to process a buffer a little bit at a time.
This is generally done when the input data is known to
break the 'alignment' rules I spoke of earlier, and simple typecasting is
not an option.  Here's some code that breaks up a
char*buffer into long,char,long so as to fill up the 'problematic' data
structure I  described earlier.

myStruct outStruct;
char *sp = inputBuffer;  // char * buffer
outStruct.a = *((long *) sp);
sp += sizeof(long);
outStruct.b = *((char *) sp);
sp += sizeof(char);
outStruct.c = *((long *) sp);
sp += sizeof(long);
 */

#define LONG	long
//typedef unsigned long uint32;
//typedef signed long sint32;
//typedef signed short sint16;
//typedef unsigned char uint8;
//typedef char Str31[32];