/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBEnableAddFolderTransformer.h"
//---------------------------------------------

#import "DBFolderOrganizer.h"
#import "DBTopicObject.h"

//---------------------------------------------


@implementation DBEnableAddFolderTransformer


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
  
  NSArray * objects = value;
  
  if (objects.count > 0) {
    
    
    id selectedObject = [(NSArray*)value objectAtIndex:0];
    
    //NSLog(@"selectedObject is a: %@", [selectedObject className]);
    
    if ([selectedObject isKindOfClass:[DBFolderOrganizer class]]) {
      
      return [NSNumber numberWithBool:YES];
      
    } else {
      
      DBTopicObject * topic = [selectedObject valueForKey:@"topic"];
      
      
      if (topic.isGlobal) {
        
        return [NSNumber numberWithBool:YES];
        
      } else {
        
        return [NSNumber numberWithBool:NO];
        
      }
      
    }
    
  } else { // no selection
    
    return [NSNumber numberWithBool:YES];

  }

}


@end
