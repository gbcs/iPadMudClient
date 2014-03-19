//
//  nvtLine.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 10/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>


// default colors

#define aColorBlack		0
#define aColorRed		1
#define aColorGreen		2
#define aColorYellow	3
#define aColorBlue		4
#define aColorMagenta	5
#define aColorCyan		6
#define aColorWhite		7
#define bColorBlack		8
#define bColorRed		9
#define bColorGreen		10
#define bColorYellow	11
#define bColorBlue		12
#define bColorMagenta	13
#define bColorCyan		14
#define bColorWhite		15

#define lineTextLengthMax		8096



#define maxANSIAttributesPerLine 150

@interface nvtLine : NSObject {

    NSMutableArray *lineOps;
    
	unsigned char lineArray[lineTextLengthMax];
	int lineArrayLength;
	
	int locationArray[maxANSIAttributesPerLine];
	int lengthArray[maxANSIAttributesPerLine];
	int colorArray[maxANSIAttributesPerLine];
	int boldArray[maxANSIAttributesPerLine];

	int operationNumber;
	int swapColors;
	
	int startingColor;
	
	int encoding;

	NSLocale *locale;
	
}



@property (nonatomic) int swapColors;
@property (nonatomic) int encoding;
@property (nonatomic, strong) NSLocale *locale;
@property (nonatomic, strong) UIFont *font;


- (void)setupString:(int)startColor startingBold:(BOOL)startingBold;
- (int)charCount;
- (void)addCharacter:(unsigned char)character;
- (void)changeColor:(int)newColor colorBold:(BOOL)colorBold;
- (NSAttributedString *)copyAttributedString;
- (NSAttributedString *)copyScreenMessage:(NSString *)message color:(int)color;
- (float)heightForCurrentFont;
-(float)widthForCurrentFont;
@end
