//
//  MainController.h
//  CocoaPServer
//
//  Created by Jeremy Knope on Tue Mar 23 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LogController.h"

@interface MainController : NSObject
{
    IBOutlet id logView;
    IBOutlet id statusField;
	LogController *log;
}
- (IBAction)openPreferencesWindow:(id)sender;
- (IBAction)startServer:(id)sender;
- (IBAction)stopServer:(id)sender;
@end
