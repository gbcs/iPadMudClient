//
//  UIFont+CoreTextExtensions.m
//  CoreTextWrapper
//
//  Created by Adrian on 4/24/10.
//  Copyright 2010 akosma software. All rights reserved.
//

#import "UIFont+CoreTextExtensions.h"

@implementation UIFont (CoreTextExtensions)

- (CTFontRef)CTFont
{
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)self.fontName, self.pointSize, NULL);
    return font;
}

@end
