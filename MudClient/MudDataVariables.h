//
//  MudDataVariables.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 11/10/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MudDataAliases, MudDataCharacters, MudDataMacroSteps;

@interface MudDataVariables : NSManagedObject

@property (nonatomic, retain) NSString * currentValue;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) MudDataCharacters *slotID;
@property (nonatomic, retain) NSSet *variableID2;
@property (nonatomic, retain) NSSet *variableID1;
@property (nonatomic, retain) MudDataAliases *alias;
@end

@interface MudDataVariables (CoreDataGeneratedAccessors)

- (void)addVariableID2Object:(MudDataMacroSteps *)value;
- (void)removeVariableID2Object:(MudDataMacroSteps *)value;
- (void)addVariableID2:(NSSet *)values;
- (void)removeVariableID2:(NSSet *)values;

- (void)addVariableID1Object:(MudDataMacroSteps *)value;
- (void)removeVariableID1Object:(MudDataMacroSteps *)value;
- (void)addVariableID1:(NSSet *)values;
- (void)removeVariableID1:(NSSet *)values;

@end
