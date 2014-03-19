//
//  MudClientIpad4ViewController.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 6/29/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MudDataCharacters.h"
#import "MudSession.h"
#import "MudInputFooter.h"
#import "introPage.h"



@interface MudClientIpad4ViewController : UIViewController <UIPopoverControllerDelegate, UITextFieldDelegate, UITableViewDelegate> {
	
	NSManagedObjectContext *context;									// Reference to the core data context
	
	UITableView *displayTableView;										// Tableview where active session text is shown
	
	UIView *buttonPanel;												// The buttons and related code (not button editor)
	
	int buttonEditMode;													// System is in button-edit (1) or button-active mode (0)
	
	UITextField *txtFromUser;											// User's text entry bar

	UIButton *inputHistoryButton;										// Button for Previous Commands popover
	
	UIBarButtonItem *MudPickButton;										// Calls MudAddConnections (character entry/connect-to interface)
	UIBarButtonItem *HelpButton;
    
	UIToolbar *mainToolbar;												// Main toolbar (always present)
	
	UIWindow *window;													// Our window, the source of all
	
	UIBarButtonItem *MudSpacer;											// Spacer button (between connected character list and static edit buttons on right 
	UIBarButtonItem *MudVr;												// Variable popover
	UIBarButtonItem *MudTr;												// Trigger popover
	UIBarButtonItem *MudMa;												// Macro popover
	UIBarButtonItem *MudSe;												// Settings popover
    UIBarButtonItem *MudSp;												// Speedwalking
	UIBarButtonItem *MudTt;												// Touchable Texts
    
    
	UIBarButtonItem *connectionButton1;									// Connection #1 Button holder
	UIBarButtonItem *connectionButton2;									// Connection #2 Button holder	
	UIBarButtonItem *connectionButton3;									// Connection #3 Button holder
	UIBarButtonItem *connectionButton4;									// Connection #4 Button holder
	
	MudSession *mudSession1;											// Session object for this connection
	MudSession *mudSession2;											// Session object for this connection
	MudSession *mudSession3;											// Session object for this connection
	MudSession *mudSession4;											// Session object for this connection
	
	int MudActiveIndex;													// Currently active (being viewed) connection. 

	UIPopoverController *mudVarPopoverController;						// Variables
	UIViewController *mudVariables;
	
	UIPopoverController *mudTriggerPopoverController;					// Triggers
	UIViewController *mudTriggers;

	UIPopoverController *mudMacroPopoverController;						// Macros
	UIViewController *mudMacros;
	
	UIPopoverController *mudButtonPopoverController;					// Buttons
	UIViewController *mudButtons;
	
	//UIPopoverController *mudSettingPopoverController;					// Settings
	UIViewController *mudSettings;
	BOOL settingsActive;

	UIPopoverController *mudPreviousCommandsPopoverController;			// Previous Commands
	UIViewController *mudPreviousCommands;
	
	UIPopoverController *mudAddConnectionPopoverController;				// Characters
	UIViewController *mudAddConnections;
	
	UIPopoverController *mudConnectionInstancePopoverController;		// Connected Button Dropdown
	UIViewController *mudConnectionInstance;

	UIPopoverController *landscapeConnectionPopoverController;					// Settings
	UIViewController *landscapeConnection;

    UIPopoverController *mudSpeedwalkingPopoverController;					// Speedwalking
	UIViewController *mudSpeedwalking;
    
    UIPopoverController *mudTouchableTextsPopoverController;					// Touchable Texts
	UIViewController *mudTouchableTexts;
	
	MudInputFooter *footer;												//Input history button and input bar view
	
	introPage *iPage;

}
@property(nonatomic,strong)   UIBarButtonItem *HelpButton;
@property(nonatomic,strong)   UIBarButtonItem *MudPickButton;
@property(nonatomic,strong)   UIToolbar *mainToolbar;

@property(nonatomic, strong) UIBarButtonItem *connectionButton1;
@property(nonatomic, strong) UIBarButtonItem *connectionButton2;
@property(nonatomic, strong) UIBarButtonItem *connectionButton3;
@property(nonatomic, strong) UIBarButtonItem *connectionButton4;

@property(nonatomic, strong) MudSession *mudSession1;
@property(nonatomic, strong) MudSession *mudSession2;
@property(nonatomic, strong) MudSession *mudSession3;
@property(nonatomic, strong) MudSession *mudSession4;

@property(nonatomic, strong) UIBarButtonItem *MudSpacer;
@property(nonatomic, strong) UIBarButtonItem *MudVr;
@property(nonatomic, strong) UIBarButtonItem *MudTr;
@property(nonatomic, strong) UIBarButtonItem *MudMa;
@property(nonatomic, strong) UIBarButtonItem *MudSe;
@property(nonatomic, strong) UIBarButtonItem *MudSp;
@property(nonatomic, strong) UIBarButtonItem *MudTt;
@property(nonatomic, strong) UIBarButtonItem *MudAl;

@property(nonatomic)  int MudActiveIndex;

@property (nonatomic, strong) UIPopoverController *mudVarPopoverController;
@property (nonatomic, strong) UIViewController *mudVariables;

@property (nonatomic, strong) UIPopoverController *mudTriggerPopoverController;
@property (nonatomic, strong) UIViewController *mudTriggers;

@property (nonatomic, strong) UIPopoverController *mudMacroPopoverController;
@property (nonatomic, strong) UIViewController *mudMacros;

@property (nonatomic, strong) UIPopoverController *mudButtonPopoverController;
@property (nonatomic, strong) UIViewController *mudButtons;

@property (nonatomic, strong) UIPopoverController *mudPreviousCommandsPopoverController;
@property (nonatomic, strong) UIViewController *mudPreviousCommands;

@property (nonatomic, strong) UIPopoverController *mudSettingPopoverController;
@property (nonatomic, strong) UIViewController *mudSettings;

@property (nonatomic, strong) UIPopoverController *mudAddConnectionPopoverController;
@property (nonatomic, strong) UIViewController *mudAddConnections;

@property (nonatomic, strong) UIPopoverController *landscapeConnectionPopoverController;					// Settings
@property (nonatomic, strong) UIViewController *landscapeConnection;

@property (nonatomic, strong) NSManagedObjectContext *context;

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) UITableView *displayTableView;

@property (nonatomic, strong) UIView *buttonPanel;

@property (nonatomic, strong)	UIViewController *mudConnectionInstance;
@property (nonatomic, strong) UIPopoverController *mudConnectionInstancePopoverController;


@property (nonatomic, strong) UIPopoverController *mudSpeedwalkingPopoverController;
@property (nonatomic, strong) UIViewController *mudSpeedwalking;

@property (nonatomic, strong) UIPopoverController *mudTouchableTextsPopoverController;
@property (nonatomic, strong) UIViewController *mudTouchableTexts;

@property (nonatomic, strong) UIPopoverController *mudAliasPopoverController;
@property (nonatomic, strong) UIViewController *mudAliases;

@property (nonatomic, strong) NSObject *footer;


@property (nonatomic) int buttonEditMode;
@property (nonatomic) BOOL settingsActive;
-(void)updateDisplayForTeleEvent;
-(void)mudSpeedwalkingClickedLandscape:(id)sender;
-(void)mudTouchableTextsClickedLandscape:(id)sender;
-(void)mudVariablesClicked:(id)sender;
-(void)mudTriggersClicked:(id)sender;
-(void)mudMacrosClicked:(id)sender;
-(void)mudAliasesClickedLandscape:(id)sender;
-(void)mudVariablesClickedLandscape:(id)sender;
-(void)mudTriggersClickedLandscape:(id)sender;
-(void)mudMacrosClickedLandscape:(id)sender;
-(void)mudSettingsClicked:(id)sender;
-(void)mudAddConnectionsClicked:(id)sender;
-(void)mudConnectionInstanceClicked:(id)sender;
-(void)buildMainToolbar;
-(void)dismissPopovers;
-(BOOL)checkForPreviousCommandsExistance:(NSString *)cmd;
-(void)loadConnectionUserInterface;
-(void)switchToWindow:(int)windowNumber newConnection:(BOOL)newConnection;
-(void)connectionRequest:(MudDataCharacters *)selectedCharacter;
-(void)connectionDestroy:(int)connectionIndex;
- (void)destroyConnectionUserInterface;
- (CGRect)figureFrameBounds:(int)whichComponent sessionSettings:(MudDataSettings *)settings;
- (CGRect)figureFrameBoundsPortrait:(int)whichComponent sessionSettings:(MudDataSettings *)settings;
- (CGRect)figureFrameBoundsLandscape:(int)whichComponent sessionSettings:(MudDataSettings *)settings;
- (void)adjustViewSizes:(MudDataSettings *)settings;
-(void)mudConnectionInstanceClickedLandscape:(int)SenderofClick;
-(void)updateViewsForOrientation:(BOOL)orientationIsPortrait;
-(void)updateForRemoteKeyboard;
-(void)updateViewsForFeatureChange;
@end

