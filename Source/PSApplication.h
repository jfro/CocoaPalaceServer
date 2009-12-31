
//  GSApplication.h
//  GhettoChat Server
#import <Foundation/Foundation.h>

@class NetSocket;
@class PSUser;
@class PalaceProtocol;
@class PSPacket;
@class PSMansion;

@interface PSApplication : NSObject 
{
	NetSocket*			mServerSocket;
	//NSMutableArray*		mClients;
	PalaceProtocol*		myPro;
	uint32				vers; // version for version packet
	PSMansion*			mansion;
}

+ (PSApplication*)sharedApplication;

- (uint32)version;
- (PalaceProtocol *)protocol;
- (PSMansion *)mansion;
- (void)serve;
/*- (void)broadcastPacket:(PSPacket*)inPacket;
- (void)broadcastPacket:(PSPacket*)inPacket excludingClient:(PSClient*)inClient;
- (void)broadcastPacket:(PSPacket*)inPacket excludingClients:(NSArray*)inClientsToExclude;*/
- (void)removeClient:(PSUser*)inUser;

@end
