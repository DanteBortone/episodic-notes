//
//  DBManagedTreeObject.m
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 6/5/12.
//

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
