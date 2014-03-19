//
//  RegExpTools.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RegExpTools.h"

@implementation RegExpTools 

// take a string, split it with some regexp and return the components as a mutable array
+(NSMutableArray *)arrayOfComponentsFromString:(NSString *)sourceStr withRegExp:(NSString *)regexp {
    NSMutableArray *components = [NSMutableArray arrayWithCapacity:100];    

    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexp options:0 error:&error];
    // enumerate all matches
    if ((regex==nil) && (error!=nil)){
        NSLog( @"Regex failed: %@, error was: %@", regex, error);
    } else {
        [regex enumerateMatchesInString:sourceStr 
                                options:0 
                                  range:NSMakeRange(0, [sourceStr length]) 
                             usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop){
                                 if (result!=nil){
                                     //iterate ranges
                          
                                     for (int i=0; i<[result numberOfRanges]; i++) {
                                         NSRange range = [result rangeAtIndex:i];
                                         
                                         int lastEnding = 0;
                                         
                                         int componentCount = [components count];
                                         
                                         if (componentCount > 0) {
                                             NSArray *lastComponent = [components objectAtIndex:componentCount-1];
                                             lastEnding = [[lastComponent objectAtIndex:0] intValue]  + [[lastComponent objectAtIndex:1] intValue];
                                         }
                                         
                                         NSArray *newComponent = [NSArray arrayWithObjects:[NSNumber numberWithInt:lastEnding],[NSNumber numberWithInt:range.location - lastEnding], nil];
                                         [components addObject:newComponent];
                                         // NSLog(@"Adding section: %d %d", lastEnding, range.location - lastEnding);
                                     
                                     }
                                 }
                             }];
    }

    NSMutableArray *componentStrings = [NSMutableArray arrayWithCapacity:100];   
       
    if ([componentStrings count]>0) {
        int sourceStrUsedIndex = 0;
        for (NSArray *a in components) {
            NSRange r;
            r.location = [[a objectAtIndex:0] intValue];
            r.length = [[a objectAtIndex:1] intValue];
            [componentStrings addObject:[sourceStr substringWithRange:r]];
            int usedIndex = r.location + r.length;
            if (sourceStrUsedIndex < usedIndex) {
                sourceStrUsedIndex = usedIndex;
            }
        }
        
        if (sourceStrUsedIndex < [sourceStr length]) {
            NSRange r;
            r.location = sourceStrUsedIndex;
            r.length = [sourceStr length] - sourceStrUsedIndex;
            [componentStrings addObject:[sourceStr substringWithRange:r]];
        }
    } else {
        [componentStrings addObject:sourceStr];
    }
  
    return componentStrings;
}

+(NSString *)replaceMatchesInString:(NSString *)sourceStr usingRegExp:(NSString *)regexp withTemplate:(NSString *)templateStr caseSensitivity:(BOOL)caseSensitivity {
  
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexp
                                                                           options:caseSensitivity ?  0 : NSRegularExpressionCaseInsensitive
                                                                             error:&error
                                  ];
    
    
    NSString *updatedStr = [regex stringByReplacingMatchesInString:sourceStr
                                                               options:0
                                                                 range:NSMakeRange(0, [sourceStr length])
                                                      withTemplate:templateStr //@"<a href=\"$1\">$1</a>"
                            ];
    
    return updatedStr;
}

+(NSMutableArray *)arrayOfCaptureComponentMatches:(NSString *)sourceStr withRegExp:(NSString *)regexp {
    BOOL caseSensitivity = NO;
    
    NSError *error = NULL;


    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexp
                                                                           options:caseSensitivity ?  0 : NSRegularExpressionCaseInsensitive
                                                                             error:&error
                                  ];

    NSArray *matchList = [regex matchesInString:sourceStr options:0 range:NSMakeRange(0,[sourceStr length])];
    
    
    if ( (!matchList) || ([matchList count] <1) ) {
        return nil;
    }
    
    NSMutableArray *matches = [NSMutableArray arrayWithCapacity:100];
    
    for (NSTextCheckingResult *result in matchList) {
        for (int x=1;x<result.numberOfRanges;x++) {
            [matches addObject:[sourceStr substringWithRange:[result rangeAtIndex:x]]];
        }
    }
    
    if ([matches count] == 0) {
        [matches addObject:sourceStr];
    }
    
   // NSLog(@"arrayOfCaptureComponentMatches:%@:%@:%@", sourceStr, regexp, matches);
    
  
    return matches;
}

@end
