/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBAppleScriptTransformer.h"
//---------------------------------------------

#import <OSAKit/OSAKit.h>

//---------------------------------------------


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
