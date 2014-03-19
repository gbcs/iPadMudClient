//
//  MudDataButtons.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/29/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MudDataCharacters, MudDataMacros;

@interface MudDataButtons : NSManagedObject

@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSString * layer3Action;
@property (nonatomic, retain) NSNumber * y;
@property (nonatomic, retain) NSNumber * appendFlag1;
@property (nonatomic, retain) NSNumber * appendFlag2;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * portrait;
@property (nonatomic, retain) NSNumber * appendFlag3;
@property (nonatomic, retain) NSString * layer1Action;
@property (nonatomic, retain) NSNumber * iconIndex;
@property (nonatomic, retain) NSString * layer2Action;
@property (nonatomic, retain) NSNumber * remote;
@property (nonatomic, retain) NSNumber * remoteIndex;
@property (nonatomic, retain) MudDataCharacters *slotID;
@property (nonatomic, retain) MudDataMacros *layer1Macro;
@property (nonatomic, retain) MudDataMacros *layer2Macro;
@property (nonatomic, retain) MudDataMacros *layer3Macro;

@end
