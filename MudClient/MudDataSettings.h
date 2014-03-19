//
//  MudDataSettings.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MudDataCharacters;

@interface MudDataSettings : NSManagedObject

@property (nonatomic, retain) NSNumber * defaultBackgroundColor;
@property (nonatomic, retain) NSNumber * storeSessionData;
@property (nonatomic, retain) NSNumber * landscapeViewHeight;
@property (nonatomic, retain) NSString * commandSeparator;
@property (nonatomic, retain) NSNumber * defaultColor;
@property (nonatomic, retain) NSNumber * standardLineFeed;
@property (nonatomic, retain) NSNumber * swapColors;
@property (nonatomic, retain) NSNumber * EchoMacroOutput;
@property (nonatomic, retain) NSDecimalNumber * landscapeKeyboardAlpha;
@property (nonatomic, retain) NSNumber * bottomLandscapeInputBar;
@property (nonatomic, retain) NSNumber * EchoTypedOutput;
@property (nonatomic, retain) NSNumber * dataCompression;
@property (nonatomic, retain) NSNumber * largeInputArea;
@property (nonatomic, retain) NSNumber * buttonBars;
@property (nonatomic, retain) NSString * speedwalkSeperator;
@property (nonatomic, retain) NSString * speedwalkPrefix;
@property (nonatomic, retain) NSString * macroPrefix;
@property (nonatomic, retain) MudDataCharacters *slotID;

@end
