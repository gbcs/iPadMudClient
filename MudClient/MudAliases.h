//
//  MudAliases.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 11/10/12.
//
//

#import <UIKit/UIKit.h>
#import "MudClientIpad4ViewController.h"
#import "MudDataAliases.h"
#import "MudVariablesDetail.h"

@interface MudAliases : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPopoverControllerDelegate> {
	UITableView *tv;
	MudDataAliases *element;
}

@property (nonatomic, strong) UITableView *tv;
@property (nonatomic, strong) MudDataAliases *element;

-(void)SaveEditedRecord;
@end
