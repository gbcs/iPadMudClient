//
//  MudDataTouchableTexts.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 11/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MudDataCharacters, MudDataMacros;

@interface MudDataTouchableTexts : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSNumber * enabled;
@property (nonatomic, retain) NSString * expression;
@property (nonatomic, retain) MudDataMacros *macro;
@property (nonatomic, retain) MudDataCharacters *character;

@end
