//
//  MudDataAliases.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 11/11/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MudDataCharacters, MudDataVariables;

@interface MudDataAliases : NSManagedObject

@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) MudDataCharacters *slotID;
@property (nonatomic, retain) MudDataVariables *firstVariable;
@property (nonatomic, retain) MudDataVariables *secondVariable;
@property (nonatomic, retain) MudDataVariables *thirdVariable;

@end
