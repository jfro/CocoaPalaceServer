//
//  LogController.m
//  CocoaPServer
//
//  Created by Jeremy Knope on Tue Mar 23 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import "LogController.h"


@implementation LogController

- (void)setLogView:(id)theView {
	logView = theView;
}

- (void)writeToLog:(NSString *)aString {
   if ([[logView textStorage] length]) {
        [logView replaceCharactersInRange:NSMakeRange([[logView textStorage] length], 0) withString:@" \n"];
    }
    [logView replaceCharactersInRange:NSMakeRange([[logView textStorage] length], 0) withString:[[NSDate date] descriptionWithCalendarFormat:@"%I:%M %p" timeZone:nil locale:nil]];
    [logView replaceCharactersInRange:NSMakeRange([[logView textStorage] length], 0) withString:@" - "];
    [logView replaceCharactersInRange:NSMakeRange([[logView textStorage] length], 0) withString:aString];
    [logView scrollRangeToVisible:NSMakeRange([[logView textStorage] length], 0)];
    [logView display];
    
}

- (void)clearLog {
    [logView replaceCharactersInRange:NSMakeRange(0,[[logView textStorage] length]) withString:@""];
}

@end
