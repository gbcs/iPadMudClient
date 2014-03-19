//
//  MudConnectionEncoding.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MudConnectionEncoding: UIViewController  <UITableViewDelegate, UITableViewDataSource> {
	UITableView *tableview;
}

@property (nonatomic, strong) UITableView *tableview;

+(NSString *)encodingNameFromVal:(int)encodingVal;
@end
