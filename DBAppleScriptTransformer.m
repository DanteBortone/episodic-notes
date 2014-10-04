//
//  DBAppleScriptTransformer.m
//  NoteTaker
//
//  Created by Dante on 10/8/13.
//
//


//---------------------------------------------
#import "DBAppleScriptTransformer.h"
//---------------------------------------------
#import <OSAKit/OSAKit.h>


@implementation DBAppleScriptTransformer



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
  return [NSAttributedString class];
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
    
  //OSAScript *script = [[OSAScript alloc] initWithSource:value];
  
  NSDictionary *errorDict;
  
  NSAppleScript *script = [[NSAppleScript alloc] initWithSource:value];
  
  if ( ![script compileAndReturnError:&errorDict] ) {
    
    NSLog(@"Script generated a compile error: %@", errorDict);
    
  }
  
  //NSAttributedString *string = value;
  
  return [script richTextSource];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (id)reverseTransformedValue:(id)value
{
  NSString * returnString;
  NSAttributedString * attrString;
 
  if ([value isKindOfClass:[NSAttributedString class]]) {
    attrString = value;
    returnString = attrString.string;
  } else {
    returnString = value;
  }
  
  return returnString;
  
}

@end
