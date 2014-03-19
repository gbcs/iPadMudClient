//
//  NewConnectionDetail.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MudDataCharacters.h"

@interface NewConnectionDetail : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
}

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) MudDataCharacters *element;
@property (nonatomic, strong) NSObject *parentView;
@property (nonatomic, strong) NSManagedObjectContext *context;

-(void)updateLocaleStr:(NSString *)str;
-(void)updateEncoding:(NSInteger)enc;
-(void)updateFont:(UIFont *)font atSize:(CGFloat )size;

@end
