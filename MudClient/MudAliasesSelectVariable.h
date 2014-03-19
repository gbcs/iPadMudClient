//
//  MudAliasesSelectVariable.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 11/10/12.
//
//

#import <UIKit/UIKit.h>

@interface MudAliasesSelectVariable : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate> {
	UITableView *tv;
}

@property (nonatomic, strong) UITableView *tv;

@end
