//
//  MansionScript.h
//  CocoaPServer
//
//  Created by Jeremy Knope on Sat Apr 03 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MansionScript : NSObject {
	NSMutableDictionary *prefs;
}

- (void)loadPrefs;
- (NSArray *)rooms;
- (NSString *)serverName;
- (uint32)entrance;
@end
