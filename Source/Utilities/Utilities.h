/*
 *  Utilities.h
 *  CocoaPServer
 *
 *  Created by Jeremy Knope on Sun Mar 21 2004.
 *  Copyright (c) 2004 JfroWare. All rights reserved.
 *
 */

//#include <Carbon/Carbon.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "Local.h"
#include <stdint.h>

char * p2c(unsigned char * pch);
int c2pPad(const char * pch, char * dst,int len);
//char * c2pPad(char * pch,int len);
char * c2p(const char * pch);
char * long2ascii(uint32_t num);