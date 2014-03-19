//
//  MudSettings.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 7/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MudClientIpad4ViewController.h"


@interface MudSettings : UIViewController <UITextFieldDelegate>  {
	MudClientIpad4ViewController *topController;
	UISwitch *buttonBarsEnabled;
	UISwitch *buttonEdit;
	UISwitch *buttonShowTypedInput;
	UISwitch *buttonShowMacroOutput;
	UISwitch *swapColors;
	UISwitch *swapLineEndings;
	
	
	UISwitch *sessionData;
	UISwitch *dataCompression;

	UILabel *header;
	UISwitch *bottomInputBar;
	NSMutableArray *labelList;
	UISwitch *largerInputArea;
	UILabel *versionLabel;
	UILabel *supportLabel;
	UIButton *supportButton;
	UIButton *headerButton;
	UIButton *keyboardReset;
	UITextField *commandSeparator;
}


@property (nonatomic, strong) MudClientIpad4ViewController *topController;
@property (nonatomic, strong) UISwitch *buttonBarsEnabled;
@property (nonatomic, strong) UISwitch *buttonEdit;
@property (nonatomic, strong) UISwitch *buttonShowTypedInput;
@property (nonatomic, strong) UISwitch *buttonShowMacroOutput;
@property (nonatomic, strong) UISwitch *swapColors;
@property (nonatomic, strong) UISwitch *swapLineEndings;
@property (nonatomic, strong) UISwitch *sessionData;
@property (nonatomic, strong) UISwitch *dataCompression;
@property (nonatomic) int defaultColor;
@property (nonatomic, strong) NSMutableArray *labelList;
@property (nonatomic, strong) UISwitch *largerInputArea;

-(void)dataCompressionSwitch:(id)sender;
-(void)buttonBarsEnabledSwitch:(id)sender;
-(void)buttonShowTypedInputSwitch:(id)sender;
-(void)buttonShowMacroOutputSwitch:(id)sender;
-(void)buttonEditSwitch:(id)sender;
-(void)buttonSwapColorsSwitch:(id)sender;
-(MudDataSettings *)getSettingsRecord;

-(void)sessionDataSwitch:(id)sender;
-(void)updateViews;
-(void)positionViews:(UIInterfaceOrientation)forOrientation offScreen:(BOOL)offScreen;
-(void)createViews;
@end
