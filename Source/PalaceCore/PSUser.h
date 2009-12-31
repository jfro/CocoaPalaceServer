//
//  PSUser.h
//  CocoaPServer
//
//  Created by Jeremy Knope on Sat Mar 13 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Structures.h"

@class PSPacket;
@class NetSocket;
@class PSUser;

@interface PSUser : NSObject {
	UserRec *userData;
	//NSString *userName;
	//uint32 userID;
	NetSocket *mSocket;
	//RoomID roomID;
	//sint16 nbrProps;
	//sint16 faceNbr;
	//sint16 colorNbr;
	//AssetSpec props[9];
	//Point pos;
}

- (id)initWithNetSocket:(NetSocket*)inNetSocket;
- (NetSocket*)netSocket;
- (void)processPacket:(PSPacket *)pack;

- (NSString *)name;
//- (void)setName:(NSString *)aName;

- (uint32)userID;
- (void)setUserID:(uint32)anId;

- (RoomID)roomID;
- (void)setRoomID:(RoomID)newId;

- (Point)location;
- (void)setLocation:(Point)newLoc;

- (sint16)faceNbr;
- (void)setFaceNbr:(sint16)face;

- (sint16)colorNbr;
- (void)setFaceNbr:(sint16)color;

- (UserRec *)userRec;

- (void)parseRegistrationBuffer:(NSData *)aData;
- (void)updateProps:(NSData *)data;
- (void)updateDescription:(NSData *)data;
@end
