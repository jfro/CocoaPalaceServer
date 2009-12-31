//
//  PSRoom.h
//  CocoaPServer
//
//  Created by Jeremy Knope on Sat Mar 13 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "PSUser.h"
#import "Structures.h"

@class PSUser;
@class PSAsset;

@interface PSRoom : NSObject {
	//NSMutableDictionary *users;
	NSString *name;
	NSString *author;
	NSString *pictureFilename;
	NSString *script;
	sint16 roomID;
	NSMutableArray *users; // users in room
	NSMutableArray *looseProps;
	RoomRec *roomData;
}

- (sint16)roomID;
- (void)setRoomID:(sint16)anId;
- (NSString *)name;
- (void)setName:(NSString *)aName;
- (NSString *)author;
- (void)setAuthor:(NSString *)anAuthor;
- (NSString *)pictureFilename;
- (void)setPictureFilename:(NSString *)aFile;
- (NSString *)script;
- (void)setScript:(NSString *)scr;
- (void)addUser:(PSUser *)aUser;
- (void)removeUser:(PSUser *)aUser;
- (sint16)userCount;
- (NSArray *)users;

- (void)addProp:(NSData *)asset;
- (int)propCount;
- (NSArray *)looseProps;
@end
