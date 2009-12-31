//
//  PSUser.m
//  CocoaPServer
//
//  Created by Jeremy Knope on Sat Mar 13 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import "PSUser.h"
#import "Local.h"
//#import "Structures.h"
#import "Utilities.h"
#import "NetSocket.h"
#import "PSPacket.h"
#import "PalaceProtocol.h"
#import "PSApplication.h"
#import "PSMansion.h"
#import "PSRoom.h"

@implementation PSUser

- (id)initWithNetSocket:(NetSocket*)inNetSocket
{
	if( ![super init] )
		return nil;
	userData = malloc(sizeof(UserRec));
	if(userData == NULL)
		NSLog(@"Failed to allocate space for UserRec");
	//mNickname = nil;
	mSocket = [inNetSocket retain];
	
	// Setup socket for use
	[mSocket open];
	[mSocket scheduleOnCurrentRunLoop];
	[mSocket setDelegate:self];
	userData->roomPos.h = random()%480;
	userData->roomPos.v = random()%355;
	//pos.h = random()%480;
	//pos.v = random()%355;
	userData->colorNbr = 6;
	userData->faceNbr = 1;
	userData->nbrProps = 0;
	return self;
}

- (void)dealloc
{
	NSLog( @"Palace Server: Client released" );
	[mSocket release];
	//[mNickname release];
	free(userData);
	[super dealloc];
}
#pragma mark -

- (NSString *)name {
	char *temp;
	NSString *str;
	temp = p2c(userData->name);
	str = [[NSString alloc] initWithCString:temp];
	//NSLog(@"Freeing temp");
	free(temp);
	return str;
}
/*
- (void)setName:(NSString *)aName {
	userName = [aName retain];
}
*/
- (void)setUserID:(uint32)anId {
	userData->userID = anId;
}

- (uint32)userID {
	return userData->userID;
}

- (void)setRoomID:(RoomID)newId {
	userData->roomID = newId;
}

- (RoomID)roomID {
	return userData->roomID;
}


- (Point)location {
	return userData->roomPos;
}

- (void)setLocation:(Point)newLoc {
	userData->roomPos = newLoc;
}

- (sint16)faceNbr {
	return userData->faceNbr;
}

- (void)setFaceNbr:(sint16)face {
	userData->faceNbr = face;
}

- (sint16)colorNbr {
	return userData->colorNbr;
}

- (void)setColorNbr:(sint16)color {
	userData->colorNbr = color;
}

- (UserRec *)userRec {
	//UserRec *rec;
	//Point pos;
	//AssetSpec temp;
	//char *temp2;
	//int i;
	//char *p;
	
	//temp.id = 0;
	//temp.crc = 0;
	//pos.h = 20;
	//pos.v = 30;
	/* rec = malloc(sizeof(UserRec));
	if(rec == NULL) {
		printf("Failed to allocate space for UserRec in PSUser:userRec\n");
		exit(1);
	}
	rec->userID = userID;
	rec->roomPos = pos;
	//rec->propSpec = props;
	for(i = 0;i<9;i++) {
		rec->propSpec[i] = props[i];
	}
	rec->roomID = 1; // temporary
	rec->faceNbr = faceNbr;
	rec->colorNbr = colorNbr;
	rec->awayFlag = 0;
	rec->openToMsgs = 0;
	rec->nbrProps = nbrProps;
	//p = &rec->name;
	// *p = c2pPad([userName cString],32);
	c2pPad([userName cString],rec->name,32);
	temp2= p2c(rec->name);
	//NSLog(@"Built userRec for: %s",temp2);
	free(temp2); */
	return userData;
}

#pragma mark -

- (NetSocket*)netSocket
{
	return mSocket;
}

#pragma mark -
- (void)processPacket:(PSPacket *)pack {
	Point *p;
	sint16 *t;
	UserID *uid;
	//NSLog(@"Processing user packet");
	switch([pack eventType]) {
		case MSG_LOGON:
			//NSLog(@"+PSUser:: Processing Logon regi packet");
			[self parseRegistrationBuffer:[pack msgData]];
			// sendversion
			[[[PSApplication sharedApplication] protocol] sendVersionToSocket:mSocket version:65558];
			// sendserverInfo
			[[[PSApplication sharedApplication] protocol] sendServerInfoToSocket:mSocket];
			// senduserStatus
			[[[PSApplication sharedApplication] protocol] sendUserStatusToUser:self];
			// mansion.userLoggedOn
			[[[PSApplication sharedApplication] mansion] userLoggedOn:self];
			// sendhttpUrl
			[[[PSApplication sharedApplication] protocol] sendHttpUrlToUser:self];
			// sendRoomDesc
			[[[PSApplication sharedApplication] protocol] sendRoomDescriptionToUser:self];
			// sendRoomUserList
			[[[PSApplication sharedApplication] protocol] sendRoomUserListToUser:self];
			// sendEndRoomDesc
			[[[PSApplication sharedApplication] protocol] sendEndRoomDescriptionToUser:self];
			// mansion.userEnteredRoom
			[[[PSApplication sharedApplication] mansion] userEnteredRoom:self];
			break;
		case MSG_USERMOVE:
			//NSLog(@"User moved");
			p = malloc(4);
			[[pack msgData] getBytes:p];
			[self setLocation:*p];
			//NSLog(@"PSUser:: Telling PSMansion about user move");
			[[[PSApplication sharedApplication] mansion] userMovedInRoom:self];
			//NSLog(@"PSUser:: Freeing temp Point");
			free(p);
			//[self setLocation:*([[pack msgData] bytes])];
			break;
		case MSG_USERFACE:
			t = malloc(2);
			[[pack msgData] getBytes:t];
			userData->faceNbr = *t;
			free(t);
			[[[PSApplication sharedApplication] mansion] userChangedFaceInRoom:self];
			break;
		case MSG_USERCOLOR:
			t = malloc(2);
			[[pack msgData] getBytes:t];
			userData->colorNbr = *t;
			free(t);
			[[[PSApplication sharedApplication] mansion] userChangedColorInRoom:self];
			break;
		case MSG_USERPROP:
			[self updateProps:[pack msgData]];
			[[[PSApplication sharedApplication] mansion] userChangedPropsInRoom:self data:[pack msgData]];
			break;
		case MSG_USERDESC:
			[self updateDescription:[pack msgData]];
			[[[PSApplication sharedApplication] mansion] userChangedDescriptionInRoom:self data:[pack msgData]];
			break;
		case MSG_XTALK:
			//NSLog(@"%@ talked, userID: %i",[self name],[self userID]);
			[[[PSApplication sharedApplication] mansion] userXTalkedInRoom:self data:[pack msgData]];
			break;
		case MSG_XWHISPER:
			//NSLog(@"Whispering");
			uid = malloc(4);
			[[[pack msgData] subdataWithRange:NSMakeRange(0,4)] getBytes:uid];
			[[[PSApplication sharedApplication] protocol] sendPacketToSocket:[[[[PSApplication sharedApplication] mansion] getUserWithId:*uid] netSocket] withType:MSG_XWHISPER withRefNum:[self userID] withMsg:[[pack msgData] subdataWithRange:NSMakeRange(4,[[pack msgData] length]-4)]];
			[[[PSApplication sharedApplication] protocol] sendPacketToSocket:[self netSocket] withType:MSG_XWHISPER withRefNum:[self userID] withMsg:[[pack msgData] subdataWithRange:NSMakeRange(4,[[pack msgData] length]-4)]];
			free(uid);
			break;
		case MSG_PROPNEW:
			[[[[PSApplication sharedApplication] mansion] getRoomWithId:[self roomID]] addProp:[pack msgData]];
			[[[PSApplication sharedApplication] mansion] userDroppedPropInRoom:self data:[pack msgData]];
			break;
		case MSG_LOGOFF:
			//NSLog(@"User requesting logoff");
			[[[PSApplication sharedApplication] mansion] userExitedRoom:self];
			//[[PSApplication sharedApplication] removeClient:self];
			[[[PSApplication sharedApplication] mansion] userLoggedOff:self];
			[[self netSocket] close];
			break;
		default:
			NSLog(@"Unsupported packet '%s'",long2ascii([pack eventType]));
			break;
	}
}

#pragma mark -
- (void)parseRegistrationBuffer:(NSData *)aData {
	AuxRegistrationRec *reg;
	char *buf;
	//char *name;
	//name = malloc(32);
	buf = malloc([aData length]);
	//NSLog(@"Parsing reg");
	[aData getBytes:buf];
	reg = (AuxRegistrationRec *)buf;
	//NSLog(@"Test line coming");
	memcpy(userData->name,reg->userName,32);
	NSLog(@"%s logged on",p2c(reg->userName));
	//p2cstrcpy(name,reg->userName);
	//userName = [[NSString alloc] initWithCString:name];
	//free(name); // *FREE* maybe
	free(reg);
}

- (void)updateProps:(NSData *)data {
	sint16 *p;
	p = &userData->nbrProps;
	[data getBytes:p range:NSMakeRange(2,2)];
	//NSLog(@"PSUser:: Updating number of props: %i",*p);
	[[data subdataWithRange:NSMakeRange(4,[data length]-4)] getBytes:userData->propSpec];
}

- (void)updateDescription:(NSData *)data {
	sint16 *p;
	p = &userData->faceNbr;
	[data getBytes:p length:2];
	p = &userData->colorNbr;
	[data getBytes:p range:NSMakeRange(2,2)];
	p = &userData->nbrProps;
	[data getBytes:p range:NSMakeRange(6,2)]; // FIX packet has a long, UserRec has a short
	[data getBytes:userData->propSpec range:NSMakeRange(8,[data length]-8)];
}
#pragma mark -
#pragma mark NetSocket Related
- (void)netsocketDisconnected:(NetSocket*)inNetSocket
{
	NSLog( @"Palace Server: Client disconnected" );
	
	// Remove ourselves from the client list
	[[[PSApplication sharedApplication] mansion] userExitedRoom:self];
	[[[PSApplication sharedApplication] mansion] userLoggedOff:self];
	[[PSApplication sharedApplication] removeClient:self];
}

- (void)netsocket:(NetSocket*)inNetSocket dataAvailable:(unsigned)inAmount
{
	//NetPacket*		packet;
	//NSData*			packetData;
	//NetPacketSize	packetSize;
	//NSLog(@"->PSUser:: Data received, %i bytes",inAmount);
	PSPacket *mp;
	mp = [[PSPacket alloc] initWithData:[inNetSocket readData]];
	[self processPacket:mp];
	/*
	 while( [NetPacket packetAvailable:[inNetSocket peekData]] )
	 {
		 packetSize = [NetPacket packetHeaderSize] + [NetPacket packetSize:[inNetSocket peekData]];
		 packetData = [inNetSocket readData:packetSize];
		 if( !packetData )
			 break;
		 
		 packet = [NetPacket decodedPacket:packetData];
		 if( packet )
			 [self processPacket:packet];
	 }
	 */
}

- (void)netsocketDataSent:(NetSocket*)inNetSocket
{
	
}
@end
