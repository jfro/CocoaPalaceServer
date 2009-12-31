//
//  PSPacket.h
//  CocoaPServer
//
//  Created by Jeremy Knope on Tue Mar 23 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdlib.h>
#include <string.h>

//struct ClientMsg {
//	 uint32 eventType;   /* 32-bit opcode */
//	 uint32 length;      /* length of message body */
//	 sint32 refNum;      /* arbitrary integer operand */
//	 uint8  msg[length]; /* message body */
//}
 
@interface PSPacket : NSObject {
	uint32 eventType;
	uint32 length;
	uint32 refNum;
	NSMutableData *msg;
}

- (id)initWithData:(NSData *)aData;
- (void)setEventType:(uint32)aType;
- (uint32)eventType;
- (void)setLength:(uint32)aLen;
- (uint32)length;
- (void)setRefNum:(uint32)aRef;
- (uint32)refNum;
- (void)setMsgData:(NSData *)aData;
- (NSData *)msgData;
- (void)addToMsg:(const void *)buf length:(int)len;
- (NSData *)packetData; // returns the data for the packet
@end
