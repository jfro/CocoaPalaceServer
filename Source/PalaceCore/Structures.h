/*
 *  Structures.h
 *  CocoaPServer
 *
 *  Created by Jeremy Knope on Sun Mar 21 2004.
 *  Copyright (c) 2004 JfroWare. All rights reserved.
 *
 */

#import "Local.h"

typedef struct {
	unsigned LONG	crc;		/* 1/14/97 JAB changed to unsigned */
	unsigned LONG	counter;	/* 1/14/97 JAB changed to unsigned */
	Str31			userName;
	Str31			wizPassword;
	LONG			auxFlags;
	unsigned LONG	puidCtr;
	unsigned LONG	puidCRC;
	unsigned LONG	demoElapsed;
	unsigned LONG	totalElapsed;
	unsigned LONG	demoLimit;
	short	desiredRoom;
	char	reserved[6];
	/* 1/27/97 Kevin Hazzard's Requested Changes */
// HIWORD is major, LOWORD is minor
	unsigned long ulRequestedProtocolVersion;
	unsigned long ulUploadCaps;
	unsigned long ulDownloadCaps;
	unsigned long ul2DEngineCaps;
	unsigned long ul2DGraphicsCaps;
	unsigned long ul3DEngineCaps;
} AuxRegistrationRec;

typedef sint32 UserID;
typedef sint16 RoomID;

typedef struct {
    sint32 id;
    uint32 crc;
} AssetSpec;

typedef struct {
    UserID userID;
    Point  roomPos;
    AssetSpec propSpec[9];
    RoomID roomID;
    sint16 faceNbr;
    sint16 colorNbr;
    sint16 awayFlag;
    sint16 openToMsgs;
    sint16 nbrProps;
    Str31  name;
} UserRec;

typedef struct {
    sint32 roomFlags;
    sint32 facesID;
    sint16 roomID;
    sint16 roomNameOfst;
    sint16 pictNameOfst;
    sint16 artistNameOfst;
    sint16 passwordOfst;
    sint16 nbrHotspots;
    sint16 hotspotOfst;
    sint16 nbrPictures;
    sint16 pictureOfst;
    sint16 nbrDrawCmds;
    sint16 firstDrawCmd;
    sint16 nbrPeople;
    sint16 nbrLProps;
    sint16 firstLProp;
    sint16 reserved;
    sint16 lenVars;
    //uint8  varBuf[lenVars];
} RoomRec;

typedef struct {
    sint16 nextOfst;
    sint16 reserved;
} LLRec;

typedef struct {
    LLRec     link;
    AssetSpec propSpec;
    sint32    flags;
    sint32    refCon;
    Point     loc;
} LPropRec;

typedef struct {
    sint32 serverPermissions;
    Str63  serverName;
    uint32 serverOptions;
    uint32 ulUploadCaps;
    uint32 ulDownloadCaps;
} ServerInfoRec;

typedef struct {
    sint32 scriptEventMask;
    sint32 flags;
    sint32 secureInfo;
    sint32 refCon;
    Point  loc;
    sint16 id;
    sint16 dest;
    sint16 nbrPts;
    sint16 ptsOfst;
    sint16 type;
    sint16 groupID;
    sint16 nbrScripts;
    sint16 scriptRecOfst;
    sint16 state;
    sint16 nbrStates;
    sint16 stateRecOfst;
    sint16 nameOfst;
    sint16 scriptTextOfst;
    sint16 alignReserved;
} HotSpot;