//
//  MudDataMacros.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MudDataButtons, MudDataCharacters, MudDataMacroSteps, MudDataTouchableTexts, MudDataTriggers;

@interface MudDataMacros : NSManagedObject

@property (nonatomic, retain) NSString * expression;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) MudDataCharacters *slotID;
@property (nonatomic, retain) NSSet *mactrig;
@property (nonatomic, retain) NSSet *macroStep;
@property (nonatomic, retain) MudDataTouchableTexts *touchableText;
@property (nonatomic, retain) NSSet *buttonActionLayer1;
@property (nonatomic, retain) NSSet *buttonActionLayer2;
@property (nonatomic, retain) NSSet *buttonActionLayer3;
@end

@interface MudDataMacros (CoreDataGeneratedAccessors)

- (void)addMactrigObject:(MudDataTriggers *)value;
- (void)removeMactrigObject:(MudDataTriggers *)value;
- (void)addMactrig:(NSSet *)values;
- (void)removeMactrig:(NSSet *)values;

- (void)addMacroStepObject:(MudDataMacroSteps *)value;
- (void)removeMacroStepObject:(MudDataMacroSteps *)value;
- (void)addMacroStep:(NSSet *)values;
- (void)removeMacroStep:(NSSet *)values;

- (void)addButtonActionLayer1Object:(MudDataButtons *)value;
- (void)removeButtonActionLayer1Object:(MudDataButtons *)value;
- (void)addButtonActionLayer1:(NSSet *)values;
- (void)removeButtonActionLayer1:(NSSet *)values;

- (void)addButtonActionLayer2Object:(MudDataButtons *)value;
- (void)removeButtonActionLayer2Object:(MudDataButtons *)value;
- (void)addButtonActionLayer2:(NSSet *)values;
- (void)removeButtonActionLayer2:(NSSet *)values;

- (void)addButtonActionLayer3Object:(MudDataButtons *)value;
- (void)removeButtonActionLayer3Object:(MudDataButtons *)value;
- (void)addButtonActionLayer3:(NSSet *)values;
- (void)removeButtonActionLayer3:(NSSet *)values;

@end
