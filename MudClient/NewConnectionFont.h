//
//  NewConnectionFont.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 4/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewConnectionFont : UIViewController  <UITableViewDelegate, UITableViewDataSource> {
	UITableView *tableview;
	NSArray *sortedFontFamilies;
}

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSArray *sortedFontFamilies;
@property (nonatomic, strong) UIFont *characterFont;
@end
