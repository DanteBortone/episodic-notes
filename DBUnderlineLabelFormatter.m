/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */

//---------------------------------------------
#import "DBUnderlineLabelFormatter.h"
//---------------------------------------------

#import "NoteTaker_AppDelegate.h"
#import "DBHyperlinkEditor.h"

//---------------------------------------------


@implementation DBUnderlineLabelFormatter


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib{
  
  //NSLog(@"awakeFromNIB");
  
  attributes = [[NSDictionary alloc]initWithObjectsAndKeys:
                [NSNumber numberWithInt:NSSingleUnderlineStyle], NSUnderlineStyleAttributeName,
                nil];
  
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];

  [super awakeFromNib];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


- (id)init
{
  self = [super init];
  if (self) {
    NSLog(@"init");

    [self awakeFromNib];
  }
  return self;
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)getObjectValue:(id *)anObject forString:(NSString *)string errorDescription:(NSString **)error{
  
  (*anObject) = string;
  
  return YES;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSAttributedString *)attributedStringForObjectValue:(id)anObject withDefaultAttributes:(NSDictionary *)unUsed{
  
  //NSAttributedString * originalString;

  NSAttributedString * returnString;
  
  if ([anObject isKindOfClass:[NSAttributedString class]]) {
    
    returnString = anObject;
    
    returnString = [returnString initWithString:returnString.string attributes:attributes];
    
    return returnString;
  
    
  } else if ([anObject isKindOfClass:[NSString class]]){
    
    NSLog(@"it's a string");//this is called three times!!
    
    returnString = [returnString initWithString:@"BOB" attributes:attributes];

    return NULL;
    
  } else {
    
    NSLog(@"attributedStringForObjectValue - unexpected type: setting to null");
    return NULL;
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//don't need to block text here

- (BOOL)isPartialStringValid:(NSString *)partialString
            newEditingString:(NSString**)newString
            errorDescription:(NSString**)error
{
	
  return YES;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSString *)stringForObjectValue:(id)anObject{
  
  NSAttributedString * attributedString;
  
  if (anObject) {
    
    if ([anObject isKindOfClass:[NSString class]]) {
      
      //NSLog(@"handling like string");
      return [NSString stringWithFormat:@"%@", anObject];
      
    } else {
      
      attributedString = anObject;
      
      //NSLog(@"attrString.string: %@", attributedString.string);
      
      return attributedString.string;
      
    }
    
  } else {
    
    NSLog(@"anObject was sent to stringForObjectValue in DBFormatter as NULL.");
    
    return NULL;
    
  }
  
}


@end
