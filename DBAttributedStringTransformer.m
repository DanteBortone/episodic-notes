//
//  DBAttributedStringTransformer.m
//  NoteTaker
//
//  Created by Dante on 3/1/13.
//
//
// from http://turnpedallabs.com/
// © 2012 Pierce Schmerge


//---------------------------------------------
#import "DBAttributedStringTransformer.h"
//---------------------------------------------


@implementation DBAttributedStringTransformer

- (void)awakeFromNib
{
  //appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];

}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


- (id)init
{
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  
  return self;
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

+ (Class)transformedValueClass
{
  return [NSString class];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

+ (BOOL)allowsReverseTransformation
{
  return YES;
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (id)transformedValue:(id)value
{
  
  NSString *string = value;
  
  return string;
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (id)reverseTransformedValue:(id)value
{
  //originally treated as if all were attrstrings
  
  NSString * returnString;
  NSAttributedString * attrString;
  
  if ([value isKindOfClass:[NSAttributedString class]]) {
    attrString = value;
    returnString = attrString.string;
  } else {
    returnString = value;
  }
  
  //NSLog(@"return string");
  return returnString;  

}


@end
