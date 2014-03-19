//
//  MudClientIpad4AppDelegate.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 6/29/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MudClientIpad4AppDelegate.h"
#import "MudClientIpad4ViewController.h"

#import "MudDataCharacters.h"
#import "MudDataVariables.h"
#import "MudDataMacros.h"
#import "MudDataTriggers.h"
#import "MudDataSettings.h"
#import "MudDataButtons.h"
#import "MudMacrosStep.h"
#import "Reachability.h"
#import "MudInputFooter.h"
#import "MudMacros.h"
#import "MudSession.h"
#import "MudDataMacroSteps.h"
#import "Macros.h"
#import "nvtLine.h"




@implementation MudClientIpad4AppDelegate

@synthesize window;
@synthesize viewController;
@synthesize context;
@synthesize softwareKeyboardSeen;
@synthesize keyboardWentHidden;
@synthesize internetStatus;
@synthesize internetReach;
@synthesize mudMacrosDetail;
@synthesize opQueue;
@synthesize mudCharArray;
@synthesize textWindowHeight;
@synthesize textWindowWidth;
@synthesize webView;
@synthesize backgroundSupported;
@synthesize tvReady;
@synthesize teleVC;
@synthesize aliasDetail;

-(void)dismissPopovers {
    [viewController dismissPopovers];
}

- (void) saveCoreData {
	NSError* error;
	if(![self.context save:&error]) {
		NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
		NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
		if(detailedErrors != nil && [detailedErrors count] > 0) {
			for(NSError* detailedError in detailedErrors) {
				NSLog(@"  DetailedError: %@", [detailedError userInfo]);
			}
		}
		else {
			NSLog(@"  %@", [error userInfo]);
		}
	}
	
}


-(UIColor *)computeColorForSlider:(int)color  {
	UIColor *thisColor = nil;
	
	switch (color) {
		case aColorBlack:
			thisColor = [UIColor blackColor];
			break;
		case aColorRed:
			thisColor = [UIColor redColor];
			break;
		case aColorGreen:
			thisColor = [UIColor greenColor];
			break;
		case aColorYellow:
			thisColor = [UIColor yellowColor];
			break;
		case aColorBlue:
			thisColor =  [UIColor blueColor];
			break;
		case aColorMagenta:
			thisColor = [UIColor magentaColor];
			break;
		case aColorCyan:
			thisColor = [UIColor cyanColor];
			break;
		case aColorWhite:
			thisColor = [UIColor whiteColor];
			break;
		case bColorBlack:
			thisColor =[UIColor colorWithWhite:0.5f alpha:0.8f];
			break;
		case bColorRed:
			thisColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.8];
			break;
		case bColorGreen:
			thisColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.8];
			break;
		case bColorYellow:
			thisColor =  [UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:0.8];
			break;
		case bColorBlue:
			thisColor =[UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.8];
			break;
		case bColorMagenta:
			thisColor = [UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:0.8];
			break;
		case bColorCyan:
			thisColor = [UIColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:0.8];
			break;
		case bColorWhite:
			thisColor = [UIColor colorWithWhite:1.0 alpha:0.7];
			break;
			
	}
	
	return thisColor;
}

-(UIColor *)computeBackgroundColorForSlider:(int)color  {
	UIColor *thisColor = nil;
	
	if (color < 4) {
		switch (color) {
			case 0:
				thisColor = [UIColor blackColor];
				break;
			case 1:
				thisColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
				break;
			case 2:
				thisColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
				break;
			case 3:
				thisColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
				break;
		}
	} else if (color < 8) {
		switch (color-4) {
			case 0:
				thisColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.1f];
				break;
			case 1:
				thisColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.3f];
				break;
			case 2:
				thisColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.5f];
				break;
			case 3:
				thisColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.7f];
				break;
		}
	} else if (color < 12) {
		switch (color-8) {
			case 0:
				thisColor = [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:0.1f];
				break;
			case 1:
				thisColor = [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:0.3f];
				break;
			case 2:
				thisColor = [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:0.5f];
				break;
			case 3:
				thisColor = [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:0.7f];
				break;
		}
	} else {
		switch (color-12) {
			case 0:
				thisColor = [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:0.1f];
				break;
			case 1:
				thisColor = [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:0.3f];
				break;
			case 2:
				thisColor = [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:0.5f];
				break;
			case 3:
				thisColor = [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:0.7f];
				break;
		}
	}
	
	
	return thisColor;
}





-(NSArray *)getSessionListForRemote {
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)myAppDelegate.viewController;
    
    NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:4];
    
    if (displayView.mudSession1) {
        [list addObject:@{ [[[displayView.mudSession1.connectionData objectID] URIRepresentation] absoluteString] : displayView.connectionButton1.title }];
    }
    
    if (displayView.mudSession2) {
        [list addObject:@{ [[[displayView.mudSession2.connectionData objectID] URIRepresentation] absoluteString] : displayView.connectionButton2.title }];
    }
 
    if (displayView.mudSession3) {
        [list addObject:@{ [[[displayView.mudSession3.connectionData objectID] URIRepresentation] absoluteString] : displayView.connectionButton3.title }];
    }
    
    if (displayView.mudSession4) {
        [list addObject:@{ [[[displayView.mudSession4.connectionData objectID] URIRepresentation] absoluteString] : displayView.connectionButton4.title }];
    }
    
    return [list copy];
}

-(MudSession *)getActiveSessionRef {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudClientIpad4ViewController *displayView = (MudClientIpad4ViewController *)myAppDelegate.viewController;
	
	
	switch (displayView.MudActiveIndex) {
		case 1:
			return displayView.mudSession1;
		case 2:
			return displayView.mudSession2;
		case 3:
			return displayView.mudSession3;
		case 4:
			return displayView.mudSession4;
	}
	
	return nil;

}

-(void)createInitialCharacterData:(MudDataCharacters *)char1 {
		
	/*
	MudDataCharacters *char1 = (MudDataCharacters *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataCharacters" inManagedObjectContext:self.context];
	char1.serverTitle = @"Circle";
	char1.hostName = @"192.168.31.145";
	char1.tcpPort = [NSNumber numberWithInt:4000];
	char1.slotID = [NSNumber numberWithInt:1];
	char1.characterName	= @"admin";
	char1.password = @"dg2000";
	*/
	
	MudDataVariables *var1 = (MudDataVariables *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataVariables" inManagedObjectContext:self.context];
	[var1 setTitle:@"monster"];
	[var1 setId:[NSNumber numberWithInt:1]];
	[var1 setSlotID:char1];
	[var1 setCurrentValue:@""];
	

	MudDataMacros *macro1 = (MudDataMacros *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataMacros" inManagedObjectContext:self.context];
	[macro1 setTitle:@"*automatic login (name)"];
	[macro1 setId:[NSNumber numberWithInt:1]];
	[macro1 setSlotID:char1];
	
	MudDataMacroSteps *step1 = (MudDataMacroSteps *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataMacroSteps" inManagedObjectContext:self.context];
	[step1 setDelay:[NSNumber numberWithInt:1.0]];
	[step1 setFirstVariable:nil];
	[step1 setSecondVariable:nil];
	[step1 setValue1:@"$1"];
	[step1 setFormatVariableList:@"-10"];
	[step1 setMacroID:macro1];
	[step1 setStep:[NSNumber numberWithInt:1]];
	[step1 setCommand:[NSNumber numberWithInt:mMacroCommandSendFormattedTextServer]];

	
	
	MudDataMacros *macro2 = (MudDataMacros *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataMacros" inManagedObjectContext:self.context];
	[macro2 setTitle:@"*automatic login (password)"];
	[macro2 setId:[NSNumber numberWithInt:2]];
	[macro2 setSlotID:char1];
	
	MudDataMacroSteps *step2 = (MudDataMacroSteps *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataMacroSteps" inManagedObjectContext:self.context];
	[step2 setFirstVariable:nil];
	[step2 setSecondVariable:nil];
	[step2 setValue1:@"$1"];
	[step2 setFormatVariableList:@"-11"];
	[step2 setMacroID:macro2];
	[step2 setStep:[NSNumber numberWithInt:1]];
	[step2 setCommand:[NSNumber numberWithInt:mMacroCommandSendFormattedTextServer]];
	
	MudDataMacros *macro3 = (MudDataMacros *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataMacros" inManagedObjectContext:self.context];
	[macro3 setTitle:@"look"];
	[macro3 setId:[NSNumber numberWithInt:3]];
	[macro3 setSlotID:char1];
	
	MudDataMacroSteps *step3 = (MudDataMacroSteps *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataMacroSteps" inManagedObjectContext:self.context];
	[step3 setFirstVariable:var1];
	[step3 setSecondVariable:nil];
	[step3 setValue1:@"1"];
	[step3 setFormatVariableList:nil];
	[step3 setMacroID:macro3];
	[step3 setStep:[NSNumber numberWithInt:1]];
	[step3 setCommand:[NSNumber numberWithInt:mMacroCommandModVarMacroArgument]];
	
	MudDataMacroSteps *step3b = (MudDataMacroSteps *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataMacroSteps" inManagedObjectContext:self.context];
	[step3b setFirstVariable:nil];
	[step3b setSecondVariable:nil];
	[step3b setValue1:@"look $1"];
	[step3b setFormatVariableList:@"1"];
	[step3b setMacroID:macro3];
	[step3b setStep:[NSNumber numberWithInt:2]];
	[step3b setCommand:[NSNumber numberWithInt:mMacroCommandSendFormattedTextServer]];
	
	
	
	MudDataMacros *macro4 = (MudDataMacros *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataMacros" inManagedObjectContext:self.context];
	[macro4 setTitle:@"kill"];
	[macro4 setId:[NSNumber numberWithInt:4]];
	[macro4 setSlotID:char1];
	
	MudDataMacroSteps *step4 = (MudDataMacroSteps *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataMacroSteps" inManagedObjectContext:self.context];
	[step4 setFirstVariable:nil];
	[step4 setSecondVariable:nil];
	[step4 setValue1:@"kill $1"];
	[step4 setFormatVariableList:@"1"];
	[step4 setMacroID:macro4];
	[step4 setStep:[NSNumber numberWithInt:1]];
	[step4 setCommand:[NSNumber numberWithInt:mMacroCommandSendFormattedTextServer]];
	
	MudDataMacros *macro5 = (MudDataMacros *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataMacros" inManagedObjectContext:self.context];
	[macro5 setTitle:@"consider"];
	[macro5 setId:[NSNumber numberWithInt:5]];
	[macro5 setSlotID:char1];
	
	MudDataMacroSteps *step5 = (MudDataMacroSteps *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataMacroSteps" inManagedObjectContext:self.context];
	[step5 setFirstVariable:nil];
	[step5 setSecondVariable:nil];
	[step5 setValue1:@"con $1"];
	[step5 setFormatVariableList:@"1"];
	[step5 setMacroID:macro5];
	[step5 setStep:[NSNumber numberWithInt:1]];
	[step5 setCommand:[NSNumber numberWithInt:mMacroCommandSendFormattedTextServer]];
	
	
	MudDataMacros *macro6 = (MudDataMacros *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataMacros" inManagedObjectContext:self.context];
	[macro6 setTitle:@"lookButton"];
	[macro6 setId:[NSNumber numberWithInt:6]];
	[macro6 setSlotID:char1];
	
	MudDataMacroSteps *step6 = (MudDataMacroSteps *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataMacroSteps" inManagedObjectContext:self.context];
	[step6 setFirstVariable:nil];
	[step6 setSecondVariable:nil];
	[step6 setValue1:@"look $1"];
	[step6 setFormatVariableList:@"1"];
	[step6 setMacroID:macro6];
	[step6 setStep:[NSNumber numberWithInt:1]];
	[step6 setCommand:[NSNumber numberWithInt:mMacroCommandSendFormattedTextServer]];
	
	MudDataTriggers *trigger1 = (MudDataTriggers *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataTriggers" inManagedObjectContext:self.context];
	[trigger1 setTitle:@"*automatic login (name)"];
	[trigger1 setExpression:@"By what name do you wish to be known?"];
	[trigger1 setTrigmacro:macro1];
	[trigger1 setSlotID:char1];
	[trigger1 setDisableOnUse:[NSNumber numberWithBool:YES]];
	
	
	MudDataTriggers *trigger2 = (MudDataTriggers *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataTriggers" inManagedObjectContext:self.context];
	[trigger2 setTitle:@"*automatic login (password)"];
	[trigger2 setExpression:@"Password:"];
	[trigger2 setTrigmacro:macro2];
	[trigger2 setSlotID:char1];
	[trigger2 setDisableOnUse:[NSNumber numberWithBool:YES]];
	
	// Create the buttons
	
	MudDataButtons	*button1 = (MudDataButtons *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataButtons" inManagedObjectContext:self.context];
	
	[button1 setTitle:@"Up"];
	[button1 setIconIndex:[NSNumber numberWithInt:-1]];
	[button1 setX:[NSNumber numberWithInt:8]];
	[button1 setY:[NSNumber numberWithInt:1]];
	[button1 setLayer1Action:@"Up"];
	[button1 setLayer2Action:@"Look UP"];
	[button1 setSlotID:char1];
	[button1 setPortrait:[NSNumber numberWithBool:YES]];
	
	MudDataButtons	*button2 = (MudDataButtons *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataButtons" inManagedObjectContext:self.context];
	//[button2 setTitle:@"N"];
	[button2 setIconIndex:[NSNumber numberWithInt:3]];
	[button2 setX:[NSNumber numberWithInt:9]];
	[button2 setY:[NSNumber numberWithInt:1]];
	[button2 setLayer1Action:@"N"];
	[button2 setLayer2Action:@"Look N"];
	[button2 setSlotID:char1];
	[button2 setPortrait:[NSNumber numberWithBool:YES]];
	 
	MudDataButtons	*button3 = (MudDataButtons *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataButtons" inManagedObjectContext:self.context];
	[button3 setTitle:@"Dn"];
	[button3 setIconIndex:[NSNumber numberWithInt:-1]];
	[button3 setX:[NSNumber numberWithInt:10]];
	[button3 setY:[NSNumber numberWithInt:1]];
	[button3 setLayer1Action:@"D"];
	[button3 setLayer2Action:@"Look D"];
	[button3 setSlotID:char1];
	[button3 setPortrait:[NSNumber numberWithBool:YES]];
	 
	MudDataButtons	*button4 = (MudDataButtons *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataButtons" inManagedObjectContext:self.context];
	//[button4 setTitle:@"W"];
	[button4 setIconIndex:[NSNumber numberWithInt:1]];
	[button4 setX:[NSNumber numberWithInt:8]];
	[button4 setY:[NSNumber numberWithInt:2]];
	[button4 setLayer1Action:@"W"];
	[button4 setLayer2Action:@"Look W"];
	[button4 setSlotID:char1];
	[button4 setPortrait:[NSNumber numberWithBool:YES]];
	 
	MudDataButtons	*button5 = (MudDataButtons *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataButtons" inManagedObjectContext:self.context];
	//[button5 setTitle:@"S"];
	[button5 setIconIndex:[NSNumber numberWithInt:0]];
	[button5 setX:[NSNumber numberWithInt:9]];
	[button5 setY:[NSNumber numberWithInt:2]];
	[button5 setLayer1Action:@"S"];
	[button5 setLayer2Action:@"Look S"];
	[button5 setSlotID:char1];
	[button5 setPortrait:[NSNumber numberWithBool:YES]];
	 
	MudDataButtons	*button6 = (MudDataButtons *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataButtons" inManagedObjectContext:self.context];
	//[button6 setTitle:@"E"];
	[button6 setIconIndex:[NSNumber numberWithInt:2]];
	[button6 setX:[NSNumber numberWithInt:10]];
	[button6 setY:[NSNumber numberWithInt:2]];
	[button6 setLayer1Action:@"E"];
	[button6 setLayer2Action:@"Look E"];
	[button6 setSlotID:char1];
	[button6 setPortrait:[NSNumber numberWithBool:YES]];
	
	//I_Chest01.png
	MudDataButtons	*button7 = (MudDataButtons *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataButtons" inManagedObjectContext:self.context];
	[button7 setTitle:@"Inv"];
	[button7 setIconIndex:[NSNumber numberWithInt:-1]];
	[button7 setX:[NSNumber numberWithInt:1]];
	[button7 setY:[NSNumber numberWithInt:1]];
	[button7 setLayer1Action:@"Inv"];
	[button7 setSlotID:char1];
	[button7 setPortrait:[NSNumber numberWithBool:YES]];
	
	//A_Armor04.png
	MudDataButtons	*button8 = (MudDataButtons *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataButtons" inManagedObjectContext:self.context];
	[button8 setTitle:@"EQ"];
	[button8 setIconIndex:[NSNumber numberWithInt:-1]];
	[button8 setX:[NSNumber numberWithInt:1]];
	[button8 setY:[NSNumber numberWithInt:2]];
	[button8 setLayer1Action:@"eq"];
	[button8 setSlotID:char1];
	[button8 setPortrait:[NSNumber numberWithBool:YES]];
	
	MudDataButtons	*button9 = (MudDataButtons *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataButtons" inManagedObjectContext:self.context];
	[button9 setIconIndex:[NSNumber numberWithInt:-1]];
	[button9 setX:[NSNumber numberWithInt:7]];
	[button9 setY:[NSNumber numberWithInt:1]];
	[button9 setSlotID:char1];
	[button9 setPortrait:[NSNumber numberWithBool:YES]];
	
	
	MudDataButtons	*button10 = (MudDataButtons *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataButtons" inManagedObjectContext:self.context];
	[button10 setIconIndex:[NSNumber numberWithInt:5]];
	[button10 setX:[NSNumber numberWithInt:7]];
	[button10 setY:[NSNumber numberWithInt:2]];
	[button10 setLayer1Action:@"look"];
	[button10 setLayer2Action:@"look self"];
	[button10 setLayer3Action:@"exits"];
	[button10 setSlotID:char1];
	[button10 setPortrait:[NSNumber numberWithBool:YES]];
	 
	
	// Create the buttons landscape
	
	MudDataButtons	*lbutton1 = (MudDataButtons *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataButtons" inManagedObjectContext:self.context];
	
	[lbutton1 setTitle:@"Up"];
	[lbutton1 setIconIndex:[NSNumber numberWithInt:-1]];
	[lbutton1 setX:[NSNumber numberWithInt:2]];
	[lbutton1 setY:[NSNumber numberWithInt:4]];
	[lbutton1 setLayer1Action:@"Up"];
	[lbutton1 setLayer2Action:@"Look UP"];
	[lbutton1 setSlotID:char1];
	[lbutton1 setPortrait:[NSNumber numberWithBool:NO]];
	 
	 
	MudDataButtons	*lbutton2 = (MudDataButtons *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataButtons" inManagedObjectContext:self.context];

	[lbutton2 setIconIndex:[NSNumber numberWithInt:4]];
	[lbutton2 setX:[NSNumber numberWithInt:3]];
	[lbutton2 setY:[NSNumber numberWithInt:4]];
	[lbutton2 setLayer1Action:@"N"];
	[lbutton2 setLayer2Action:@"Look N"];
	[lbutton2 setSlotID:char1];
	[lbutton2 setPortrait:[NSNumber numberWithBool:NO]];
	 
	MudDataButtons	*lbutton3 = (MudDataButtons *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataButtons" inManagedObjectContext:self.context];
	[lbutton3 setTitle:@"Dn"];
	[lbutton3 setIconIndex:[NSNumber numberWithInt:-1]];
	[lbutton3 setX:[NSNumber numberWithInt:4]];
	[lbutton3 setY:[NSNumber numberWithInt:4]];
	[lbutton3 setLayer1Action:@"D"];
	[lbutton3 setLayer2Action:@"Look D"];
	[lbutton3 setSlotID:char1];
	[lbutton3 setPortrait:[NSNumber numberWithBool:NO]];
	 
	MudDataButtons	*lbutton4 = (MudDataButtons *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataButtons" inManagedObjectContext:self.context];
	//[lbutton4 setTitle:@"W"];
	[lbutton4 setIconIndex:[NSNumber numberWithInt:1]];
	[lbutton4 setX:[NSNumber numberWithInt:2]];
	[lbutton4 setY:[NSNumber numberWithInt:5]];
	[lbutton4 setLayer1Action:@"W"];
	[lbutton4 setLayer2Action:@"Look W"];
	[lbutton4 setSlotID:char1];
	[lbutton4 setPortrait:[NSNumber numberWithBool:NO]];
	 
	MudDataButtons	*lbutton5 = (MudDataButtons *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataButtons" inManagedObjectContext:self.context];
	//[lbutton5 setTitle:@"S"];
	[lbutton5 setIconIndex:[NSNumber numberWithInt:0]];
	[lbutton5 setX:[NSNumber numberWithInt:3]];
	[lbutton5 setY:[NSNumber numberWithInt:5]];
	[lbutton5 setLayer1Action:@"S"];
	[lbutton5 setLayer2Action:@"Look S"];
	[lbutton5 setSlotID:char1];
	[lbutton5 setPortrait:[NSNumber numberWithBool:NO]];
	 
	MudDataButtons	*lbutton6 = (MudDataButtons *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataButtons" inManagedObjectContext:self.context];
	//[lbutton6 setTitle:@"E"];
	[lbutton6 setIconIndex:[NSNumber numberWithInt:3]];
	[lbutton6 setX:[NSNumber numberWithInt:4]];
	[lbutton6 setY:[NSNumber numberWithInt:5]];
	[lbutton6 setLayer1Action:@"E"];
	[lbutton6 setLayer2Action:@"Look E"];
	[lbutton6 setSlotID:char1];
	[lbutton6 setPortrait:[NSNumber numberWithBool:NO]];
	
	//I_Chest01.png
	MudDataButtons	*lbutton7 = (MudDataButtons *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataButtons" inManagedObjectContext:self.context];
	[lbutton7 setTitle:@"Inv"];
	[lbutton7 setIconIndex:[NSNumber numberWithInt:-1]];
	[lbutton7 setX:[NSNumber numberWithInt:1]];
	[lbutton7 setY:[NSNumber numberWithInt:1]];
	[lbutton7 setLayer1Action:@"Inv"];
	[lbutton7 setSlotID:char1];
	[lbutton7 setPortrait:[NSNumber numberWithBool:NO]];
	
	//A_Armor04.png
	MudDataButtons	*lbutton8 = (MudDataButtons *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataButtons" inManagedObjectContext:self.context];
	[lbutton8 setTitle:@"EQ"];
	[lbutton8 setIconIndex:[NSNumber numberWithInt:3]];
	[lbutton8 setX:[NSNumber numberWithInt:4]];
	[lbutton8 setY:[NSNumber numberWithInt:1]];
	[lbutton8 setLayer1Action:@"eq"];
	[lbutton8 setSlotID:char1];
	[lbutton8 setPortrait:[NSNumber numberWithBool:NO]];
	 
	MudDataButtons	*lbutton9 = (MudDataButtons *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataButtons" inManagedObjectContext:self.context];
	[lbutton9 setIconIndex:[NSNumber numberWithInt:-1]];
	[lbutton9 setX:[NSNumber numberWithInt:1]];
	[lbutton9 setY:[NSNumber numberWithInt:4]];
	[lbutton9 setSlotID:char1];
	[lbutton9 setPortrait:[NSNumber numberWithBool:NO]];
	
	MudDataButtons	*lbutton10 = (MudDataButtons *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataButtons" inManagedObjectContext:self.context];
	[lbutton10 setIconIndex:[NSNumber numberWithInt:5]];
	[lbutton10 setX:[NSNumber numberWithInt:1]];
	[lbutton10 setY:[NSNumber numberWithInt:5]];
	[lbutton10 setLayer1Action:@"look"];
	[lbutton10 setLayer2Action:@"look self"];
	[lbutton10 setLayer3Action:@"exits"];
	[lbutton10 setSlotID:char1];
	[lbutton10 setPortrait:[NSNumber numberWithBool:NO]];

	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	[myAppDelegate saveCoreData];	
	
	
	[button9 setLayer1Action:@""];
	[button9 setLayer2Action:@""];
	[button9 setLayer3Action:@""];
	[button9 setLayer1Macro:macro6];
	[button9 setLayer2Macro:macro4];
	[button9 setLayer3Macro:macro5];
	
	[lbutton9 setLayer1Action:@""];
	[lbutton9 setLayer2Action:@""];
	[lbutton9 setLayer3Action:@""];
	[lbutton9 setLayer1Macro:macro6];
	[lbutton9 setLayer2Macro:macro4];
	[lbutton9 setLayer3Macro:macro5];
	
	[myAppDelegate saveCoreData];
	
	//NSLog(@"Test: %@\nTest2: %@", lbutton9.layer1Macro.title, macro6.title);
	
}


- (void)pointToDefaultKeyboardResponder {

	MudInputFooter *footerView = (MudInputFooter *)self.viewController.footer;
	
	if (footerView) {
		[footerView.inputTextView becomeFirstResponder];
	}
	
}

- (void) initCoreData { 
	
	NSError *error;
	// Path to sqlite file.
	NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/mudclient1.2.sqlite"] ;
    NSURL *url = [ NSURL fileURLWithPath: path];
	
    NSString *p = [[NSBundle mainBundle] pathForResource:@"" ofType:@"momd"];
    NSURL *momURL = [NSURL fileURLWithPath:p];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
	
	
	
	// Establish the persistent store coordinator
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: managedObjectModel] ;
	NSMutableDictionary *storeOptions = [[NSMutableDictionary alloc] init];
	[storeOptions setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
	[storeOptions setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];


    if ( ![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL: url options: storeOptions error: &error] ) {
		NSLog( @" Error %@", [error localizedDescription] );
    } else {
        
		// Create the context and assign the coordinator
        self.context = [ [ NSManagedObjectContext alloc] init];
        [self.context setPersistentStoreCoordinator: persistentStoreCoordinator];
    }
	
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"firstRunSince2.0"] boolValue]) {
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"firstRunSince2.0"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"Upgrading Database to 2.0");
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"MudDataSettings" inManagedObjectContext:self.context];
        [request setEntity:entity];
    
        NSArray *results = [self.context executeFetchRequest:request error:&error];
        
        for (MudDataSettings *setting in results) {
            setting.defaultBackgroundColor = [NSNumber numberWithInt:0];
            setting.defaultColor = [NSNumber numberWithInt:2];
            setting.landscapeKeyboardAlpha = [NSDecimalNumber decimalNumberWithString:@"1.0"];
            setting.bottomLandscapeInputBar = @YES;
        }
        
        request = [[NSFetchRequest alloc] init];
        entity = [NSEntityDescription entityForName:@"MudDataCharacters" inManagedObjectContext:self.context];
        [request setEntity:entity];
        
        results = [self.context executeFetchRequest:request error:&error];
        
        for (MudDataCharacters *character in results) {
            character.font = @"Menlo-Regular";
            character.fontSize = [NSNumber numberWithFloat:14.5f];
        }
        
        [self saveCoreData];
        
        NSLog(@"Upgrade Complete");
    }
}

#pragma mark -
#pragma mark Application lifecycle


-(void)keyboardWillShow:(id)sender {
	self.softwareKeyboardSeen = YES;
	self.keyboardWentHidden = NO;
}

-(void)keyboardWillHide:(id)sender {
	self.keyboardWentHidden = YES;
    self.softwareKeyboardSeen = NO;
	
	MudInputFooter *footer = (MudInputFooter *)self.viewController.footer;
	[footer.inputTextView resignFirstResponder];
	
	[self.viewController updateViewsForFeatureChange];
}

-(void)PullRecordsforCharList {
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"MudDataCharacters" inManagedObjectContext:self.context];
	[request setEntity:entity];
	
	// Order the events by creation date, most recent first.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"slotID" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[self.context executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
	}
	
	// Set self's events array to the mutable array, then clean up.
	
	self.mudCharArray = mutableFetchResults;
	
	
}

-(int)findNewSlotID {
	
	int newSlotID = 1;
	MudDataCharacters *character = nil;
	
	for (character in self.mudCharArray) {
		if (character) {
			int aSlotID = [[character slotID] intValue];
			if (aSlotID >= newSlotID) {
				newSlotID = aSlotID+1;
			}
		}
	}
	
	return newSlotID;
}


-(void)updateUseCounter {
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL neverAsk = [[defaults objectForKey:@"neverAskReview"] boolValue];
    BOOL reviewed = [[defaults objectForKey:@"hasReviewed"] boolValue];
    
    
    NSInteger count = [[defaults objectForKey:@"useCounter"] integerValue];
    count++;
    
    [defaults setObject:[NSNumber numberWithInt:count] forKey:@"useCounter"];
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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=393765507&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"alertidx:%d", buttonIndex);
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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	[UIApplication sharedApplication].applicationSupportsShakeToEdit = NO;
	
    [UITextField appearance].keyboardAppearance = UIKeyboardAppearanceDark;
    
    self.backgroundSupported = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenDidConnect:) name:UIScreenDidConnectNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenDidDisconnect:) name:UIScreenDidDisconnectNotification object:nil];
      
    UIDevice* device = [UIDevice currentDevice];
    
    if ([device respondsToSelector:@selector(isMultitaskingSupported)]) {
        self.backgroundSupported = device.multitaskingSupported;
    }
    
	self.internetStatus = 1;
	
	self.softwareKeyboardSeen = NO;
	self.keyboardWentHidden = NO;
	
	UIWindow *appWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = appWindow;
	[self initCoreData];
	self.viewController = [[MudClientIpad4ViewController alloc] init];
	
	
	self.viewController.context = self.context;
		
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

	self.internetReach = [Reachability reachabilityForInternetConnection];
	[self.internetReach startNotifier];
	
	/* Operation Queue init (autorelease) */
    self.opQueue = [NSOperationQueue new];

	[self.opQueue setMaxConcurrentOperationCount:1];
	
	int openCharView = 0;
	
	NSArray *keyArray = [launchOptions allKeys];
	if ([launchOptions objectForKey:[keyArray objectAtIndex:0]]!=nil) {
		NSURL *url = [launchOptions objectForKey:[keyArray objectAtIndex:0]];
		NSString *m_URLString = [url absoluteString];
		
		//split it up
		NSArray* queryArray = [m_URLString componentsSeparatedByString:@"://"];

		NSString *protocolName = [[queryArray objectAtIndex:0] lowercaseString];
		
		if ([protocolName isEqualToString:@"telnet"] | [protocolName isEqualToString:@"mud"]) {
		  // Handle it
           NSArray* queryArray2 = [[queryArray objectAtIndex:1] componentsSeparatedByString:@":"];
				
			MudDataCharacters *char1 = (MudDataCharacters *)[NSEntityDescription insertNewObjectForEntityForName: @"MudDataCharacters" inManagedObjectContext:self.context];
			[char1 setSlotID:[NSNumber numberWithInt:[self findNewSlotID]]];
			[char1 setServerTitle:[queryArray2 objectAtIndex:0]];
			[char1 setHostName:[queryArray2 objectAtIndex:0]];
			[char1 setTcpPort:[NSNumber numberWithInt:[[queryArray2 objectAtIndex:1] intValue]]];
			[char1 setCharacterName:@""];
			[char1 setPassword:@""];
			
			[self createInitialCharacterData:char1];
			openCharView = 1;
						
		}
		
	}
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    
    [window setTintColor:[UIColor whiteColor]];
    [window setBackgroundColor:[UIColor blackColor]];
    
    _navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    
	[window setRootViewController:_navController];
    
	//[window addSubview:self.viewController.view];
   //[window makeKeyAndVisible];
	
	if (openCharView) {
		[self.viewController mudAddConnectionsClicked:self.viewController.MudPickButton];
	} else {
        /*
		if (!self.webView) {
			self.webView = [[[UIWebView alloc] initWithFrame:CGRectMake(34,50,700,700)] autorelease];
			NSURL *requestURL = [NSURL URLWithString:@"http://www.techaccomplished.com/node/18"];
			NSURLRequest *requestObj = [NSURLRequest requestWithURL:requestURL];
			[self.webView loadRequest:requestObj];
		}
		[self.viewController.view addSubview:self.webView];
         */
         
	}
	
    [self beATVUser];
    
    [self startRemote];
    [self updateUseCounter];
	return YES;
}

-(void)startRemote {
    [[RemoteServer tool] startSession];
    [[RemoteServer tool] startAdvertiser];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
    //For now, we'll continue handling scripts and so-on
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	[self.internetReach stopNotifier];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    // Recover the string
    if (!url) return NO;
    NSString *URLString = [url absoluteString];
	NSLog(@"HandleOpenURL:%@", URLString);
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"URL" message:URLString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	
	
    return YES;
}



-(void)disconnectTeleScreen {
    NSLog(@"Airplay disconnect: %d", [[UIScreen screens] count]);
    
    mirroredWindow.screen = nil;
    mirroredWindow = nil;
    
    self.tvReady = NO;
    
    [viewController updateDisplayForTeleEvent];
}

-(void)connectTeleScreen {
    NSLog(@"Airplay connect: %d", [[UIScreen screens] count]);
    
    BOOL found = NO;

    self.tvReady = NO;
    
    for (UIScreen *s in [UIScreen screens]) {
        if (s != [UIScreen mainScreen]) {
            mirroredWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0,0,1280,720)];
            for (UIScreenMode *m in s.availableModes) {
                if ( (m.size.width == 1280) && (m.size.height == 720) ) {
                    s.currentMode = m;
                    NSLog(@"Found 720 mode; setting");
                    break;
                }
            }  
            mirroredWindow.screen = s;
            
            [mirroredWindow setRootViewController:self.teleVC];
            [mirroredWindow setHidden:NO];
            
            //s.overscanCompensation = 3;
            
            s.overscanCompensation   = UIScreenOverscanCompensationScale;
            found = YES;
        }
    }
    
    self.tvReady = found;
    
    [viewController updateDisplayForTeleEvent];
}


-(BOOL)beATVUser {
    
    if (!self.teleVC) {
        self.teleVC = [[TeleViewController alloc] initWithNibName:@"TeleViewController" bundle:nil];
    }
    
    
    if (!mirroredWindow) {
        [self connectTeleScreen];
    }

    return (mirroredWindow != nil);
}

- (void) screenDidConnect:(NSNotification *) notification {
    [self connectTeleScreen];
    
}

- (void) screenDidDisconnect:(NSNotification *) notification {
    [self disconnectTeleScreen];
}

@end
