//
//  DBImageTransformer.m
//  NoteTaker
//
//  Created by Dante on 8/13/13.
//
//


//---------------------------------------------
#import "DBImageTransformer.h"
//---------------------------------------------


@implementation DBImageTransformer

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


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
  return [NSImage class];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

+ (BOOL)allowsReverseTransformation
{
  return NO;
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (id)transformedValue:(id)value
{

  NSSize imageSize;
  
  imageSize.width = 13;
  imageSize.height = imageSize.width;
  
  NSImage * transformedImage = value;
  
  [transformedImage setSize:imageSize];
  
  return transformedImage;
  
}

@end
