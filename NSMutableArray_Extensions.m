//
//  NSMutableArray_Extensions.m
//  NoteTaker
//
//  Created by Dante on 9/25/13.
//
//


//---------------------------------------------
#import "NSMutableArray_Extensions.h"
//---------------------------------------------

@implementation NSMutableArray (DBExtensions)


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
  
  id object = [self objectAtIndex:fromIndex];
  [self removeObjectAtIndex:fromIndex];
  [self insertObject:object atIndex:toIndex];

}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)moveObject:(id)object toIndex:(NSUInteger)toIndex
{

  NSUInteger fromIndex = [self indexOfObject:object];
  
  [self removeObjectAtIndex:fromIndex];
  [self insertObject:object atIndex:toIndex];

}


@end
