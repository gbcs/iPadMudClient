//
//  AppDelegate.m
//  Mud Client Remote
//
//  Created by Gary Barnett on 9/27/13.
//  Copyright (c) 2013 gbcs. All rights reserved.
//

#import "AppDelegate.h"
#import "NavViewController.h"
#import "MenuViewController.h"

@implementation AppDelegate {
    MenuViewController  *menuVC;
    NavViewController *navVC;
}

-(void)popToRoot {
    [navVC popToRootViewControllerAnimated:YES];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    [self.window setTintColor:[UIColor blackColor]];
    
    BOOL landscape = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
    BOOL isiPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    
    NSString *nibStr = @"MenuViewController";
    if (landscape) {
        nibStr = [nibStr stringByAppendingString:@"Landscape"];
    }
    
    if (isiPad) {
        nibStr = [nibStr stringByAppendingString:@"iPad"];
    }
    
    MenuViewController *vc = [[MenuViewController alloc] initWithNibName:nibStr bundle:nil];
    navVC = [[NavViewController alloc] initWithRootViewController:vc];
    
    [self.window setRootViewController:navVC];
   
    [self.window makeKeyAndVisible];
    
    [self updateUseCounter];
    
    return YES;
}

-(void)updateUseCounter {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL neverAsk = [[defaults objectForKey:@"neverAskReview"] boolValue];
    BOOL reviewed = [[defaults objectForKey:@"hasReviewed"] boolValue];
    
    
    int count = [[defaults objectForKey:@"useCounter"] intValue];
    count++;
    
    [defaults setObject:[NSNumber numberWithInteger:count] forKey:@"useCounter"];
    [defaults synchronize];
    
    if (reviewed) {
        return;
    }
    
    if ( (!neverAsk) && (count > 10)) {
        [self performSelector:@selector(askForReview) withObject:nil afterDelay:3.0];
        count = 0;
        [defaults setObject:[NSNumber numberWithInt:count] forKey:@"useCounter"];
    }
    
    [defaults synchronize];
}

-(void)askForReview {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Review Request" message:@"Please write a review." delegate:self cancelButtonTitle:@"Maybe Later" otherButtonTitles:@"Write Review", @"No Thanks",  nil];
    [alert show];
}

-(void)showReviewRequestPage {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@""]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"alertidx:%ld", (long)buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
            //maybe later
        }
            break;
        case 1:
        {
            //write review
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@YES forKey:@"hasReviewed"];
            [defaults synchronize];
            [self showReviewRequestPage];
        }
            break;
        case 2:
        {
            // no thanks
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@YES forKey:@"neverAskReview"];
            [defaults synchronize];
            
        }
            break;
    }
}


-(void)startRemote {
    [[RemoteClient tool] startSession];
    [[RemoteClient tool] startBrowser];
}

-(void)stopRemote {
    [[RemoteClient tool] stopBrowser];
    [[RemoteClient tool] stopSession];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self stopRemote];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [self startRemote];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
