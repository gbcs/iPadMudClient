//
//  MudDataServerList.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MudDataServerList : NSManagedObject

@property (nonatomic, retain) NSNumber * tcpPort;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * hostName;
@property (nonatomic, retain) NSString * referenceURL;

@end
