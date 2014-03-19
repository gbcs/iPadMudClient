//
//  NewConnectionMudList.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewConnectionMudList: UIViewController  <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate> {
	UITableView *tableview;
	int which;

}

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic) int which;

@end
