//
//  AppDelegate.h
//  Mud Client Remote
//
//  Created by Gary Barnett on 9/27/13.
//  Copyright (c) 2013 gbcs. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
-(void)popToRoot;
-(void)showReviewRequestPage;
@end
