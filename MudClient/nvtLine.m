//
//  nvtLine.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 10/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "nvtLine.h"
#import "MudClientIpad4AppDelegate.h"
#import "MudSession.h"
#import "MudDataSettings.h"
#import "UIFont+CoreTextExtensions.h"

@implementation nvtLine

@synthesize  swapColors, encoding, font, locale;



-(float)heightForCurrentFont {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByClipping;
    
    CGSize textSize = [@"A" sizeWithAttributes:@{
                                                 NSFontAttributeName : self.font,
                                                 NSParagraphStyleAttributeName : [style copy],
                                                 
                                                 }];
    return textSize.height;
    
}

-(CGFloat)widthForCurrentFont {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByClipping;
    CGSize textSize = [@"Z" sizeWithAttributes:@{
                                                 NSFontAttributeName : self.font,
                                                 NSParagraphStyleAttributeName : [style copy],
                                                 
                                                 }];
    //NSLog(@"f = %@ s = %f", self.font, textSize.width);
    return textSize.width;
}


- (int)charCount {
	return lineArrayLength;
}

- (void)setupString:(int)startColor startingBold:(BOOL)startingBold {
	lineArrayLength = 0;
	
	if (startColor == -1 ) {
		startColor = 2;
	}
    
	startingColor = startColor;

	operationNumber = 0;
	colorArray[operationNumber] = colorArray[startColor];
	locationArray[operationNumber] = 0;
	lengthArray[operationNumber] = 0;

	[self changeColor:startColor colorBold:startingBold];
    //NSLog(@"Resetting nvtLine: starting color: %d", startColor);
}


- (void)addCharacter:(unsigned char)character {
	
	if (lineArrayLength >= lineTextLengthMax) {
		NSLog(@"Refusing to add > 8096 characters to a line.");
		return;
	}
	
	lineArray[lineArrayLength] = character;
	lineArrayLength++;

	lengthArray[operationNumber]++;
	if ((unsigned int)character > 127) {
		NSLog(@"Added character >127 : %c [%d]" , character, (unsigned int)character);
	}
}

- (void)changeColor:(int)newColor colorBold:(BOOL)colorBold {
	// complete current operation;
	
	lengthArray[operationNumber] = lineArrayLength - locationArray[operationNumber];
	
	if (lineArrayLength >0) {
		operationNumber++;
	
		if (operationNumber >= maxANSIAttributesPerLine) {
			operationNumber = maxANSIAttributesPerLine;
			NSLog(@">maxANSIAttributesPerLine");
			return;
		}

	} 
	locationArray[operationNumber] = lineArrayLength ? lineArrayLength : 0;
	colorArray[operationNumber] = newColor;
	boldArray[operationNumber] = colorBold;
	lengthArray[operationNumber] = 0;
	
	//NSLog(@"Changed color: %d %d", newColor, colorBold);
}


- (NSAttributedString *) copyAttributedString {
	//UIFont *lineFont = [UIFont fontWithName:@"Courier" size:15.0f];
	
	UIColor *baseColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.8];
	
	lineArray[lineArrayLength] = 0x0;
    
    NSString *cfLineN = [[NSString alloc] initWithBytes:lineArray length:lineArrayLength encoding:NSUTF8StringEncoding];
    
    if ((!cfLineN) || ([cfLineN length]<1)) {
        return [[NSAttributedString alloc] initWithString:@""];
    }
    
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByClipping;

    
    NSMutableAttributedString *ourString = [[NSMutableAttributedString alloc] initWithString:cfLineN attributes:@{ NSParagraphStyleAttributeName : style }];

    int length = [ourString length];
    [ourString addAttribute:NSForegroundColorAttributeName value:baseColor range:NSMakeRange(0,length)];
    [ourString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, length)];
    
	int lineLen = [ourString length];
	int lastRout = -1;
	
	lengthArray[operationNumber] = lineLen - (locationArray[operationNumber]);
	
    //NSLog(@"copyAttributedString: %d", operationNumber);
    
	for (int x=0;x<=operationNumber;x++) {
		NSRange rout;
		rout.length = lengthArray[x];
		rout.location = locationArray[x];
		
		if (rout.length<1) {
			continue;
		}
		/*
		if (rout.location <= lastRout) {
			continue;
		}
		*/
        
		int color = colorArray[x];
		
		
		if (boldArray[x]) {
			if (color >= 8) { 
				color -=8;
			} else {
				color += 8;
			}
		}
		
		if (!self.swapColors) {
			if (color >= 8) { 
				color -=8;
			} else {
				color += 8;
			}
		}
		
		UIColor *thisColor = nil;
		
	
		if ( (!self.swapColors) && (color == bColorBlack) ) {
			color = aColorBlack;
		} else if ((!self.swapColors) && (color == aColorBlack) ) {
		    color = bColorBlack;
		} 	
		
		switch (color) {
			case aColorBlack:
				thisColor = [UIColor blackColor];
				break;
			case aColorRed:
				thisColor = [UIColor redColor];
				break;
			case aColorGreen:
				thisColor = [UIColor greenColor];
				break;
			case aColorYellow:
				thisColor = [UIColor yellowColor];
				break;
			case aColorBlue:
				thisColor =  [UIColor blueColor];
				break;
			case aColorMagenta:
				thisColor = [UIColor magentaColor];
				break;
			case aColorCyan:
				thisColor = [UIColor cyanColor];
				break;
			case aColorWhite:
				thisColor = [UIColor whiteColor];
				break;
			case bColorBlack:
				thisColor =[UIColor colorWithWhite:0.5f alpha:0.8f];
				break;
			case bColorRed:
				thisColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.8];
				break;
			case bColorGreen:
				thisColor = [UIColor colorWithRed:0.0 green:0.99 blue:0.0 alpha:0.81];
				break;
			case bColorYellow:
				thisColor =  [UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:0.8];
				break;
			case bColorBlue:
				thisColor =[UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.8];
				break;
			case bColorMagenta:
				thisColor = [UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:0.8];
				break;
			case bColorCyan:
				thisColor = [UIColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:0.8];
				break;
			case bColorWhite:
				thisColor = [UIColor colorWithWhite:1.0 alpha:0.7];
				break;
				
		}
        if (!thisColor) {
            NSLog(@"Color not present in attribute set");
            continue;
        }
        int strLen = [ourString length];
		if (strLen > 0) {
			if (rout.location > strLen) {
				NSLog(@"Avoiding bad ansi attributing crash");
			} else if ( rout.location + rout.length > strLen) {
				NSLog(@"Avoiding bad ansi attributing crash2");
			} else {
                [ourString addAttribute:NSForegroundColorAttributeName value:thisColor range:rout];
                // NSLog(@"Setting color %@ for range: %d, %d", thisColor, rout.location, rout.length);
            }
		}
		lastRout = rout.location;
	}
	return ourString;
}


- (NSMutableAttributedString *)copyScreenMessage:(NSString *)message color:(int)color {
	
    UIFont *lineFont = [UIFont fontWithName:@"Courier" size:15.0f];
    
	UIColor *baseColor  = nil;
	
	switch (color) {
		case 0:
			baseColor = [UIColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:0.99];
			break;
		case 1:
			baseColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.99];
			break;
	}
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByClipping;
   

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:message attributes:@{ NSParagraphStyleAttributeName : style }];
    int length = [attrStr length];
    [attrStr addAttribute:NSForegroundColorAttributeName value:baseColor range:NSMakeRange(0,length)];
    [attrStr addAttribute:NSFontAttributeName value:lineFont range:NSMakeRange(0, length)];
	return attrStr;
}

@end
