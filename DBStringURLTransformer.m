//
//  DBStringURLTransformer.m
//  NoteTaker
//
//  Created by Dante on 10/12/13.
//
//


//---------------------------------------------
#import "DBStringURLTransformer.h"
//---------------------------------------------


@implementation DBStringURLTransformer


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

+ (Class)transformedValueClass {
  return [NSURL class];
} // the class of the return value from transformedValue:


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

+ (BOOL)allowsReverseTransformation {
  return YES;
} // if YES then must also have reverseTransformedValue:


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (id)transformedValue:(id)value {
  // from db to display

  
  NSString *path = value;
  
  if (path) {
  
    return [NSURL fileURLWithPath:path];
  
  } else {
    
    return NULL;

  }
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


- (id)reverseTransformedValue:(id)value {
  // activated from display to db

  
  NSURL *url = value;
  

  return [url path];
  
}


@end
