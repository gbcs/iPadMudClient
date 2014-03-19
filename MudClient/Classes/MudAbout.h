//
//  MudAbout.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MudAbout : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView *tv;
}

@property (nonatomic, retain) UITableView *tv;

@end
