//
//  AttributedCellView.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AttributedCellView.h"
#import <CoreText/CoreText.h>


@implementation AttributedCellView

@synthesize attrString;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization c
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    
 CGContextRef CGcontext = UIGraphicsGetCurrentContext();
 CGAffineTransform flip = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, self.frame.size.height);
 CGContextConcatCTM(CGcontext, flip);
 
 CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)self.attrString);

 // Set text position and draw the line into the graphics context
 CGContextSetTextPosition(CGcontext, 0.0, 5.0);
 CTLineDraw(line, CGcontext);
 CFRelease(line);

}


- (void)dealloc {
    [super dealloc];
}


@end
