//
//  KeyboardViewController.m
//  Mud Client Remote
//
//  Created by Gary Barnett on 9/27/13.
//  Copyright (c) 2013 gbcs. All rights reserved.
//

#import "KeyboardViewController.h"

@interface KeyboardViewController () {
    UIView *inputView;
    UITextView *inputTextView;
    NSMutableArray *sentLines;
    UITableView *tv;
}

@end

@implementation KeyboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)userTappedHistory {
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        BOOL found = ([sentLines indexOfObject:textView.text] != NSNotFound);
        if (!found) {
            [sentLines addObject:textView.text];
            textView.selectedRange = NSMakeRange(0,[textView.text length]);
        }

        [[RemoteClient tool] userTypedText:textView.text];
        
        if (!found) {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:[sentLines count]-1 inSection:0];
            [tv insertRowsAtIndexPaths:@[ ip ] withRowAnimation:UITableViewRowAnimationNone];
            [tv scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        return NO;
    }
    return YES;
}

-(void)userTappedClose {
    [[RemoteClient tool] disconnect];
    [[RemoteClient tool] gotoMenu];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)loadView
{
    [super loadView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    sentLines = [[NSMutableArray alloc] initWithCapacity:100];
    
    BOOL landscape = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    CGRect r = CGRectMake(0,0, landscape ? bounds.size.height : bounds.size.width, landscape ? bounds.size.width : bounds.size.height);
    
    self.view = [[UIView alloc] initWithFrame:r];
   
    inputView = [[UIView alloc] initWithFrame:CGRectMake(0,r.size.height - 30,r.size.width, 30)];
    [self.view addSubview:inputView];
    
    inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(0,0,r.size.width, r.size.height)];
    inputTextView.backgroundColor = [UIColor clearColor];
    [inputTextView setFont:[UIFont systemFontOfSize:17]];
    inputTextView.textAlignment = NSTextAlignmentLeft;
    [inputTextView setTextColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
    inputTextView.delegate = self;
    
    [inputView addSubview:inputTextView];
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0,0, r.size.width, r.size.height)];
    tv.delegate = self;
    tv.dataSource = self;
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    tv.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    [self.view addSubview:tv];

    [[NSNotificationCenter defaultCenter]  addObserver:self   selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self   selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionListUpdated:) name:@"ConnectionList" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self   selector:@selector(sentTextFull:) name:@"sentTextFull" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self   selector:@selector(sentTextAdd:) name:@"sentTextAdd" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self   selector:@selector(appendText:) name:@"appendText" object:nil];

    
    inputTextView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:1.0];
    
}

-(void)updateTextView:(NSArray *)lines {
    if (!lines) {
        return;
    }
    
    if ([lines count]<1) {
        return;
    }
    
    for (NSString *line in lines) {
        inputTextView.text =  [[inputTextView.text stringByAppendingString:line] stringByAppendingString:@"\n"];
    }
}

-(void)sentTextFull:(NSNotification *)n {
    sentLines = [(NSArray *)n.object mutableCopy];
    [tv performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(scrollToEnd) withObject:nil waitUntilDone:NO];
}

-(void)scrollToEnd {
    if ( (!sentLines) || ([sentLines count]<1)) {
        return;
    }
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:[sentLines count]-1 inSection:0];
    [tv scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

-(void)sentTextAdd:(NSNotification *)n {
    NSString *line = (NSString *)n.object;
    [sentLines addObject:line];
    [tv performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(scrollToEnd) withObject:nil waitUntilDone:NO];
}

-(void)appendText:(NSNotification *)n {
    NSString *text = (NSString *)n.object;
    if (text) {
        [self performSelectorOnMainThread:@selector(appendText2:) withObject:text waitUntilDone:NO];
    }
}

-(void)appendText2:(NSString *)text {
    inputTextView.text = [NSString stringWithFormat:@"%@%@",
                          inputTextView.text ? inputTextView.text : @"",
                          text ? text : @""];
}

- (void) keyboardWillHide:(NSNotification *)nsNotification {
 //   NSDictionary *userInfo = [nsNotification userInfo];
   // CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
   // NSLog(@"hide:Height: %f Width: %f", kbSize.height, kbSize.width);

}

-(void)connectionListUpdated:(NSNotification *)n {
    [self performSelectorOnMainThread:@selector(updateToolbar) withObject:nil waitUntilDone:YES];
    [[RemoteClient tool] performSelectorOnMainThread:@selector(requestSentText) withObject:nil waitUntilDone:NO];
}

-(void)updateToolbar {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItems = [[RemoteClient tool] toolbarButtonsForCurrentConnectionList];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(userTappedClose)];
}

- (void) keyboardWasShown:(NSNotification *)nsNotification {
    NSDictionary *userInfo = [nsNotification userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
  //  NSLog(@"show:Height: %f Width: %f", kbSize.height, kbSize.width);
    
    BOOL landscape = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
   
    CGFloat keyboardHeight = 0.0f;
    
    if (landscape) {
        keyboardHeight = kbSize.width;
    } else {
        keyboardHeight = kbSize.height;
    }
  
    
 //   BOOL isiPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    
    CGFloat inputPoint = self.view.frame.size.height - (keyboardHeight + 30);
    
    inputTextView.frame = CGRectMake(0,0, self.view.frame.size.width, 30);
    inputView.frame = CGRectMake(0,inputPoint,inputTextView.bounds.size.width, 30);
    tv.frame = CGRectMake(0,0,self.view.frame.size.width, inputPoint);
    [self updateToolbar];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    [inputTextView becomeFirstResponder];
    [[RemoteClient tool] performSelectorInBackground:@selector(requestSentText) withObject:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)t {
    
    [self performSelector:@selector(scrollToEnd) withObject:nil afterDelay:0.25];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 30.0f;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Only one section.
    return 1;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [sentLines count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
	cell.textLabel.text = [sentLines objectAtIndex:indexPath.row];
	  
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    inputTextView.text = [sentLines objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [inputTextView becomeFirstResponder];
}

@end
