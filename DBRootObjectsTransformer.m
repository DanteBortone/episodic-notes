/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBRootObjectsTransformer.h"
//---------------------------------------------

#import "DBDetail.h"
#import "DBTopicObject.h"

//---------------------------------------------


@implementation DBRootObjectsTransformer

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
  return [NSMutableSet class];
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
  
  NSMutableSet * returnSet = [NSMutableSet set];
  
  for (DBDetail * item in (NSSet *) value){
    
    if (item.parent == nil) {
      
      [returnSet addObject:item];

    }
    
  }
      
  return returnSet;//[NSSet setWithSet:returnSet];
    
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//don't know if this is needed 

- (id)reverseTransformedValue:(id)value
{
  
  DBDetail * item = [(NSSet *)value anyObject];

  return [NSMutableSet setWithSet:item.topic.details];
  
}


@end
