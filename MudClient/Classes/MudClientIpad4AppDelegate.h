//
//  MudClientIpad4AppDelegate.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 6/29/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MudDataSettings.h"
#import "Reachability.h"
#import "MudMacrosDetail.h"
#import "MudSession.h"
#import "TeleViewController.h"
#import "MudAliasesDetail.h"

@class MudClientIpad4ViewController;

@interface MudClientIpad4AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MudClientIpad4ViewController *viewController;
	NSManagedObjectContext *context;
    BOOL softwareKeyboardSeen;
	int keyboardWentHidden;
	int	internetStatus;	 // 0 - down, 1 - wifi, 2=3g;
	MudMacrosDetail *mudMacrosDetail;
	Reachability *internetReach;
	NSOperationQueue *opQueue;
	NSMutableArray *mudCharArray;
	int textWindowHeight;
	int textWindowWidth;
	UIWebView *webView;
    BOOL backgroundSupported;
    
    UIWindow *mirroredWindow;
}
@property (nonatomic, strong) TeleViewController *teleVC;
@property (nonatomic, assign) BOOL tvReady;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) MudClientIpad4ViewController *viewController;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic) BOOL softwareKeyboardSeen;
@property (nonatomic) int keyboardWentHidden;
@property (nonatomic) int internetStatus;
@property (nonatomic, strong) Reachability *internetReach;
@property (nonatomic, strong) MudMacrosDetail *mudMacrosDetail;
@property (nonatomic, strong) NSOperationQueue *opQueue;
@property (nonatomic, strong) NSMutableArray *mudCharArray;
@property (nonatomic) int textWindowHeight;
@property (nonatomic) int textWindowWidth;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, assign) BOOL backgroundSupported;
@property (nonatomic, strong) MudAliasesDetail *aliasDetail;
@property (nonatomic, strong) UINavigationController *navController;

-(void)keyboardWillShow:(id)sender;
-(void)keyboardWillHide:(id)sender;
-(MudSession *)getActiveSessionRef;
-(void)createInitialCharacterData:(MudDataCharacters *)char1;
-(void) initCoreData;
-(void)PullRecordsforCharList;
-(int)findNewSlotID;
-(void)pointToDefaultKeyboardResponder;
-(void)saveCoreData;
-(UIColor *)computeColorForSlider:(int)color;
-(UIColor *)computeBackgroundColorForSlider:(int)color;
-(void)dismissPopovers;
-(NSArray *)getSessionListForRemote;
@end

