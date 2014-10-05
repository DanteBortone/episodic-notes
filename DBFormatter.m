/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBFormatter.h"
//---------------------------------------------

#import "NSCharacterSet_Extensions.h"

//---------------------------------------------


@implementation DBFormatter


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib {
  
  prohibitedCharacters = [NSCharacterSet characterSetWithCharactersInString:@""];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (id)init
{
  self = [super init];
  if (self) {
    [self awakeFromNib];
  }
  
  return self;
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)getObjectValue:(id *)anObject forString:(NSString *)string errorDescription:(NSString **)error{
  
  (*anObject) = string;
  
  return YES;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//clears formatting and converts: attributed strings to strings
- (NSString *)stringForObjectValue:(id)anObject{
  
  NSAttributedString * attributedString;
  
  if (anObject) {
    
    if ([anObject isKindOfClass:[NSString class]]) {
      
      //NSLog(@"handling like string");
      return [NSString stringWithFormat:@"%@", anObject];
      
    } else {
      
      attributedString = anObject;
      
      //NSLog(@"attrString.string: %@", attributedString.string);
      
      return attributedString.string;
      
    }
    
  } else {
    
    NSLog(@"anObject was sent to stringForObjectValue in DBFormatter as NULL.");
    
    return NULL;
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)isPartialStringValid:(NSString *)partialString
            newEditingString:(NSString**)newString
            errorDescription:(NSString**)error
{
  /* //doesn't repond to <enter>
   // perhaps it's ended editing
   
  NSRange enterRange = [partialString rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]];

  if ( enterRange.location != NSNotFound ) {
   
    [ self takeActionOnNewLineCharacter ];
  
  }
  */
  
  
  BOOL returnValue;
  
  NSRange inRange = [partialString rangeOfCharacterFromSet:prohibitedCharacters];

  if(inRange.location != NSNotFound)
  {
    NSLog(@"Name input contains disallowed character.");

    returnValue = NO;
  } else {
  
    *newString = partialString;
    [self takeActionWithPartialString:partialString];
    returnValue = YES;
  
  }
  
  return returnValue;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)takeActionOnNewLineCharacter{
  // need to detect newline and tab character
  NSLog(@"enter was pressed");
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//  overwrite for subclasses to coordinate behavior with formatting
- (void) takeActionWithPartialString:(NSString*)partialString
{
  
  
}

@end
