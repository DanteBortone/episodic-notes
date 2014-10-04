//
//  DBUnderlineLabelFormatter.m
//  NoteTaker
//
//  Created by Dante on 10/5/13.
//
//


//---------------------------------------------
#import "DBUnderlineLabelFormatter.h"
//---------------------------------------------
#import "NoteTaker_AppDelegate.h"
#import "DBHyperlinkEditor.h"

@implementation DBUnderlineLabelFormatter


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib{
  
  //NSLog(@"awakeFromNIB");
  
  attributes = [[NSDictionary alloc]initWithObjectsAndKeys:
                [NSNumber numberWithInt:NSSingleUnderlineStyle], NSUnderlineStyleAttributeName,
                nil];
  
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];

  [super awakeFromNib];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


- (id)init
{
  self = [super init];
  if (self) {
    NSLog(@"init");

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

- (NSAttributedString *)attributedStringForObjectValue:(id)anObject withDefaultAttributes:(NSDictionary *)unUsed{
  
  //NSAttributedString * originalString;

  NSAttributedString * returnString;
  
  if ([anObject isKindOfClass:[NSAttributedString class]]) {
    
    returnString = anObject;
    
    returnString = [returnString initWithString:returnString.string attributes:attributes];
    
    return returnString;
  
    
  } else if ([anObject isKindOfClass:[NSString class]]){
    
    NSLog(@"it's a string");//this is called three times!!
    
    returnString = [returnString initWithString:@"BOB" attributes:attributes];

    return NULL;
    
  } else {
    
    NSLog(@"attributedStringForObjectValue - unexpected type: setting to null");
    return NULL;
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//don't need to block text here

- (BOOL)isPartialStringValid:(NSString *)partialString
            newEditingString:(NSString**)newString
            errorDescription:(NSString**)error
{
	
  return YES;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

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


@end
