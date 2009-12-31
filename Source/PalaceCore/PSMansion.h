//
//  PSMansion.h
//  CocoaPServer
//
//  Created by Jeremy Knope on Sat Mar 13 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Structures.h"
@class PSUser;
@class PSRoom;
@class MansionScript;

@interface PSMansion : NSObject {
	NSString *palaceName;
	NSMutableDictionary *users;
	NSMutableDictionary *rooms;
	int currentId;
	RoomID gateId; // id of the gate room
	MansionScript *script;
	// permissions
	// options
}
#pragma mark -
- (void)setPalaceName:(NSString *)aName;
- (NSString *)palaceName;
#pragma mark -
- (int)addUser:(PSUser *)aUser; // returns user's ID
- (void)removeUser:(PSUser *)aUser;
- (PSUser *)getUserWithId:(int)anId;
- (int)userCount;
- (NSDictionary *)users;
- (void)userLoggedOn:(PSUser *)aUser;
- (void)userLoggedOff:(PSUser *)aUser;
#pragma mark -
- (RoomID)gateID;
- (NSDictionary *)rooms;
- (void)addRoom:(PSRoom *)aRoom;
- (PSRoom *)getRoomWithId:(int)anId;
- (void)userEnteredRoom:(PSUser *)aUser;
- (void)userExitedRoom:(PSUser *)aUser;
- (void)userMovedInRoom:(PSUser *)aUser;
- (void)userXTalkedInRoom:(PSUser *)aUser data:(NSData *)data;
- (void)userChangedColorInRoom:(PSUser *)aUser;
- (void)userChangedFaceInRoom:(PSUser *)aUser;
- (void)userChangedPropsInRoom:(PSUser *)aUser data:(NSData *)data;
- (void)userChangedDescriptionInRoom:(PSUser *)aUser data:(NSData *)data;
- (void)userDroppedPropInRoom:(PSUser *)aUser data:(NSData *)data;
@end
