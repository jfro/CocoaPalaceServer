//
//  main.m
//  CocoaPServer
//
//  Created by Jeremy Knope on Sat Mar 13 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PSApplication.h"
#import "NetSocket.h"

/*
int main(int argc, const char *argv[])
{
    return NSApplicationMain(argc, argv);
}
*/
int main( int inArgC, const char* inArgV[] ) {
	NSAutoreleasePool*	pool = [[NSAutoreleasePool alloc] init];
	PSApplication*			application = nil;
	
	// Use the NetSocket convenience method to ignore broken pipe signals
	[NetSocket ignoreBrokenPipes];
	
//	NS_DURING
//	{
		application = [[[PSApplication alloc] init] autorelease];
		[application serve];
		
		// Run runloop
		[[NSRunLoop currentRunLoop] run];
//	}
//	NS_HANDLER
//		NSLog( @"Palace Server::Unhandled exception, exiting..." ); // how do we get the thrown exception?
//	NS_ENDHANDLER
	
	[pool release];
	return 0;
}