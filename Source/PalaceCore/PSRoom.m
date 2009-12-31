//
//  PSRoom.m
//  CocoaPServer
//
//  Created by Jeremy Knope on Sat Mar 13 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import "PSRoom.h"
#import "PSUser.h"

@implementation PSRoom
- (id)init {
	if( !( self = [super init] ) )
		return nil;
	users = [[NSMutableArray alloc] init];
	looseProps = [[NSMutableArray alloc] init];
	script = [[NSString alloc] init];
	return self;
}
- (sint16)roomID {
	return roomID;
}

- (void)setRoomID:(sint16)anId {
	roomID = anId;
}

- (NSString *)name {
	return name;
}

- (void)setName:(NSString *)aName {
	name = [aName retain];
}

- (NSString *)author {
	return author;
}

- (void)setAuthor:(NSString *)anAuthor {
	author = [anAuthor retain];
}

- (NSString *)pictureFilename {
	return pictureFilename;
}

- (void)setPictureFilename:(NSString *)aFile {
	pictureFilename = [aFile retain];
}

- (NSString *)script {
	return script;
}

- (void)setScript:(NSString *)scr {
	script = [scr retain];
}

#pragma mark -
#pragma mark User related
- (void)addUser:(PSUser *)aUser {
	[users addObject:aUser];
}
- (void)removeUser:(PSUser *)aUser {
	[users removeObject:aUser];
}
- (sint16)userCount {
	return [users count];
}

- (NSArray *)users {
	return users;
}
#pragma mark -
#pragma mark Loose Props
- (void)addProp:(NSData *)asset {
	[looseProps addObject:asset];
}

- (int)propCount {
	return [looseProps count];
}

- (NSArray *)looseProps {
	return looseProps;
}
@end
