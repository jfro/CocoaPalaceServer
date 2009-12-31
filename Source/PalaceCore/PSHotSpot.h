//
//  PSHotSpot.h
//  CocoaPServer
//
//  Created by Jeremy Knope on Sat Apr 03 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Structures.h"

@interface PSHotSpot : NSObject {
	HotSpot *spot;
}

- (HotSpot *)hotSpotRec;
- (void)setLocation:(Point)loc;
- (void)setType:(sint16)type;
@end
