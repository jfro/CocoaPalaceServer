//
//  PSMansion.m
//  CocoaPServer
//
//  Created by Jeremy Knope on Sat Mar 13 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import "PSMansion.h"
#import "PSUser.h"
#import "PSRoom.h"
#import "PSApplication.h"
#import "PalaceProtocol.h"
#import "MansionScript.h"

@implementation PSMansion
- (id)init {
	if( !( self = [super init] ) )
		return nil;
	NSEnumerator *en;
	id obj;
	users = [[NSMutableDictionary alloc] init];
	rooms = [[NSMutableDictionary alloc] init];
	currentId = 1;
	script = [[MansionScript alloc] init];
	[script loadPrefs];
	// hard code room
	en = [[script rooms] objectEnumerator];
	while(obj = [en nextObject]) {
		PSRoom *aRoom = [[PSRoom alloc] init];
		[aRoom setRoomID:[[obj objectForKey:@"id"] intValue]];
		[aRoom setName:[obj objectForKey:@"name"]];
		[aRoom setPictureFilename:[obj objectForKey:@"pict"]];
		[aRoom setAuthor:[obj objectForKey:@"artist"]];
		[self addRoom:aRoom];
	}
	gateId = [script entrance];
	palaceName = [script serverName];
	return self;
}
- (void)setPalaceName:(NSString *)aName {
	palaceName = [aName retain];
}

- (NSString *)palaceName {
	return palaceName;
}

#pragma mark -
#pragma mark User related
- (int)addUser:(PSUser *)aUser {
	[users setObject:[aUser retain] forKey:[NSString stringWithFormat:@"%i",currentId]];
	//currentId++; // increment it, keeps us from re-using Ids that might be in use, easier this way for now
	return currentId++;
}

- (void)removeUser:(PSUser *)aUser {
	[users removeObjectForKey:[NSString stringWithFormat:@"%i",[aUser userID]]];
}

- (PSUser *)getUserWithId:(int)anId {
	return [users objectForKey:[NSString stringWithFormat:@"%i",anId]];
}

- (int)userCount {
	return [users count];
}

- (NSDictionary *)users {
	return users;
}

- (void)userLoggedOn:(PSUser *)aUser {
	//NSLog(@"*PSMansion:: Alerting all users of logon");
	NSEnumerator *en;
	id obj;
	
	en = [users objectEnumerator];
	while(obj = [en nextObject]) {
		[[[PSApplication sharedApplication] protocol] sendUserLogonToUser:obj who:aUser];
	}
}

- (void)userLoggedOff:(PSUser *)aUser {
	//NSLog(@"*PSMansion:: Alerting all users of logoff");
	NSEnumerator *en;
	id obj;
	[users removeObjectForKey:[NSString stringWithFormat:@"%i",[aUser roomID]]];
	en = [users objectEnumerator];
	while(obj = [en nextObject]) {
		[[[PSApplication sharedApplication] protocol] sendUserLogoffToUser:obj who:aUser];
	}
	[users removeObjectForKey:[NSString stringWithFormat:@"%i",[aUser userID]]];
}

#pragma mark -
#pragma mark Room related
- (RoomID)gateID {
	return gateId;
}

- (NSDictionary *)rooms {
	return rooms;
}

- (void)addRoom:(PSRoom *)aRoom {
	[rooms setObject:aRoom forKey:[NSString stringWithFormat:@"%i",[aRoom roomID]]];
}

- (PSRoom *)getRoomWithId:(int)anId {
	//NSLog(@"****** Getting room with ID: %i",anId);
	return [rooms objectForKey:[NSString stringWithFormat:@"%i",anId]];
}

- (void)userEnteredRoom:(PSUser *)aUser {
	PSRoom *room;
	NSEnumerator *en;
	id usr;
	//NSLog(@"+PSMansion:: %@ Entered a room",[aUser name]);
	room = [[[PSApplication sharedApplication] mansion] getRoomWithId:[aUser roomID]];
	[room addUser:aUser];
	en = [[room users] objectEnumerator];
	while(usr = [en nextObject]) {
		//NSLog(@"Sending userNew to: %@",[usr name]);
		[[[PSApplication sharedApplication] protocol] sendUserNewToUser:usr who:aUser];
	}
}

- (void)userExitedRoom:(PSUser *)aUser {
//	PSPacket *pack = [[PSPacket alloc] init];
	PSRoom *room;
	NSEnumerator *en;
	id usr;
	//NSLog(@"-PSMansion:: %@ Exited a room",[aUser name]);
	
	room = [[[PSApplication sharedApplication] mansion] getRoomWithId:[aUser roomID]];

	[room removeUser:aUser];
	en = [[room users] objectEnumerator];
	while(usr = [en nextObject]) {
		//NSLog(@"Sending USEREXIT to: %@",[usr name]);
		[[[PSApplication sharedApplication] protocol] sendUserExitToUser:usr who:aUser];
	}
}

- (void)userMovedInRoom:(PSUser *)aUser {
	PSRoom *room;
	NSEnumerator *en;
	id usr;
	//NSLog(@"-PSMansion:: %@ Moved in a room",[aUser name]);
	
	room = [[[PSApplication sharedApplication] mansion] getRoomWithId:[aUser roomID]];
	//NSLog(@"Going thru room users");
	//[room removeUser:aUser];
	en = [[room users] objectEnumerator];
	//NSLog(@"Got enumerator");
	while(usr = [en nextObject]) {
		if(![usr isEqualTo:aUser]) {
			NSLog(@"Sending MSG_USERMOVE to user: %@",[usr name]); 
			//NSLog(@"Sending USEREXIT to: %@",[usr name]);
			[[[PSApplication sharedApplication] protocol] sendUserMoveToUser:usr who:aUser];
		}
	}
}

- (void)userXTalkedInRoom:(PSUser *)aUser data:(NSData *)data {
	PSRoom *room;
	NSEnumerator *en;
	id usr;
	//NSLog(@"-PSMansion:: %@ Talked in a room",[aUser name]);
	
	room = [[[PSApplication sharedApplication] mansion] getRoomWithId:[aUser roomID]];
	//NSLog(@"Going thru room users");
	//[room removeUser:aUser];
	en = [[room users] objectEnumerator];
	//NSLog(@"Got enumerator");
	while(usr = [en nextObject]) {
		//NSLog(@"Sending MSG_USERMOVE to user: %@",[usr name]); 
		//NSLog(@"Sending USEREXIT to: %@",[usr name]);
		[[[PSApplication sharedApplication] protocol] sendXTalkToUser:usr who:[aUser userID] data:data];
	}
}

- (void)userChangedColorInRoom:(PSUser *)aUser {
	PSRoom *room;
	NSEnumerator *en;
	id usr;
	NSData *msg;
	sint16 *p;
	p = malloc(2);
	*p = [aUser colorNbr];
	msg = [[NSData alloc] initWithBytes:p length:2];
	room = [[[PSApplication sharedApplication] mansion] getRoomWithId:[aUser roomID]];

	en = [[room users] objectEnumerator];

	while(usr = [en nextObject]) {
		[[[PSApplication sharedApplication] protocol] sendPacketToSocket:[usr netSocket] withType:MSG_USERCOLOR withRefNum:[aUser userID] withMsg:msg];
	}
	//free(p);
}

- (void)userChangedFaceInRoom:(PSUser *)aUser {
	PSRoom *room;
	NSEnumerator *en;
	id usr;
	NSData *msg;
	sint16 *p;
	p = malloc(2);
	*p = [aUser faceNbr];
	msg = [[NSData alloc] initWithBytes:p length:2];
	room = [[[PSApplication sharedApplication] mansion] getRoomWithId:[aUser roomID]];

	en = [[room users] objectEnumerator];

	while(usr = [en nextObject]) {
		[[[PSApplication sharedApplication] protocol] sendPacketToSocket:[usr netSocket] withType:MSG_USERFACE withRefNum:[aUser userID] withMsg:msg];
	}
	//free(p);
}

// just props change
- (void)userChangedPropsInRoom:(PSUser *)aUser data:(NSData *)data {
	//AssetSpec *p;
	PSRoom *room;
	NSEnumerator *en;
	id usr;
	//UserRec *rec;
	//NSMutableData *msg;
	//rec = [aUser userRec];
	//msg = [[NSMutableData alloc] initWithBytes:rec->propSpec length:(9*sizeof(AssetSpec))];
	room = [[[PSApplication sharedApplication] mansion] getRoomWithId:[aUser roomID]];
	
	en = [[room users] objectEnumerator];
	
	while(usr = [en nextObject]) {
		if(![usr isEqualTo:aUser])
			[[[PSApplication sharedApplication] protocol] sendPacketToSocket:[usr netSocket] withType:MSG_USERPROP withRefNum:[aUser userID] withMsg:data];
	}
}

// props + color + face
- (void)userChangedDescriptionInRoom:(PSUser *)aUser data:(NSData *)data {
	//AssetSpec *p;
	PSRoom *room;
	NSEnumerator *en;
	id usr;
	//UserRec *rec;
	//NSMutableData *msg;
	//rec = [aUser userRec];
	//msg = [[NSMutableData alloc] initWithBytes:rec->propSpec length:(9*sizeof(AssetSpec))];
	room = [[[PSApplication sharedApplication] mansion] getRoomWithId:[aUser roomID]];
	
	en = [[room users] objectEnumerator];
	
	while(usr = [en nextObject]) {
		if(![usr isEqualTo:aUser])
			[[[PSApplication sharedApplication] protocol] sendPacketToSocket:[usr netSocket] withType:MSG_USERDESC withRefNum:[aUser userID] withMsg:data];
	}
}

- (void)userDroppedPropInRoom:(PSUser *)aUser data:(NSData *)data {
	PSRoom *room;
	NSEnumerator *en;
	id usr;
	
	room = [[[PSApplication sharedApplication] mansion] getRoomWithId:[aUser roomID]];
	
	en = [[room users] objectEnumerator];
	
	while(usr = [en nextObject]) {
		[[[PSApplication sharedApplication] protocol] sendPacketToSocket:[usr netSocket] withType:MSG_PROPNEW withRefNum:0 withMsg:data];
	}
}
@end
