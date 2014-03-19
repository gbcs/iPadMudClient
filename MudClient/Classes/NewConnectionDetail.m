    //
//  NewConnectionDetail.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NewConnectionDetail.h"
#import "MudAddConnections.h"
#import "MudClientIpad4AppDelegate.h"
#import "MudConnectionLocale.h"
#import "MudConnectionEncoding.h"
#import "NewConnectionFont.h"

@implementation NewConnectionDetail {
    int encoding;
	NSString *serverTitleStr;
	NSString *hostNameStr;
	NSString *tcpPortStr;
	NSString *characterNameStr;
	NSString *passwordStr;
	UIFont *characterFont;
    NSString *localeStr;
    CGFloat fontSizeFloat;
}

-(void)SaveButtonClicked {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	int newChar = 0;
	
    if ( (!serverTitleStr) || ([serverTitleStr length] <1)) {
        return;
    }
    
    if ( (!hostNameStr) || ([hostNameStr length] <1)) {
        return;
    }
    
    if ( (!tcpPortStr) || ([tcpPortStr length] <1)) {
        return;
    }
    
    if ( (!localeStr) || ([localeStr length] <1)) {
        return;
    }
	
	int port = [tcpPortStr intValue];
	
	if ( (port <1) | (port >65535)) {
		return;
	}
	
	if (!self.element) {
		MudDataCharacters *char1 = (MudDataCharacters *)[NSEntityDescription insertNewObjectForEntityForName: @"MudDataCharacters" inManagedObjectContext:self.context];
		self.element = char1;
		MudAddConnections *pv = (MudAddConnections *)self.parentView;
		pv.element = char1;
		[self.element setSlotID:[NSNumber numberWithInt:[myAppDelegate findNewSlotID]]];
		newChar = 1;
		
		
	}
	
	[self.element setFont:[characterFont fontName]];
	[self.element setFontSize:[NSNumber numberWithFloat:fontSizeFloat]];
	
    NSLog(@"saved font: %@:%f", [characterFont fontName], [characterFont pointSize]);
    
	[self.element setEncoding:[NSNumber numberWithInt:encoding]];
	
	[self.element setSSL:@NO];
	
	[self.element setLang:localeStr];
	
	[self.element setServerTitle:serverTitleStr];
	[self.element setHostName:hostNameStr];
	[self.element setTcpPort:[NSNumber numberWithInt:[tcpPortStr intValue]]];
	[self.element setCharacterName:characterNameStr];
	[self.element setPassword:passwordStr];
    
	if (![[self.element slotID] boolValue]) {
		[self.element setSlotID:[NSNumber numberWithInt:[myAppDelegate findNewSlotID]]];
	}
			
	[(MudAddConnections *)self.parentView SaveAndUpdateView];
	
	if (newChar) {
		[myAppDelegate createInitialCharacterData:self.element];
	}
	
    [myAppDelegate saveCoreData];
	
	[self.navigationController popToRootViewControllerAnimated:YES];
	 
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    int t = textField.tag - 2000;
    
    int section = t / 10;
    int row = t - (section * 10);
    
    NSString *updatedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"should change:%d:%d", section, row);
    if (section == 0) {
        switch (row) {
            case 0:
                serverTitleStr = updatedText;
                break;
            case 1:
                hostNameStr = updatedText;
                break;
            case 2:
                tcpPortStr = updatedText;
                break;
        }
    } else if (section == 1) {
        switch (row) {
            case 0:
                characterNameStr = updatedText;
                break;
            case 1:
                passwordStr = updatedText;
                break;
        }
    }

    return YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// As many rows as there are obects in the events array.
	switch (section) {
		case 0:
#ifdef MCSSL
				return 7;
#else
				return 6;
#endif
			
		
		case 1:
			return 2;
	}
		
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	switch (section) {
		case 0:
			return @"Server";
			break;
		case 1:
			return @"Character";
			break;
	}
	
	return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	int section = indexPath.section;
	int row = indexPath.row;
	
	NSString *labeltext = nil;
	NSString *hinttext = nil;
    NSString *textFieldText = nil;
    
	UILabel *label1 = nil;
	UITextField *textField = nil;
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"character"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"character"];
    }
    
    while ([cell.contentView.subviews count]>0)  {
        [[cell.contentView.subviews objectAtIndex:0] removeFromSuperview];
    }
    
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(20,10,140,30)];
    [cell.contentView addSubview:label1];
    label1.textAlignment = NSTextAlignmentRight;
    label1.font = [UIFont boldSystemFontOfSize:12];
    label1.backgroundColor = [UIColor clearColor];
    label1.tag = 1000;
    
    CGRect textFieldFrame = CGRectMake(180.0, 5.0, self.view.frame.size.width - 200, 40.0);
   
    textField = [[UITextField alloc] initWithFrame:textFieldFrame];
    textField.keyboardAppearance = UIKeyboardAppearanceDark;
    [cell.contentView addSubview:textField];

   
    [textField setTextColor:[UIColor blackColor]];
    [textField setFont:[UIFont boldSystemFontOfSize:14]];
    [textField setDelegate:self];
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    [textField setBackgroundColor:[UIColor clearColor]];
    textField.keyboardType = UIKeyboardTypeDefault;
    
  
   
	cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (section == 0) {
        
        switch (row) {
            case 0:
            {
                labeltext = @"Name";
                hinttext = @"required";
                textFieldText = serverTitleStr;
            }
                break;
            case 1:
            {
                labeltext = @"Address";
                hinttext = @"required (hostname or ip address)";
                textFieldText = hostNameStr;
            }
                break;
            case 2:
            {
                labeltext = @"Port";
                hinttext = @"required (number)" ;
                textFieldText = tcpPortStr;
            }
                break;
            case 3:
            {
                labeltext = @"Locale";
                textFieldText = localeStr;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 4:
            {
                labeltext = @"Encoding";
                
                NSString *encodingLabel = [MudConnectionEncoding encodingNameFromVal:encoding];
                
                textFieldText = encodingLabel;
                
                textField.userInteractionEnabled = NO;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            }
                break;
            case 5:
            {
                labeltext = @"Font";
				textFieldText = characterFont.fontName;
                [textField setFont:characterFont];
       
                textField.userInteractionEnabled = NO;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				
            }
                break;
#ifdef MCSSL
            case 6:
            {
                /*
                labeltext = @"Secure Connection";
                label1.frame = CGRectMake(20,15,140,20);
                textField.frame = CGRectZero;
                if (self.useSSL) {
                    [cell.contentView addSubview:self.useSSL];
                } else {
                    self.useSSL = [[UISwitch alloc] initWithFrame:CGRectMake(180.0, 10.0, 100.0, 20.0)];
                    [self.useSSL setOn:[[self.element SSL] boolValue]];
                    [cell.contentView addSubview:useSSL];
                }
                UILabel *SSLDetail = [[UILabel alloc] initWithFrame:CGRectMake(300,15,180,15)];
                [SSLDetail setText:@"SSL support required on host"];
                SSLDetail.font = [UIFont systemFontOfSize:12];
                SSLDetail.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:SSLDetail];
                 */

            }
                break;
#endif
                
                
        }
    } else if (section == 1) {
        switch (row) {
            case 0:
            {
                labeltext = @"Character's Name";
                hinttext = @"optional; used by auto-login macro";
                textFieldText = characterNameStr;
                
            }
                
                break;
            case 1:{
                labeltext = @"Character's Password";
                hinttext = @"optional; used by auto-login macro";
                textFieldText = passwordStr;
                [textField setSecureTextEntry:YES];
            }break;
        }
    }
    
    [label1 setText:labeltext];
    [textField setPlaceholder:hinttext];
    [textField setText:textFieldText];
	
    textField.tag = (indexPath.section * 10 ) + indexPath.row + 2000;
    textField.enabled = (cell.accessoryType != UITableViewCellAccessoryDisclosureIndicator);
    cell.selectionStyle = (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator) ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
	self.navigationController.toolbarHidden = YES;
    UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
		self.tableview.frame = CGRectMake(0,0,560,270);
		CGSize contentSize;
		contentSize.width = 560;
		contentSize.height = 290;
		self.preferredContentSize = contentSize;
	} else {
		self.tableview.frame = CGRectMake(0,0,560,600);
		CGSize contentSize;
		contentSize.width = 560;
		contentSize.height = 620;
		self.preferredContentSize = contentSize;
	}

	[self.tableview reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 3:
            {
                MudConnectionLocale *uv = [[MudConnectionLocale alloc ] init];
                [self.navigationController pushViewController:uv animated:YES];
            }
                break;
            case 4:
            {
                MudConnectionEncoding *uv = [[MudConnectionEncoding alloc ] init];
				[self.navigationController pushViewController:uv animated:YES];

            }
                break;
            case 5:
            {
               	NewConnectionFont *uv = [[NewConnectionFont alloc ] init];
				[self.navigationController pushViewController:uv animated:YES];
            }
                break;
        }
    }
    
    return;
   
		
}

-(void)updateLocaleStr:(NSString *)str {
    if (str) {
        localeStr = str;
    }
    [self.tableview reloadData];
}

-(void)updateEncoding:(NSInteger)enc {
        encoding = enc;
    [self.tableview reloadData];
}

-(void)updateFont:(UIFont *)font atSize:(CGFloat )size {
    if (font) {
        characterFont = font;
        fontSizeFloat = size;
    }
    [self.tableview reloadData];
}

- (void)loadView {
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 620)];	
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	MudAddConnections *v = [self.navigationController.viewControllers objectAtIndex:0];
	MudDataCharacters *e = v.element;
	
	self.element = e;
	self.context = v.context;
	self.parentView = v;

	if (self.element) {
		self.navigationItem.title = @"Edit Character";
		UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(SaveButtonClicked)];
		self.navigationItem.rightBarButtonItem = rb;
        
        encoding = [self.element.encoding integerValue];
        serverTitleStr = self.element.serverTitle;
        hostNameStr = self.element.hostName;
        tcpPortStr = [self.element.tcpPort stringValue];
        characterNameStr = self.element.characterName;
        passwordStr = self.element.password;
        characterFont = [UIFont fontWithName:self.element.font size:[self.element.fontSize floatValue]];
        fontSizeFloat = [self.element.fontSize floatValue];
        localeStr = self.element.lang;
	} else {
        encoding = 0;
        serverTitleStr = @"";
        hostNameStr = @"";
        tcpPortStr = @"";
        characterNameStr = @"";
        passwordStr = @"";
        characterFont = [UIFont fontWithName:@"Menlo-Regular" size:14.5];
        fontSizeFloat = 14.5;
        localeStr = @"en_US";
       
		self.navigationItem.title = @"Add Character";
		UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(SaveButtonClicked)];
		self.navigationItem.rightBarButtonItem = rb;
	}
	
	UITableView *tc = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,420) style:UITableViewStyleGrouped];
	tc.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	
	tc.delegate = self;
	tc.dataSource = self;
	
	[self.view addSubview:tc];
	
	self.tableview = tc;

}

- (void)viewDidLoad {
    [super viewDidLoad];	
		

}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




@end
