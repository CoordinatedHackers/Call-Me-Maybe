//
//  CHAppDelegate.h
//  Call Me Maybe
//
//  Created by Sidney San Martín on 11/23/13.
//  Copyright (c) 2013 Coordinated Hackers. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CHAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) BOOL opened;

- (void)handleAppleEvent:(NSAppleEventDescriptor *)event withReplyEvent: (NSAppleEventDescriptor *)replyEvent;
- (void)checkLaunch;

@end
