/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBObjectClipboard.h"
//---------------------------------------------

#import "DBManagedTreeObject.h"
#import "DBDetail.h"

//---------------------------------------------


@implementation DBObjectClipboard

// Relationships ----------
@dynamic items;

// -------------------------------------------------------------------------------

// flattenedContent

// -------------------------------------------------------------------------------

- (NSArray *) flattenedContent
{
  
  NSMutableArray * returnItems = [ NSMutableArray array ];
  
  for ( DBManagedTreeObject * object in self.items ) {
  
    [returnItems addObjectsFromArray:[object flattenedWithSubGroups]];
  
  }
  
  return [ NSArray arrayWithArray: returnItems ];
  
}

// -------------------------------------------------------------------------------

// orderedContent

// -------------------------------------------------------------------------------

//returns array of clipboard items which have been ordered by sortIndex

- (NSArray *) orderedContent
{
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortIndex" ascending:YES];
  
  return [self.items.allObjects sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
  
}

// -------------------------------------------------------------------------------

// containsDetailObjects

// -------------------------------------------------------------------------------

// returns NULL if there are no items on clipboard

- (BOOL) containsDetailObjects
{
  
  if (self.items.count > 0) {
    
    DBManagedTreeObject * sampleObject = [self.items anyObject];
    
    if ([sampleObject isKindOfClass:[DBDetail class]]) {
      
      return YES;
      
    } else {
      
      return NO;
    }
    
  } else {
    
    return NULL;
  }
  
  
}


@end
