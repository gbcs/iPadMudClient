//
//  introPage.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface introPage : UIViewController   {
	//UILabel *versionLabel;
	UILabel *supportLabel;
	UIButton *supportButton;
	UILabel *header;
	UILabel *releaseNotes;
}

-(void)positionViews:(UIInterfaceOrientation )forOrientation ;
@end