/*
 *  Utilities.c
 *  CocoaPServer
 *
 *  Created by Jeremy Knope on Sun Mar 21 2004.
 *  Copyright (c) 2004 JfroWare. All rights reserved.
 *
 */

#include "Utilities.h"

char * p2c(unsigned char * pch)
{
	char * out;
	int cch;
	if (pch == NULL  ||  pch[0] <= 0)
		return NULL;
	// pch[0] contains count of characters
	cch = ((int) pch[0]);
	
	// add 1 for NULL term.
	out = malloc (cch+1);
	if (out == NULL)
		return NULL;

	// pch+1 is start of the string (skip count of chars)
	// cch is count of characters, without the null
	memcpy(out, pch+1, cch);
	// NULL terminate the string
	out[cch] = 0;

	return out;
}

int c2pPad(const char * pch, char * dst,int len) {
	char * p;
	int count;
	//printf("Converting %s to pstring padding %i\n",pch,len);
	if(pch == NULL)
		return 0;
	count = strlen(pch);
	if(count > len)
		return 0;
	//printf("Count: %i\n",count);
	//printf("String: %s\n",pch);
	//printf("String: %s\n",*dst);
	//out = malloc(len);
	//if(out == NULL)
	//	return NULL;
	// *out = (char)count;
	*dst = count;
	memcpy(dst+1,pch,count); // should copy pch into out starting at byte 1
	p = dst+count+1;
	for(count=count;count<len;count++) {
		*p = 0;
		p++;
	}
	return 1;
}

/*
char * c2pPad(char * pch,int len) {
	char * out;
	int count;
	//printf("Converting %s to pstring padding %i\n",pch,len);
	if(pch == NULL || len <= 0)
		return NULL;
	count = strlen(pch);
	//printf("Count: %i",count);
	out = malloc(len);
	if(out == NULL)
		return NULL;
	out[0] = count;
	memcpy(out+1,pch,count); // should copy pch into out starting at byte 1
	return out;
}
*/
char * c2p(const char * pch) {
	char * out;
	int count;
	//printf("Converting %s to pstring padding %i\n",pch,len);
	if(pch == NULL)
		return NULL;
	count = strlen(pch);
	//printf("Count: %i",count);
	out = malloc(count+1);
	if(out == NULL)
		return NULL;
	out[0] = count;
	memcpy(out+1,pch,count); // should copy pch into out starting at byte 1
	return out;
}

char * long2ascii(uint32_t num) {
	char * out;
	int size;
	char *p;
	p = (char *)&num;
	size = sizeof(num)+1; // # of bytes in long + 1 null byte
	out = malloc(size);
	if(out == NULL)
		return NULL;
	memcpy(out,p,4);
	out[size] = 0; // null byte
	//snprintf(out, sizeof(out), "%i", num);
	return out;
}