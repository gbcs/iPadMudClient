//
//  MudDataPreviousCommands.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MudDataCharacters;

@interface MudDataPreviousCommands : NSManagedObject

@property (nonatomic, retain) NSNumber * showNoMore;
@property (nonatomic, retain) NSString * commandText;
@property (nonatomic, retain) MudDataCharacters *slotID;

@end
