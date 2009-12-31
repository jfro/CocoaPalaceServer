/*
 *  PalaceProtocol.h
 *  CocoaPServer
 *
 *  Created by Jeremy Knope on Tue Mar 23 2004.
 *  Copyright (c) 2004 JfroWare. All rights reserved.
 *  Code taken from Palace's packet source/documentation
 */

#import <Foundation/Foundation.h>

@class PSUser;
@class NetSocket;
#import "Structures.h"

#pragma mark -
#pragma mark Protocol Defines
/*////// Message //////// Number ////// String //// Server //////////////// Client ///////////// Description /////////////////////// */

#define MSG_SERVERDOWN      0x646f776eL  /* 'down'          *                                                                                                                                                                       // Server is going down */
#define MSG_SERVERUP        0x696e6974L  /* 'init'          *                                                                                                                                                        // Server is going up */
#define MSG_SERVERINFO		0x73696e66   /* 'sinf'			Server Info Packet 7/25/95 */
#define MSG_LOGON           0x72656769L  /* 'regi'          * <name> 
// <sign on> */

/* 1/23/97 JAB - for clients which provide the Alternate Logon Record, the server
uses this event to reply, allowing the server to change timeout values, resolve
conflicts, etc.  */
#define MSG_ALTLOGONREPLY	0x72657032L	 /* 'rep2' */

#define MSG_LOGOFF          0x62796520L  /* 'bye '          * &id,&totalPeople              *                                                                                       // <sign off> */
#define MSG_VERSION         0x76657273L  /* 'vers'          *                                                                                                                                                                               // Mansion Version Number */
#define MSG_HTTP			0x48545450L  /* 'HTTP' */
#define MSG_DIYIT           0x72796974L  /* 'ryit */
#define MSG_TIYID           0x74697972L  /* 'tiyr'          *                                                                                                                                                                       // This is your id# */

#define MSG_PING            0x70696e67L  /* 'ping'          * &userID                                                       *                                                                                       // Used to see if server is there */
#define MSG_PONG            0x706f6e67L  /* 'pong'          * &userID                                                       *                                                                                       // response to ping */

#define MSG_TALK            0x74616c6bL  /* 'talk'          * msg[]                                                         * msg[]                                                         // talk (if preceded by :) indicates thought */
#define MSG_WHISPER         0x77686973L  /* 'whis'          * msg[]                                                         * targeID,msg[]                         // whisper */
#define MSG_XTALK           0x78746c6bL  /* 'xtlk' */
#define MSG_XWHISPER        0x78776973L  /* 'xwis' */
#define MSG_DRAW            0x64726177L  /* 'draw'                                                                                                  *       drawRecord                                      // Add drawing command to object layer (or blow up) */
#define MSG_USERNEW         0x6e707273L  /* 'nprs' */
#define MSG_USERLOG         0x6c6f6720L  /* 'log '          *                                                                                                                                                                       // &id user logged on &totalPeople */
#define MSG_USERMOVE        0x754c6f63L  /* 'uLoc'          *                                                                                                                                                                       // User has changed position (id,Point) */
#define MSG_USERCOLOR       0x75737243L  /* 'usrC'          * &userRec                                              * &UserRec                                              // <change user parameters */
#define MSG_USERFACE        0x75737246L  /* 'usrF'          * short faceNbr * short faceNbr                         // <change user face> */
#define MSG_USERNAME        0x7573724eL  /* 'usrN'          * name[]                                                        * name[]                                                        // New user name */

#define MSG_USERENTER       0x77707273L  /* 'wprs'          *                                                                                                                                                                       // New Person in Current Room (&UserRec) */
#define MSG_USEREXIT        0x65707273L  /* 'eprs'                  *                                                                                                                                                                       // &id Person is leaving your Room */
#define MSG_USERLIST        0x72707273L  /* 'rprs'          *                                                                                                                                                                       // Room Person Descriptions (Array of UserRecs) */
#define MSG_USERPROP        0x75737250L  /* 'usrP'          *                                                                                                                                                                       // <change user prop> prop */
#define MSG_USERDESC        0x75737244L  /* 'usrD' */

#define MSG_ROOMNEW         0x6e526f6dL  /* 'nRom'                                                                                                  *                                                                                       // new Room request */
#define MSG_ROOMGOTO        0x6e617652L  /* 'navR'                                                                                                  * &roomID                                               // navigation to new room */
#define MSG_ROOMSETDESC     0x73526f6dL  /* 'sRom'                                                                                                  *       roomdesc                                                // set room description */
#define MSG_ROOMDESC        0x726f6f6dL  /* 'room'          *                                                                                                                                                                  // Current Room Description (&RoomRec) */
#define MSG_ROOMDESCEND     0x656e6472L  /* 'endr'          *                                                                                                                                                                       // End Room Description */

#define MSG_LISTOFALLROOMS  0x724c7374L  /* 'rLst'  6/9/95 */
#define MSG_LISTOFALLUSERS	0x754c7374L  /* 'uLst'  6/9/95 */

#define MSG_DOORLOCK        0x6c6f636bL  /* 'lock'          * &roomID,&doorID                       * &roomID,&doorID                       // Lock Door */
#define MSG_DOORUNLOCK      0x756e6c6fL  /* 'unlo'          * &roomID,&doorID                       * &roomID,&doorID                       // Unlock Door */

#define MSG_SPOTSTATE       0x73537461L  /* 'sSta'          * &room,&spot,&state    * &room,&spot,&state    // update state (and possibly picture) for hotspot */

#define MSG_ASSETNEW        0x61417374L  /* 'aAst'          *                                                                                                                                                                       // Acknowledge Asset - provides type and ID#, sent in response to user->'rAst' */
#define MSG_ASSETSEND       0x73417374L  /* 'sAst'    *                                                                                                                                                                     // Send Asset - provides asset to user. */
#define MSG_ASSETREGI       0x72417374L  /* 'rAst'                          *       ....                // */
#define MSG_ASSETQUERY      0x71417374L  /* 'qAst'    *     ....                                                            * ....                // */
#define MSG_FILEQUERY	    0x7146696cL  /* 'qFil' */
#define MSG_FILESEND        0x7346696cL  /* 'sFil' */

#define MSG_PROPNEW         0x6e507270L  /* 'nPrp' */
#define MSG_PROPMOVE        0x6d507270L  /* 'mPrp' */
#define MSG_PROPDEL         0x64507270L  /* 'dPrp' */
#define MSG_PROPSETDESC     0x73507270L  /* 'sPrp' */

#define MSG_SPOTNEW         0x6f70536eL  /* 'nSpo'                                                                                                  *                                                                                       // new spot request */
#define MSG_SPOTMOVE        0x636f4c73L  /* 'sLoc'          * &room,&stpo,&loc              * &room,&spot,&loc              // update spot location */
#define MSG_SPOTDEL         0x6f705364L  /* 'dSpo'                                                                                                  *       &spotID                                                 // Delete Spot */
#define MSG_SPOTSETDESC     0x6f705373L  /* 'sSpo'                                                                                                  * spotdesc                                              // set spot description */

#define MSG_PICTNEW         0x6e506374L  /* 'nPct' */
#define MSG_PICTMOVE        0x704c6f63L  /* 'pLoc' */
#define MSG_PICTDEL         0x46505371L  /* 'dPct' */
#define MSG_PICTSETDESC     0x73506374L  /* 'sPct' */
#define MSG_SUPERUSER       0x73757372L  /* 'susr'     * password */
#define MSG_KILLUSER        0x6b696c6cL  /* 'kill'     * id */
#define MSG_INITCONNECTION  0x634c6f67L  /*  cLog' */
#define MSG_USERSTATUS      0x75537461L  /* 'uSta' */
#define MSG_BLOWTHRU		0x626c6f77L  /* blow  1/30/96 */

#define MSG_NAVERROR       0x73457272L  /* 'sErr'   server error - such as navigation refused */

#pragma mark -

@interface PalaceProtocol : NSObject {
	
}
- (void)sendWelcomeToSocket:(NetSocket *)aSock withId:(uint32)anId;
- (void)sendVersionToSocket:(NetSocket *)aSock version:(uint32)vers;
- (void)sendServerInfoToSocket:(NetSocket *)aSock;
- (void)sendUserStatusToUser:(PSUser *)aUser;
- (void)sendUserLogonToUser:(PSUser *)aUser who:(PSUser *)newUser;
- (void)sendUserLogoffToUser:(PSUser *)aUser who:(PSUser *)newUser;
- (void)sendHttpUrlToUser:(PSUser *)aUser;
- (void)sendRoomDescriptionToUser:(PSUser *)aUser;
- (void)sendRoomUserListToUser:(PSUser *)aUser;
- (void)sendEndRoomDescriptionToUser:(PSUser *)aUser;
- (void)sendUserNewToUser:(PSUser *)aUser who:(PSUser *)newUser;
- (void)sendUserExitToUser:(PSUser *)aUser who:(PSUser *)newUser;
- (void)sendUserMoveToUser:(PSUser *)aUser who:(PSUser *)newUser;
- (void)sendXTalkToUser:(PSUser *)aUser who:(UserID)uid data:(NSData *)data;
- (void)sendPacketToSocket:(NetSocket *)sock withType:(uint32)type withRefNum:(uint32)ref withMsg:(NSData *)data;
@end
