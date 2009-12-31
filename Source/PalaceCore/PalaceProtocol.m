/*
 *  PalaceProtocol.m
 *  CocoaPServer
 *
 *  Created by Jeremy Knope on Tue Mar 23 2004.
 *  Copyright (c) 2004 JfroWare. All rights reserved.
 *  Code taken from Palace's packet source/documentation
 */

#import "PalaceProtocol.h"
#import "NetSocket.h"
#import "PSUser.h"
#import "PSPacket.h"
#import "PSUser.h"
#import "PSApplication.h";
#import "PSMansion.h"
#import "Structures.h"
#import "PSRoom.h"
#import "Utilities.h"

@implementation PalaceProtocol
- (void)sendWelcomeToSocket:(NetSocket *)aSock withId:(uint32)anId {
	PSPacket *np;
	np = [[PSPacket alloc] init];
	[np setEventType:MSG_TIYID];
	[np setLength:0];
	[np setRefNum:anId];
	[aSock writeData:[np packetData]];
}
- (void)sendVersionToSocket:(NetSocket *)aSock version:(uint32)vers {
	// send's version packet
	PSPacket *np;
	np = [[PSPacket alloc] init];
	[np setEventType:MSG_VERSION];
	[np setLength:0];
	[np setRefNum:vers];
	[aSock writeData:[np packetData]];
}
- (void)sendServerInfoToSocket:(NetSocket *)aSock {
	ServerInfoRec *sinf;
	PSPacket *pack;
	//NSMutableData *data;
	//uint32 *p;
	//const char *c;
	//Str63 temp;
	
	pack = [[PSPacket alloc] init];
	[pack setEventType:MSG_SERVERINFO];
	[pack setLength:sizeof(ServerInfoRec)];
	[pack setRefNum:0];
	sinf = malloc(sizeof(ServerInfoRec));
	sinf->serverPermissions = 0x00002E3F;
	c2pPad([[[[PSApplication sharedApplication] mansion] palaceName] cString],sinf->serverName,64); // sinf->serverName
	sinf->serverOptions = 0;
    sinf->ulUploadCaps = 0;
    sinf->ulDownloadCaps = 0;
	NSLog(@"Sending PalaceName: %s",sinf->serverName);
	[pack addToMsg:sinf length:sizeof(ServerInfoRec)];
	/*
	p = malloc(sizeof(uint32));
	if(p == NULL) {
		printf("Failed to allocate temp pointer to uint32 in sendServerInfoToSocket:\n");
		exit(1);
	}
	
	data = [[NSMutableData alloc] init];
	*p = 0x00002E3F;
	[data appendBytes:p length:4];
	*p = 0;
	[data appendBytes:p length:4];
	[data appendBytes:p length:4];
	[data appendBytes:p length:4];
	c = malloc([[[[PSApplication sharedApplication] mansion] palaceName] cStringLength]);
	if(c == NULL) {
		printf("Failed to allocate space for string in sendServerInfoToSocket:\n");
		exit(1);
	}
	c = [[[[PSApplication sharedApplication] mansion] palaceName] cString];
	//[data appendBytes:c2pPad((char *)c,63) length:64];
	c2pPad(c,temp,64);
	[data appendBytes:temp length:64];
	[pack setMsgData:data];
	 */
	[aSock writeData:[pack packetData]];
	//sinf->serverPermissions = 0x00002E3F;
	//sinf->serverOptions = 0;
    //sinf->ulUploadCaps = 0;
    //sinf->ulDownloadCaps = 0;
	//sinf->serverName = (Str63 *)c2p([[[[PSApplication sharedApplication] mansion] palaceName] cString]);
}

- (void)sendUserStatusToUser:(PSUser *)aUser {
	PSPacket *pack;
	NSData *d;
	uint32 *p;
	p = malloc(sizeof(uint32));
	if(p == NULL) {
		printf("Failed to allocate space for uint32 in sendUserStatusToUser:\n");
		exit(1);
	}
	*p = 0x0000;
	d = [[NSData alloc] initWithBytes:p length:4];
	pack = [[PSPacket alloc] init];
	[pack setEventType:MSG_USERSTATUS];
	[pack setLength:4];
	[pack setRefNum:[aUser userID]];
	[pack setMsgData:d];
	[[aUser netSocket] writeData:[pack packetData]];
}

- (void)sendUserLogonToUser:(PSUser *)aUser who:(PSUser *)newUser {
	PSPacket *pack;
	//NSData *d;
	uint32 *p;
	
	p = malloc(sizeof(uint32));
	if(p == NULL) {
		printf("Failed to allocate space for uint32 in sendUserLogonToUser:\n");
		exit(1);
	}
	*p = [[[PSApplication sharedApplication] mansion] userCount];
	//NSLog(@"Sending userLog with userCount: %i",*p);
	//d = [[NSData alloc] initWithBytes:p length:4];
	pack = [[PSPacket alloc] init];
	[pack setEventType:MSG_USERLOG];
	[pack setLength:4]; // 4 bytes long
	[pack setRefNum:[newUser userID]]; // who logged on
	[pack addToMsg:p length:4];
	//[pack setMsgData:d];
	// now build a NSData of # of current users
	[[aUser netSocket] writeData:[pack packetData]];
}

- (void)sendUserLogoffToUser:(PSUser *)aUser who:(PSUser *)newUser {
	PSPacket *pack;
	NSData *d;
	uint32 *p;
	
	p = malloc(sizeof(uint32));
	if(p == NULL) {
		printf("Failed to allocate space for uint32 in sendUserLogonToUser:\n");
		exit(1);
	}
	*p = [[[PSApplication sharedApplication] mansion] userCount];
	//NSLog(@"Sending userLog with userCount: %i",*p);
	d = [[NSData alloc] initWithBytes:p length:4];
	pack = [[PSPacket alloc] init];
	[pack setEventType:MSG_LOGOFF];
	[pack setLength:4]; // 4 bytes long
	[pack setRefNum:[newUser userID]]; // who logged on
	[pack setMsgData:d];
	// now build a NSData of # of current users
	[[aUser netSocket] writeData:[pack packetData]];
}

- (void)sendHttpUrlToUser:(PSUser *)aUser {
	NSData *data;
	PSPacket *pack = [[PSPacket alloc] init];
	NSString *url = @"http://zeratul.ath.cx/palace/";
	//NSLog(@"Sending url: '%s'",[url cString]);
	data = [[NSData alloc] initWithBytes:[url cString] length:([url cStringLength]+1)];
	[pack setEventType:MSG_HTTP];
	[pack setLength:([url cStringLength]+1)];
	[pack setRefNum:0];
	[pack setMsgData:data];
	[[aUser netSocket] writeData:[pack packetData]];
}
#pragma mark -
#pragma mark Room Related
- (void)sendRoomDescriptionToUser:(PSUser *)aUser {
	RoomRec *room;
	PSRoom *oroom;
	PSPacket *pack;
	//int c; // tmep count var
	char *temp;
	
	oroom = [[[PSApplication sharedApplication] mansion] getRoomWithId:[aUser roomID]]; // hard code room id 1 for now
	pack = [[PSPacket alloc] init];
	[pack setEventType:MSG_ROOMDESC];
	[pack setRefNum:0];
	
	room = malloc(sizeof(RoomRec));
	if(room == NULL) {
		printf("Failed to allocate temp memory for RoomRec in sendRoomDescription\n");
		exit(1);
	}
	room->roomFlags = 0;
	room->facesID = 0;
	room->roomID = [oroom roomID];
	room->roomNameOfst = 0; // start at 0
	room->pictNameOfst = [[oroom name] cStringLength]+1; // plus the count byte... kinda same as + null byte, has to be pstring tho
	room->artistNameOfst = [[oroom pictureFilename] cStringLength]+1;
	room->passwordOfst = [[oroom author] cStringLength]+1; // we'll have no pass be a null byte at the end
	room->nbrHotspots = 0;
	room->hotspotOfst = 0;
	room->nbrPictures = 0;
	room->pictureOfst = 0;
	room->nbrDrawCmds = 0;
	room->firstDrawCmd = 0;
	room->nbrPeople = [oroom userCount];
	room->nbrLProps = 0;
	room->firstLProp = 0;
	room->reserved = 0;
	room->lenVars = ([[oroom name] cStringLength]+1)+([[oroom pictureFilename] cStringLength]+1)+([[oroom author] cStringLength]+1)+1; // 1 little null for password
	[pack addToMsg:room length:sizeof(RoomRec)];
	[pack addToMsg:c2p([[oroom name] cString]) length:([[oroom name] cStringLength]+1)];
	[pack addToMsg:c2p([[oroom pictureFilename] cString]) length:([[oroom pictureFilename] cStringLength]+1)];
	[pack addToMsg:c2p([[oroom author] cString]) length:([[oroom author] cStringLength]+1)];
	temp = malloc(1); // don't feel like checking this, hope 1 byte doesn't fail!
	*temp = 0;
	[pack addToMsg:temp length:1];
	[pack setLength:(sizeof(RoomRec)+([[oroom name] cStringLength]+1)+([[oroom pictureFilename] cStringLength]+1)+([[oroom author] cStringLength]+1)+1)];
	[[aUser netSocket] writeData:[pack packetData]];
}

- (void)sendRoomUserListToUser:(PSUser *)aUser {
	PSPacket *pack = [[PSPacket alloc] init];
	PSRoom *room;
	UserRec *rec;
	NSEnumerator *en;
	id u;
	
	room = [[[PSApplication sharedApplication] mansion] getRoomWithId:[aUser roomID]];
	
	[pack setEventType:MSG_USERLIST];
	//NSLog(@"PalaceProtocol:: Sending room user count: %i",[room userCount]);
	//[pack setLength:[room userCount]];
	[pack setRefNum:[room userCount]];
	en = [[room users] objectEnumerator];
	while(u = [en nextObject]) {
		rec = [u userRec];
		[pack addToMsg:rec length:sizeof(UserRec)];
		//NSLog(@"Freeing temp rec
		//free(rec); // *FREE* maybe
	}
	//NSLog(@"<- PalaceProtocol:: Sending room user list to %@",[aUser name]);
	[[aUser netSocket] writeData:[pack packetData]];
}

- (void)sendEndRoomDescriptionToUser:(PSUser *)aUser {
	PSPacket *pack = [[PSPacket alloc] init];
	[pack setEventType:MSG_ROOMDESCEND];
	[pack setLength:0];
	[pack setRefNum:0];
	// send it
	[[aUser netSocket] writeData:[pack packetData]];
}
#pragma mark -
#pragma mark User Actions
- (void)sendUserNewToUser:(PSUser *)aUser who:(PSUser *)newUser {
	PSPacket *pack = [[PSPacket alloc] init];
	UserRec *rec;
	
	[pack setEventType:MSG_USERNEW];
	[pack setRefNum:[newUser userID]];
	[pack setLength:sizeof(UserRec)];
	rec = [newUser userRec];
	[pack addToMsg:rec length:sizeof(UserRec)];
	//free(rec); // *FREE* maybe
	[[aUser netSocket] writeData:[pack packetData]];
}

- (void)sendUserExitToUser:(PSUser *)aUser who:(PSUser *)newUser {
	PSPacket *pack = [[PSPacket alloc] init];
	[pack setEventType:MSG_USEREXIT];
	[pack setRefNum:[newUser userID]];
	//[pack setLength:0];
	[[aUser netSocket] writeData:[pack packetData]];
}

- (void)sendUserMoveToUser:(PSUser *)aUser who:(PSUser *)newUser {
	PSPacket *pack = [[PSPacket alloc] init];
	Point *p;
	p = malloc(sizeof(Point));
	[pack setEventType:MSG_USERMOVE];
	[pack setRefNum:[newUser userID]];
	*p = [newUser location];
	[pack addToMsg:p length:sizeof(Point)];
	[[aUser netSocket] writeData:[pack packetData]];
	//free(p);
	[pack release];
}

- (void)sendXTalkToUser:(PSUser *)aUser who:(UserID)uid data:(NSData *)data {
	PSPacket *pack = [[PSPacket alloc] init];
	[pack setEventType:MSG_XTALK];
	[pack setRefNum:uid];
	[pack setMsgData:data];
	
	[[aUser netSocket] writeData:[pack packetData]];
	[pack release];
}

- (void)sendPacketToSocket:(NetSocket *)sock withType:(uint32)type withRefNum:(uint32)ref withMsg:(NSData *)data {
	PSPacket *pack = [[PSPacket alloc] init];
	[pack setEventType:type];
	[pack setRefNum:ref];
	[pack setMsgData:data];
	[sock writeData:[pack packetData]];
	[pack release];
}
@end