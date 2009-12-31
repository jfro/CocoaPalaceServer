//
//  LogController.h
//  CocoaPServer
//
//  Created by Jeremy Knope on Tue Mar 23 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LogController : NSObject {
    IBOutlet id logView;
}

- (void)setLogView:(id)theView;
- (void)writeToLog:(NSString *)aString;
- (void)clearLog;
@end
