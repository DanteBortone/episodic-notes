/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


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
