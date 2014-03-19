//
//  MudInputFooter.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MudSession.h"

@interface MudInputFooter : UIView <UITextViewDelegate>	{
	UIButton *inputHistoryButton;
	UITextView	 *inputTextView;
	NSObject *topController;
	NSTimer *timer;
	UIButton *inputSendAgainButton;
	UIButton *reconnectButton;
	UIButton *greenButton;
	UIButton *redButton;
	UIButton *connectionButton;
	UIButton *settingsButton;
	UIButton *connect1;
	UIButton *connect2;
	UIButton *connect3;
	UIButton *connect4;
	UILabel *lastCommandLabel;
    UIButton *speedwalkingButton;
    UIButton *touchableTextsButton;
	UIButton *aliasEditButton;
	UIButton *variableEditButton;
	UIButton *triggerEditButton;
	UIButton *macroEditButton;
}

@property (nonatomic, strong) UIButton *inputHistoryButton;
@property (nonatomic, strong) UITextView *inputTextView;
@property (nonatomic, strong) NSObject *topController;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIButton *inputSendAgainButton;
@property (nonatomic, strong) UIButton *reconnectButton;
@property (nonatomic, strong) UIButton *greenButton;
@property (nonatomic, strong) UIButton *redButton;
@property (nonatomic, strong) UIButton *connectionButton;
@property (nonatomic, strong) UIButton *settingsButton;
@property (nonatomic, strong) UIButton *connect1;
@property (nonatomic, strong) UIButton *connect2;
@property (nonatomic, strong) UIButton *connect3;
@property (nonatomic, strong) UIButton *connect4;
@property (nonatomic, strong) UIButton *speedwalkingButton;
@property (nonatomic, strong) UIButton *touchableTextsButton;


-(void)updateReconnectState:(int)newState session:(MudSession *)session;
-(void)updateOrientation:(BOOL)isPortrait;
-(void)UpdateConnectionButtons;
-(void)processLine:(NSString *)theLine;
-(void)processLineFromRemote:(NSString *)thisLine;
@end
