//
//  DBDataToImageTransformer.m
//  NoteTaker
//
//  Created by Dante on 10/11/13.
//
//


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
