/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBManagedTreeObject.h"
//---------------------------------------------


@implementation DBManagedTreeObject

// Attributes -------------
@dynamic isLeaf;
@dynamic displayName;
@dynamic sortIndex;
@dynamic isExpanded;

// Relationships ----------
@dynamic parent;
@dynamic subGroups;

@synthesize initializingObject;


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromInsert
{
  
  initializingObject = [ NSNumber numberWithBool:YES ];
  
  [super awakeFromInsert];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// returns an array of objects descending from self

- (NSArray *)descendantObjects
{  
	NSMutableArray *array = [NSMutableArray array];
  
  //NSLog(@"Looking for descendants of %@", self.displayName);
	for (DBManagedTreeObject * descendant in [self.subGroups allObjects]) {
    
    //NSLog(@"descendant: %@", descendant.displayName);
    [array addObject:descendant];

    if ([descendant isNotALeaf]) [array addObjectsFromArray:[descendant descendantObjects]]; 
    
	}
  
	return [array copy];
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// returns all obejcts including itself

- (NSArray *) flattenedWithSubGroups
{
  
  NSMutableArray * array = [NSMutableArray array];

  [array addObject:self];

  if ([self isNotALeaf]) {
    
    for (DBManagedTreeObject * child in [self.subGroups allObjects]) {
    
      [array addObjectsFromArray:[child flattenedWithSubGroups]];
  
    }

  }
  
  return [array copy];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(Boolean) isALeaf
{
  
  return [self.isLeaf boolValue];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(Boolean) isNotALeaf
{
  
  return ![self.isLeaf boolValue];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) setParent:(id)parent
{

  [self willChangeValueForKey:@"parent"];
  [self setPrimitiveValue:parent forKey:@"parent"];
  [self didChangeValueForKey:@"parent"];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) doneInitializing
{
  
  initializingObject = [ NSNumber numberWithBool: NO ];

}

@end
