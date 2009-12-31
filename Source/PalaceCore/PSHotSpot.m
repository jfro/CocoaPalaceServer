//
//  PSHotSpot.m
//  CocoaPServer
//
//  Created by Jeremy Knope on Sat Apr 03 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import "PSHotSpot.h"


@implementation PSHotSpot
- (id)init {
	if(![super init])
		return nil;
	spot = malloc(sizeof(HotSpot));
	if(spot == NULL) {
		NSLog(@"Failed to allocate memory for hotspot");
		return nil;
	}
	
	return self;
}

- (void)dealloc {
	free(spot);
	[super dealloc];
}

#pragma mark -
- (HotSpot *)hotSpotRec {
	return spot;
}

- (void)setLocation:(Point)loc {
	spot->loc = loc;
}

- (void)setType:(sint16)type {
	spot->type = type;
}

@end
