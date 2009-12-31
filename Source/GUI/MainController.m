//
//  MainController.m
//  CocoaPServer
//
//  Created by Jeremy Knope on Tue Mar 23 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import "MainController.h"

@implementation MainController

- (void)awakeFromNib {
	log = [[LogController alloc] init];
	[log setLogView:logView];
	[log writeToLog:@"Main Controller awaking"];
}

- (IBAction)openPreferencesWindow:(id)sender
{
}

- (IBAction)startServer:(id)sender
{
}

- (IBAction)stopServer:(id)sender
{
}

@end
