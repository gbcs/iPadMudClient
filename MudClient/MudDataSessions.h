//
//  MudDataSessions.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MudDataCharacters, MudDataSessionData;

@interface MudDataSessions : NSManagedObject

@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) MudDataCharacters *character;
@property (nonatomic, retain) NSSet *sessionLines;
@end

@interface MudDataSessions (CoreDataGeneratedAccessors)

- (void)addSessionLinesObject:(MudDataSessionData *)value;
- (void)removeSessionLinesObject:(MudDataSessionData *)value;
- (void)addSessionLines:(NSSet *)values;
- (void)removeSessionLines:(NSSet *)values;

@end
