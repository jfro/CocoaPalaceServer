//
//  PSClient.h
//  CocoaPServer
//
//  Created by Jeremy Knope on Tue Mar 23 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class PSApplication;
@class PSPacket;
@class NetSocket;
@class PSUser;

@interface PSClient : NSObject {
	NetSocket *mSocket;
	PSUser *usr;
}

- (id)initWithNetSocket:(NetSocket*)inNetSocket;
- (NetSocket*)netSocket;
- (void)processPacket:(PSPacket *)pack;
- (PSUser *)user;
@end
