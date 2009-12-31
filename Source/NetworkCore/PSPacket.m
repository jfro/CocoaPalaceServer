//
//  PSPacket.m
//  CocoaPServer
//
//  Created by Jeremy Knope on Tue Mar 23 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import "PSPacket.h"
#import "Utilities.h"
#import "PalaceProtocol.h"

@implementation PSPacket
- (id)initWithData:(NSData *)aData {
	uint32 *ptr;
	if( !( self = [super init] ) )
		return nil;
	eventType = 0;
	length = 0;
	refNum = 0;
	//NSLog(@"Processing data: '%@' size: %i",[[NSString alloc] initWithData:aData encoding:NSASCIIStringEncoding],[aData length]);
	ptr = &eventType;
	[aData getBytes:ptr range:NSMakeRange(0,4)];
	if(eventType == MSG_LOGON)
		NSLog(@"User registration packet");
	//NSLog(@"Got type: %i",eventType);
	ptr = &length;
	[aData getBytes:ptr range:NSMakeRange(4,4)];
	ptr = &refNum;
	[aData getBytes:ptr range:NSMakeRange(8,4)];
	if(length > 0) {
		msg = [[aData subdataWithRange:NSMakeRange(12,length)] mutableCopy];
	}
	return self;	
}

- (void)setEventType:(uint32)aType {
	eventType = aType;
}

- (uint32)eventType {
	return eventType;
}

- (void)setLength:(uint32)aLen {
	length = aLen;
}

- (uint32)length {
	return length;
}

- (void)setRefNum:(uint32)aRef {
	refNum = aRef;
}

- (uint32)refNum {
	return refNum;
}

- (void)setMsgData:(NSData *)aData; {
	msg = [aData mutableCopy];
}

- (NSData *)msgData {
	return msg;
}

- (void)addToMsg:(const void *)buf length:(int)len {
	// adds buffer to msg data
	if(msg == nil)
		msg = [[NSMutableData alloc] init];
	[msg appendBytes:buf length:len];
}

- (NSData *)packetData { // 'raw' data, in NSData form, of packet
	//unsigned char * out;
	int size;
	uint32 * ptr;
	ptr = &eventType;
	NSMutableData *mData;
	
	size = sizeof(uint32)+sizeof(uint32)+sizeof(uint32);
	
	if(msg != nil)
		size = size + [msg length];
	//NSLog(@"Building packet of size: %i",size);
	//NSLog(@"Setting up NSData");
	mData = [[NSMutableData alloc] init]; // tried initWithCapacity
	//NSLog(@"Created NSData, appending data to it");
	if(msg != nil)
		length = [msg length]; // DUH this is better
	else
		length = 0;
	[mData appendBytes:ptr length:4];
	ptr = &length;
	[mData appendBytes:ptr length:4];
	ptr = &refNum;
	[mData appendBytes:ptr length:4];
	if(msg != nil) {
		[mData appendData:msg];
	}
	//NSLog(@"PSPacket built packet '%s' of size: %i",long2ascii(eventType),size);
	return mData;
}
@end
