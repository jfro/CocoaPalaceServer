//
//  ServerMain.h
//  CocoaPServer
//
//  Created by Jeremy Knope on Tue Mar 23 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetSocket.h"

@interface ServerMain : NSObject {
	NetSocket *listenSock;
}

@end
