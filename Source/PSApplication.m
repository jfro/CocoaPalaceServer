
//  GSApplication.m
//  GhettoChat Server
#import "PSApplication.h"
#import "NetSocket.h"
#import "PalaceProtocol.h"
#import "PSPacket.h"
//#import "PSClient.h"
#import "PSMansion.h"
#import "PSUser.h"

static PSApplication* sApplication = nil;

@implementation PSApplication

- (id)init
{
	if( ![super init] )
		return nil;
	
	if( !sApplication )
		sApplication = self;
	
	// Initialize some values
	mServerSocket = nil;
	//mClients = [[NSMutableArray alloc] initWithCapacity:20];
	myPro = [[PalaceProtocol alloc] init];
	[myPro retain];
	vers = 65558;
	mansion = [[PSMansion alloc] init];
	//[mansion setPalaceName:@"Test Palace"];
	return self;
}

- (void)dealloc
{
	if( sApplication == self )
		sApplication = nil;
	
	[super dealloc];
}

#pragma mark -

+ (PSApplication*)sharedApplication
{
	return sApplication;
}

#pragma mark -

- (uint32)version {
	return vers;
}

- (PalaceProtocol *)protocol {
	return myPro;
}

- (PSMansion *)mansion {
	return mansion;
}
- (void)serve
{
	mServerSocket = [[NetSocket netsocketListeningOnPort:9998] retain];
	[mServerSocket scheduleOnCurrentRunLoop];
	[mServerSocket setDelegate:self];
	
	NSLog( @"Palace Server: Waiting for connections..." );
}
/*
- (void)broadcastPacket:(PSPacket*)inPacket
{
	[self broadcastPacket:inPacket excludingClients:nil];
}

- (void)broadcastPacket:(PSPacket*)inPacket excludingClient:(PSClient*)inClient
{
	[self broadcastPacket:inPacket excludingClients:[NSArray arrayWithObject:inClient]];
}

- (void)broadcastPacket:(PSPacket*)inPacket excludingClients:(NSArray*)inClientsToExclude
{
	NSEnumerator*	clientEnumerator;
	PSClient*		client;
	NSData*			packetData;
	
	// Flatten packet
	//packetData = [PSPacket encodedPacket:inPacket compressed:NO];
	//if( !packetData )
	//	return;
	
	// Enumerate clients and send packet
	clientEnumerator = [mClients objectEnumerator];
	while( client = [clientEnumerator nextObject] )
	{
		if( [inClientsToExclude containsObject:client] )
			continue;
		
		[[client netSocket] writeData:packetData];
	}
}
*/
- (void)removeClient:(PSUser *)inUser
{
	//NSLog(@"Removing client");
	//[mClients removeObject:inClient];
	[mansion removeUser:inUser];
	NSLog(@"%@ logged off",[inUser name]);
	//NSLog(@"FIX");
}

#pragma mark -

- (void)netsocket:(NetSocket*)inNetSocket connectionAccepted:(NetSocket*)inNewNetSocket
{
	PSUser* user;
	int newId;
	NSLog(@"--------------------------------------");
	NSLog( @"Palace Server: New connection established" );
	user = [[[PSUser alloc] initWithNetSocket:inNewNetSocket] autorelease];
	[user setRoomID:[mansion gateID]];
	newId = [mansion addUser:user];
	NSLog(@"User gets ID: %i",newId);
	[user setUserID:newId];
	[myPro sendWelcomeToSocket:inNewNetSocket withId:newId];
	
	//[myPro sendServerInfoToSocket:inNewNetSocket];
	//[mClients addObject:client];
}

@end
