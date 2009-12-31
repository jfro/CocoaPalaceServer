//
//  PSClient.m
//  CocoaPServer
//
//  Created by Jeremy Knope on Tue Mar 23 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import "PSApplication.h"
#import "PSClient.h"
#import "PalaceProtocol.h"
#import "NetSocket.h"
#import "PSPacket.h"
#import "PSUser.h"
#import "PSMansion.h"

@implementation PSClient
- (id)initWithNetSocket:(NetSocket*)inNetSocket
{
	if( ![super init] )
		return nil;
	
	//mNickname = nil;
	mSocket = [inNetSocket retain];
	
	// Setup socket for use
	[mSocket open];
	[mSocket scheduleOnCurrentRunLoop];
	[mSocket setDelegate:self];
	usr = [[PSUser alloc] init];
	return self;
}

- (void)dealloc
{
	NSLog( @"Palace Server: Client released" );
	[mSocket release];
	//[mNickname release];
	[super dealloc];
}

#pragma mark -

- (NetSocket*)netSocket
{
	return mSocket;
}

#pragma mark -

- (void)processPacket:(PSPacket *)pack {
	//NSLog(@"Processing user packet");
	switch([pack eventType]) {
		case MSG_LOGON:
			NSLog(@"Logon regi packet");
			[usr parseRegistrationBuffer:[pack msgData]];
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
			[[[PSApplication sharedApplication] protocol] sendRoomDescriptionTouser:self];
			// sendRoomUserList
			[[[PSApplication sharedApplication] protocol] sendRoomUserListToUser:self];
			// sendEndRoomDesc
			[[[PSApplication sharedApplication] protocol] sendEndRoomDescriptionToUser:self];
			// mansion.userEnteredRoom
			
			break;
		case MSG_USERMOVE:
			NSLog(@"User moved");
			break;
		default:
			NSLog(@"Unsupported packet '%s'",long2ascii([pack eventType]));
			break;
	}
}

- (PSUser *)user {
	return usr;
}
#pragma mark -

- (void)netsocketDisconnected:(NetSocket*)inNetSocket
{
	//PSPacket*	packet;
	
	NSLog( @"Palace Server: Client disconnected" );
	
	// Create client disconnected packet
	//packet = [NetPacket packetWithType:GSPacketTypeClientDisconnected];
	
	// Add packet object
	//[packet setObject:mNickname forKey:GSPacketKeyNickname];
	
	// Broadcast packet
	//[[PSApplication sharedApplication] broadcastPacket:packet excludingClient:self];
	
	// Remove ourselves from the client list
	[[PSApplication sharedApplication] removeClient:self];
}

- (void)netsocket:(NetSocket*)inNetSocket dataAvailable:(unsigned)inAmount
{
	//NetPacket*		packet;
	//NSData*			packetData;
	//NetPacketSize	packetSize;
	NSLog(@"Data received, %i bytes",inAmount);
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
