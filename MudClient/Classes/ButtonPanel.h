//
//  ButtonPanel.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MudClientIpad4ViewController.h"
#import "MudDataButtons.h"

@interface ButtonPanel : UIView {

	int currentLayer;
	MudClientIpad4ViewController *topController;
	NSMutableArray *buttons;
	NSArray *iconImages;
	int landscapeMode;
	BOOL wasHeld;
	NSTimer *holdTimer;
	UIButton *heldButton;
	int clickSequence;
}

@property (nonatomic) int currentLayer;
@property (nonatomic, strong) MudClientIpad4ViewController *topController;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSArray *iconImages;
@property (nonatomic) int landscapeMode;
@property (nonatomic, assign) BOOL remote;

- (void)drawButtons;
- (void)buttonClick:(id)sender;
- (void)populateButtons;
- (void) launchButton:(MudDataButtons *)button layer:(NSInteger)layer;

- (void) populateButtonsLandscape;
- (void) populateButtonsPortrait;
- (void) clearButtons;
- (void) drawButtonsLandscape;
- (void) drawButtonsPortrait;
- (void)editRemoteButtonAtIndex:(NSInteger *)index;

@end
 