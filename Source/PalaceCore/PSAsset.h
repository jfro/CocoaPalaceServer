//
//  PSAsset.h
//  CocoaPServer
//
//  Created by Jeremy Knope on Sat Mar 20 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//
// For a prop in Palace, an asset

#import <Foundation/Foundation.h>
#import "Structures.h"

@interface PSAsset : NSObject {
	AssetSpec *asset;
}

- (AssetSpec *)asset;
- (void)setAsset:(AssetSpec)ass;
@end
