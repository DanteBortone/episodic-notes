//
//  DBEnableInputScriptRemoval.m
//  NoteTaker
//
//  Created by Dante on 10/9/13.
//
//


//---------------------------------------------
#import "DBEnableInputScriptRemoval.h"
//---------------------------------------------
#import "DBApplication.h"


@implementation DBEnableInputScriptRemoval


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
  
  return [NSNumber class];
  
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
  
  DBApplication * application = value;

  if ( application.inputScripts.count > 1 ) {
  
    return [NSNumber numberWithBool:YES];
  
  } else {
  
    return [NSNumber numberWithBool:NO];
  
  }

}

@end
