//
//  PSPropBag.h
//  CocoaPServer
//
//  Created by Jeremy Knope on Tue Apr 06 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PSProp;

@interface PSPropBag : NSObject {
	NSMutableDictionary *propAttributes;
	NSMutableDictionary *propData;
}

- (void)loadProps; // loads plist file into memory, keeping attributes only
- (void)addProp:(PSProp *)aProp;
@end
