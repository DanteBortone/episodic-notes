//
//  NSString_Extensions.h
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 8/1/12.
//  Copyright 2012 UNC-Chapel Hill. All rights reserved.
//  From Jacob Relkin Stack Overflow


#import <Cocoa/Cocoa.h>


@interface NSString (DBStringAdditions) 

+ (NSString *) stringWithUnichar: (unichar) value;
- (NSString *) wikiStyleString;

//+ (NSString *) stringFromCharacterSet: (NSCharacterSet *) characterSet;

- (BOOL) containsString:(NSString *) string;
- (BOOL) containsString:(NSString *) string options:(NSStringCompareOptions) options;
- (NSString *) firstWords:(NSInteger)maxWords;
- (NSDate *) toDateFromFormat:(NSString *)formatString; //usually @"yyyyMMdd"
- (BOOL) beginsWithString:(NSString *) string;
- (NSArray *) wordRangesWithSeparators:(NSCharacterSet *) separators;
- (BOOL) containsCharacters:(NSCharacterSet *) characterSet;


@end

