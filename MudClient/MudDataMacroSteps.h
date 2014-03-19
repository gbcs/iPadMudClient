//
//  MudDataMacroSteps.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MudDataMacros, MudDataVariables;

@interface MudDataMacroSteps : NSManagedObject

@property (nonatomic, retain) NSString * value1;
@property (nonatomic, retain) NSNumber * delay;
@property (nonatomic, retain) NSNumber * step;
@property (nonatomic, retain) NSNumber * command;
@property (nonatomic, retain) NSString * formatVariableList;
@property (nonatomic, retain) MudDataMacros *macroID;
@property (nonatomic, retain) MudDataVariables *firstVariable;
@property (nonatomic, retain) MudDataVariables *secondVariable;

@end
