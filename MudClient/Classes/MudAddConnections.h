//
//  MudAddConnections.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewConnectionDetail.h"
#import "MudClientIpad4ViewController.h"


@interface MudAddConnections : UIViewController <UITableViewDelegate, UIPopoverControllerDelegate, UITableViewDataSource> {
	UITableView *tv;
	NSManagedObjectContext *context;
	
	NSIndexPath *iPath;
	MudClientIpad4ViewController *topController;
	MudDataCharacters *element;
	
}

@property (nonatomic, strong) UITableView *tv;
@property (nonatomic, strong) NSManagedObjectContext *context;

@property (nonatomic, strong) NSIndexPath *iPath;
@property (nonatomic, strong) MudClientIpad4ViewController *topController;
@property (nonatomic, strong) MudDataCharacters *element;



-(void)SaveAndUpdateView;
-(void)AddButtonClicked;
-(void)FindMUDButtonClicked;


@end
