//
//  DBHasNoteTransformer.m
//  NoteTaker
//
//  Created by Dante on 8/5/13.
//
//


//---------------------------------------------
#import "DBHasNoteTransformer.h"
//---------------------------------------------


@implementation DBHasNoteTransformer



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
    
  if ((value == NULL) || [value isEqualToString:@""]) {
  
    return NULL;
    
  } else {
    
    return [NSImage imageNamed: @"radioNoteImage"];
    
  }
  
}


@end
