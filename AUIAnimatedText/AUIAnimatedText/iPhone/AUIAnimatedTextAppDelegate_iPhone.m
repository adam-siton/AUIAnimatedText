//
//  AUIAnimatedTextAppDelegate_iPhone.m
//  AUIAnimatedText
//
//  Created by Adam Siton on 9/20/11.
//  Copyright 2011 Any.do. All rights reserved.
//

#import "AUIAnimatedTextAppDelegate_iPhone.h"
#import "RootViewController.h"

@implementation AUIAnimatedTextAppDelegate_iPhone

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    RootViewController *rootController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    self.window.rootViewController = rootController;
    [rootController release];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc
{
	[super dealloc];
}

@end
