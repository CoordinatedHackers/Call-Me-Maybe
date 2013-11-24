//
//  CHAppDelegate.m
//  Call Me Maybe
//
//  Created by Sidney San Martín on 11/23/13.
//  Copyright (c) 2013 Coordinated Hackers. All rights reserved.
//

#import "CHAppDelegate.h"
NSString *urlEncode(NSDictionary *formDict) {
    NSMutableString *encodedString = [NSMutableString new];
    __block BOOL firstVal = YES;
    [formDict enumerateKeysAndObjectsUsingBlock: ^void(NSString *key, NSString *value, BOOL *stop) {
        if (firstVal) {
            firstVal = NO;
        } else {
            [encodedString appendString:@"&"];
        }
        [encodedString appendFormat:@"%@=%@",
            [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]],
            [value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]
        ];
    }];
    return encodedString;
}

@implementation CHAppDelegate

- (void)awakeFromNib
{
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(handleAppleEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication*) app
{
    return YES;
}

- (void)checkLaunch
{
    if (self.opened) return;

    [self.window center];
    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
    [NSApp activateIgnoringOtherApps:YES];
    [self.window makeKeyAndOrderFront:nil];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[self performSelector:@selector(checkLaunch) withObject:nil afterDelay:0.3];
}

- (void)handleAppleEvent:(NSAppleEventDescriptor *)event withReplyEvent: (NSAppleEventDescriptor *)replyEvent
{
    self.opened = YES;
    NSString* url = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.pushover.net/1/messages.json"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];
    
    NSString *APP_TOKEN = [[[NSUserDefaultsController sharedUserDefaultsController] defaults] stringForKey:@"APIKey"];
    NSString *USER_KEY = [[[NSUserDefaultsController sharedUserDefaultsController] defaults] stringForKey:@"UserKey"];
    
    NSDictionary *fields = @{
      @"token": APP_TOKEN,
      @"user": USER_KEY,
      @"message": @"Your phone number, Sir.",
      @"url_title": [NSString stringWithFormat:@"Click to call %@", url],
      @"url": url
    };

    [request setHTTPBody:[urlEncode(fields) dataUsingEncoding: NSUTF8StringEncoding]];
    
    NSLog(@"%@",
          [[NSString alloc]
                initWithData: [NSURLConnection
                        sendSynchronousRequest:request  returningResponse:nil
                                        error:nil]
                encoding:NSUTF8StringEncoding]);
    
    [[NSApplication sharedApplication] terminate:nil];
}

@end
