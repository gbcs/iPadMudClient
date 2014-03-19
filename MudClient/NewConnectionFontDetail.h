//
//  NewConnectionFontDetail.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewConnectionFontDetail : UIViewController {

	UILabel *fontName;
	UITextView *sample;
    
    UILabel *fontSize;
    UILabel *charactersInPortrait;
    
}

@property (nonatomic, strong) UIFont *characterFont;
@property (nonatomic, assign) CGFloat characterFontSize;
@end
