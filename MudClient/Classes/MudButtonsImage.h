//
//  MudButtonsImage.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MudButtonsDetail.h"


@interface MudButtonsImage: UIViewController <UIScrollViewDelegate> {
	UIScrollView *scrollView;
	NSObject *parentView;
	
	UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSObject *parentView;

@end
