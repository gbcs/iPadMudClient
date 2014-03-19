//
//  NewConnectionMudsByName.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewConnectionMudsByName: UIViewController  <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, UISearchBarDelegate> {
	UITableView *tableview;
	NSMutableArray *mudList;
	NSMutableArray *mudListHost;
	NSMutableArray *mudListPort;
	UISearchBar *sBar;
	UILabel *creditLabel;
}

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *mudList;
@property (nonatomic, strong) NSMutableArray *mudListHost;
@property (nonatomic, strong) NSMutableArray *mudListPort;
@property (nonatomic, strong) UISearchBar *sBar;

- (void)loadMUDList:(NSString *)searchPrefix;

@end
