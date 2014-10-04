//
//  NSString_Extensions.m
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 8/1/12.
//  Copyright 2012 UNC-Chapel Hill. All rights reserved.
//


//---------------------------------------------
#import "NSString_Extensions.h"
//---------------------------------------------


@implementation NSString (DBStringAdditions) 


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

+ (NSString *) stringWithUnichar:(unichar) value {
  
  NSString *str = [NSString stringWithFormat: @"%C", value];
  return str;

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSString *) wikiStyleString {
  
  unichar firstLetter;
  NSString * string;
  
  firstLetter = [self characterAtIndex:0];
  
  string = [self capitalizedString];

  string = [string stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[NSString stringWithUnichar:firstLetter]];

  string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
  
  return string;
  
}

//+ (NSString *) stringFromCharacterSet: (NSCharacterSet *) characterSet {
//}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL) containsString:(NSString *) string
                options:(NSStringCompareOptions) options {
  NSRange rng = [self rangeOfString:string options:options];
  return rng.location != NSNotFound;
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL) beginsWithString:(NSString *) string {

  NSString * subString;
  NSRange range = NSMakeRange(0, string.length);

  if (self.length < string.length) {

    return FALSE;

  } else {
    
    subString = [self substringWithRange:range];
    return [string isEqualToString:subString];

  }
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL) containsString:(NSString *) string {
  return [self containsString:string options:NSCaseInsensitiveSearch];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSString *) firstWords:(NSInteger)maxWords{

  NSArray *theWords = [self componentsSeparatedByString:@" "];

  if ([theWords count] < maxWords) {
    maxWords = [theWords count];
  }
  
  NSRange wordRange = NSMakeRange(0, maxWords);
  NSArray *firstWords = [theWords subarrayWithRange:wordRange];             
  
  return [firstWords componentsJoinedByString:@" "];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSDate *) toDateFromFormat:(NSString *)formatString {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:formatString];
  NSDate *dateFromString = [dateFormatter dateFromString:self];
  return dateFromString;
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//returns an array of nsvalue ranges for all of the accepted words found
- (NSArray *) wordRangesWithSeparators:(NSCharacterSet *) separators {
  
  NSMutableArray * ranges = [NSMutableArray array];
  NSRange wordRange;
  NSUInteger stringLength;
  Boolean unfinishedWord;
  
  unfinishedWord = NO;
  
  stringLength = self.length;
  
  for (int i = 0 ; i < stringLength; i+=1) {

    if (![separators characterIsMember:[ self characterAtIndex:i ]]) {

      wordRange.location = i;
      
      unfinishedWord = YES;

      for (int j = i; j < stringLength; j+=1){

        if ([separators characterIsMember:[self characterAtIndex:j]]) {

          unfinishedWord = NO;
          
          wordRange.length = j - wordRange.location;
          
          [ranges addObject:[NSValue valueWithRange:wordRange]];
          
          break;
          
        }

        i = j;
        
      }
      
    }

  }
  
  if (unfinishedWord) {
      
    wordRange.length = stringLength - wordRange.location;
      
    [ranges addObject:[NSValue valueWithRange:wordRange]];
    
  }
  
  return [ranges copy];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL) containsCharacters:(NSCharacterSet *) searchCharacters {
  

  NSRange badCharRange = [self rangeOfCharacterFromSet: searchCharacters ];
  
  if (badCharRange.location == NSNotFound) {
    
    return NO;
    
  } else {

    return YES;

  }
  
  
}



@end


