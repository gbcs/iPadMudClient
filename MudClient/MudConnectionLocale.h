//
//  MudConnectionLocale.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MudConnectionLocale: UIViewController  <UITableViewDelegate, UITableViewDataSource> {
	UITableView *tableview;
	NSArray *localeIdentifierList;
}

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSArray *localeIdentifierList;

@end
