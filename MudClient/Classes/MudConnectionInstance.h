//
//  MudConnectionInstance.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudClientIpad4ViewController.h"

@interface MudConnectionInstance : UIViewController < UIPopoverControllerDelegate>  {
	UIButton *connectionButton;
	UIButton *sessionButton;
	UIButton *transcriptButton;
	
	MudClientIpad4ViewController *topController;
	BOOL amConnected;
	NSTimer *timer;
}

@property (nonatomic, strong) UIButton *connectionButton;
@property (nonatomic, strong) UIButton *sessionButton;
@property (nonatomic, strong) UIButton *transcriptButton;

@property (nonatomic, strong) MudClientIpad4ViewController *topController;
@property (nonatomic) BOOL amConnected;
@property (nonatomic, strong) NSTimer *timer;

- (void)updateViewState:(id)sender;

@end
