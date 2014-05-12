//
//  AtomAppDelegate.m
//  Song
//
//  Created by Mac Wang on 5/7/14.
//  Copyright (c) 2014 Kansas State University. All rights reserved.
//

#import "AtomAppDelegate.h"

@implementation AtomAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}


//completely close the app with close button
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}
@end
