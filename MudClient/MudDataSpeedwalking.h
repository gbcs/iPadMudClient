//
//  MudDataSpeedwalking.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MudDataCharacters;

@interface MudDataSpeedwalking : NSManagedObject

@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSNumber * enabled;
@property (nonatomic, retain) MudDataCharacters *character;

@end
