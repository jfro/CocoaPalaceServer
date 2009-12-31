//
//  MansionScript.m
//  CocoaPServer
//
//  Created by Jeremy Knope on Sat Apr 03 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import "MansionScript.h"


@implementation MansionScript
- (void)loadPrefs {
	prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"mansion.plist"];
	if(prefs == nil) {
		NSLog(@"FAILED to load mansion.plist");
	}
	else {
		//NSLog(@"Palace name: %@",[prefs objectForKey:@"servername"]);
	}
}
- (NSArray *)rooms {
	return [prefs objectForKey:@"rooms"];
}
- (NSString *)serverName {
	return [prefs objectForKey:@"servername"];
}
- (uint32)entrance {
	return [[prefs objectForKey:@"entrance"] intValue];
}
@end
