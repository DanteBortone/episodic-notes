//
//  DBTextColorTransformer.m
//  NoteTaker
//
//  Created by Angela Bortone on 8/14/13.
//
//


//---------------------------------------------
#import "DBTextColorTransformer.h"
//---------------------------------------------


@implementation DBTextColorTransformer



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
  return [NSColor class];
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

  //checking if selectionIndexPath is nil and returning the correct color of text
  
  if ( value ) {
    
    return [NSColor blackColor];
    
  } else {
    
    return [NSColor grayColor];
    
  }
  
}


@end
