//
//  DBFormatter.m
//  NoteTaker
//
//  Created by Dante on 2/28/13.
//
//


//---------------------------------------------
#import "DBFormatter.h"
//---------------------------------------------
#import "NSCharacterSet_Extensions.h"


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
