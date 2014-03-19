//
//  MudDataCharacters.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 11/10/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MudDataAliases, MudDataMacros, MudDataPreviousCommands, MudDataSessions, MudDataSettings, MudDataSpeedwalking, MudDataTouchableTexts, MudDataTriggers, MudDataVariables;

@interface MudDataCharacters : NSManagedObject

@property (nonatomic, retain) NSString * lang;
@property (nonatomic, retain) NSNumber * SSL;
@property (nonatomic, retain) NSNumber * slotID;
@property (nonatomic, retain) NSNumber * tcpPort;
@property (nonatomic, retain) NSNumber * lineHandling;
@property (nonatomic, retain) NSNumber * encoding;
@property (nonatomic, retain) NSString * font;
@property (nonatomic, retain) NSString * serverTitle;
@property (nonatomic, retain) NSNumber * fontSize;
@property (nonatomic, retain) NSString * hostName;
@property (nonatomic, retain) NSString * characterName;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSSet *touchableTexts;
@property (nonatomic, retain) NSSet *muddatamacrosslotid;
@property (nonatomic, retain) NSSet *speedwalking;
@property (nonatomic, retain) NSSet *muddatapreviouscomamnds;
@property (nonatomic, retain) NSSet *muddatavariablesslotid;
@property (nonatomic, retain) NSSet *muddatabuttons;
@property (nonatomic, retain) NSSet *muddatasettings;
@property (nonatomic, retain) NSSet *muddatatriggers;
@property (nonatomic, retain) NSSet *sessions;
@property (nonatomic, retain) NSSet *muddataaliases;
@end

@interface MudDataCharacters (CoreDataGeneratedAccessors)

- (void)addTouchableTextsObject:(MudDataTouchableTexts *)value;
- (void)removeTouchableTextsObject:(MudDataTouchableTexts *)value;
- (void)addTouchableTexts:(NSSet *)values;
- (void)removeTouchableTexts:(NSSet *)values;

- (void)addMuddatamacrosslotidObject:(MudDataMacros *)value;
- (void)removeMuddatamacrosslotidObject:(MudDataMacros *)value;
- (void)addMuddatamacrosslotid:(NSSet *)values;
- (void)removeMuddatamacrosslotid:(NSSet *)values;

- (void)addSpeedwalkingObject:(MudDataSpeedwalking *)value;
- (void)removeSpeedwalkingObject:(MudDataSpeedwalking *)value;
- (void)addSpeedwalking:(NSSet *)values;
- (void)removeSpeedwalking:(NSSet *)values;

- (void)addMuddatapreviouscomamndsObject:(MudDataPreviousCommands *)value;
- (void)removeMuddatapreviouscomamndsObject:(MudDataPreviousCommands *)value;
- (void)addMuddatapreviouscomamnds:(NSSet *)values;
- (void)removeMuddatapreviouscomamnds:(NSSet *)values;

- (void)addMuddatavariablesslotidObject:(MudDataVariables *)value;
- (void)removeMuddatavariablesslotidObject:(MudDataVariables *)value;
- (void)addMuddatavariablesslotid:(NSSet *)values;
- (void)removeMuddatavariablesslotid:(NSSet *)values;

- (void)addMuddatabuttonsObject:(MudDataPreviousCommands *)value;
- (void)removeMuddatabuttonsObject:(MudDataPreviousCommands *)value;
- (void)addMuddatabuttons:(NSSet *)values;
- (void)removeMuddatabuttons:(NSSet *)values;

- (void)addMuddatasettingsObject:(MudDataSettings *)value;
- (void)removeMuddatasettingsObject:(MudDataSettings *)value;
- (void)addMuddatasettings:(NSSet *)values;
- (void)removeMuddatasettings:(NSSet *)values;

- (void)addMuddatatriggersObject:(MudDataTriggers *)value;
- (void)removeMuddatatriggersObject:(MudDataTriggers *)value;
- (void)addMuddatatriggers:(NSSet *)values;
- (void)removeMuddatatriggers:(NSSet *)values;

- (void)addSessionsObject:(MudDataSessions *)value;
- (void)removeSessionsObject:(MudDataSessions *)value;
- (void)addSessions:(NSSet *)values;
- (void)removeSessions:(NSSet *)values;

- (void)addMuddataaliasesObject:(MudDataAliases *)value;
- (void)removeMuddataaliasesObject:(MudDataAliases *)value;
- (void)addMuddataaliases:(NSSet *)values;
- (void)removeMuddataaliases:(NSSet *)values;

@end
