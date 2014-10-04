//
//  NSIndexPath_Extensions.m
//  SortedTree

// If you use it, acknowledgement in an About Page or other appropriate place would be nice.
// For example, "Contains "Sorted Tree" by Jonathan Dann" will do.


//---------------------------------------------
#import "NSIndexPath_Extensions.h"
//---------------------------------------------


@implementation NSIndexPath (DBExtensions)


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSUInteger)firstIndex;
{
	return [self indexAtPosition:0]; 
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSUInteger)lastIndex;
{
	return [self indexAtPosition:[self length] - 1];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSIndexPath *)indexPathByIncrementingLastIndex;
{
	NSUInteger lastIndex = [self lastIndex];
	NSIndexPath *temp = [self indexPathByRemovingLastIndex];
	return [temp indexPathByAddingIndex:++lastIndex];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSIndexPath *)indexPathByDecrementingLastIndex;
{
	NSUInteger lastIndex = [self lastIndex];
	NSIndexPath *temp = [self indexPathByRemovingLastIndex];
	return [temp indexPathByAddingIndex:(lastIndex-1)];
}

// -------------------------------------------------------------------------------

// indexPathByDecrementingLastIndexBy:

// -------------------------------------------------------------------------------

- (NSIndexPath *)indexPathByDecrementingLastIndexBy:(NSInteger) amount;
{
	NSUInteger lastIndex = [self lastIndex];
	NSIndexPath *temp = [self indexPathByRemovingLastIndex];
	return [temp indexPathByAddingIndex:(lastIndex-amount)];
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSIndexPath *)indexPathByReplacingIndexAtPosition:(NSUInteger)position withIndex:(NSUInteger)index;
{
	NSUInteger indexes[[self length]];
	[self getIndexes:indexes];
	indexes[position] = index;
	return [[NSIndexPath alloc] initWithIndexes:indexes length:[self length]];
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSString *)indexPathString;
{
  NSMutableString *indexString = [NSMutableString stringWithFormat:@"%lu",[self indexAtPosition:0]];

  for (int i = 1; i < [self length]; i++){
    [indexString appendString:[NSString stringWithFormat:@".%lu", [self indexAtPosition:i]]];
  }
  
  return indexString;
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (Boolean)isFirstRootItem
{
  if((self.length == 1) && ([self firstIndex] == 0)){
    return YES;
  } else {
    return NO;
  }
}


@end
