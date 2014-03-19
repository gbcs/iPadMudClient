//
//  MudDataTriggers.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MudDataCharacters, MudDataMacros;

@interface MudDataTriggers : NSManagedObject

@property (nonatomic, retain) NSString * expression;
@property (nonatomic, retain) NSNumber * triggerEnabled;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * DisableOnUse;
@property (nonatomic, retain) MudDataMacros *trigmacro;
@property (nonatomic, retain) MudDataCharacters *slotID;

@end
