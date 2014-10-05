/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBDataToImageTransformer.h"
//---------------------------------------------


// from http://stackoverflow.com/questions/2862330/core-data-image-wont-load-into-nstableview-image-cell/2865796#2865796


@implementation DBDataToImageTransformer

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

+ (Class)transformedValueClass {
  return [NSImage class];
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
  //from db to display
  if (value == nil || [value length] < 1) return nil;
  NSImage* i = nil;
  if ([value isKindOfClass:[NSData class]]) {
    i = [NSKeyedUnarchiver unarchiveObjectWithData:value];
  }
  return i;
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (id)reverseTransformedValue:(id)value {
  // activated from display to store
  // putting the transformer on the model as well tries to transform it twice? anyways, it doesn't work.

  if (value == nil) return nil;
  NSData* d = nil;
  if ([value isKindOfClass:[NSImage class]]) {
    d = [NSKeyedArchiver archivedDataWithRootObject:value];
  }
  return d;
}

@end
