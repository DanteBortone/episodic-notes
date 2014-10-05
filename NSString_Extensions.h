/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//  From Jacob Relkin Stack Overflow


//---------------------------------------------
#import <Cocoa/Cocoa.h>
//---------------------------------------------


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

