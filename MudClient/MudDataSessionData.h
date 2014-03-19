//
//  MudDataSessionData.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MudDataSessions;

@interface MudDataSessionData : NSManagedObject

@property (nonatomic, retain) NSString * line;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSData * attributes;
@property (nonatomic, retain) MudDataSessions *session;

@end
