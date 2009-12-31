//
//  PSAsset.m
//  CocoaPServer
//
//  Created by Jeremy Knope on Sat Mar 20 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import "PSAsset.h"


@implementation PSAsset
- (id)init {
	if(![super init])
		return nil;
	asset = malloc(sizeof(AssetSpec));
	
	return self;
}

- (void)dealloc {
	free(asset);
	[super dealloc];
}

- (AssetSpec *)asset {
	return asset;
}

- (void)setAsset:(AssetSpec)ass {
	*asset = ass;
}

- (void)setCrc:(uint32)crc {
	asset->crc = crc;
}

- (void)setId:(sint32)id {
	asset->id = id;
}
@end
