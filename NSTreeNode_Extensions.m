//
//  NSTreeNode_Extensions.m
//  SortedTree
//
//  Created by Jonathan Dann on 14/05/2008.
//
// Copyright (c) 2008 Jonathan Dann
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// If you use it, acknowledgement in an About Page or other appropriate place would be nice.
// For example, "Contains "Sorted Tree" by Jonathan Dann" will do.


//---------------------------------------------
#import "NSTreeNode_Extensions.h"
//---------------------------------------------

#import "NSIndexPath_Extensions.h"
#import "DBTopicObject.h"

//---------------------------------------------


@implementation NSTreeNode (DBExtensions)


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// returns an array of all NSTreeNodes descending from self (includes subGroups of subGroups etc)
// does not include self

- (NSArray *)descendantNodes;
{
	NSMutableArray *array = [NSMutableArray array];

	for (NSTreeNode *child in [self childNodes]) {
		
    [array addObject:child];
		
    if (![child isLeaf])
      [array addObjectsFromArray:[child descendantNodes]];
	
  }
	
  return [array copy];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// returns an array of objects descending from self

- (NSArray *)descendantObjects;
{
  //NSLog(@"finding descendants...");

	NSMutableArray *array = [NSMutableArray array];
	for (id descendant in [self descendantNodes]) {
    //NSLog(@"[descendant representedObject]: %@", [[descendant representedObject] valueForKey:@"displayName"]);
		[array addObject:[descendant representedObject]];
	}
	return [array copy];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSArray *)groupDescendants;
// returns an array of NSTreeNodes descending from self
// which have subGroups

{
	NSMutableArray *array = [NSMutableArray array];
	for (NSTreeNode *item in [self childNodes]) {
		if (![item isLeaf])	{
			[array addObject:item];
			[array addObjectsFromArray:[item groupDescendants]];
		}
	}
	return [array copy];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSArray *)leafDescendants;
{
	NSMutableArray *array = [NSMutableArray array];
	for (NSTreeNode *item in [self childNodes]) {
		if ([item isLeaf])
			[array addObject:item];
		else
			[array addObjectsFromArray:[item leafDescendants]];
	}
	return [array copy];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// all the siblings, including self
- (NSArray *)siblingsInclusive;
{
	return [[self parentNode] childNodes];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSArray *)siblingsExclusive;
{
  NSMutableArray * siblings = [NSMutableArray arrayWithArray:self.siblingsInclusive];
  [siblings removeObject:self];
	return [NSArray arrayWithArray:siblings];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)isDescendantOfNode:(NSTreeNode *)node;
{
	return [[node descendantNodes] containsObject:self];
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)isSiblingOfNode:(NSTreeNode *)node;
{
	return ([self parentNode] == [node parentNode]);
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)isSiblingOfOrDescendantOfNode:(NSTreeNode *)node;
{
	return ([self isSiblingOfNode:node] || [self isDescendantOfNode:node]);
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// the next increasing index path
-(NSIndexPath *)adjacentIndexPath;
{
	return [[self indexPath] indexPathByIncrementingLastIndex];
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// the next 'free' index path at the end of the children array of self's parent
- (NSIndexPath *)nextSiblingIndexPath;
{
	return [[[self parentNode] indexPath] indexPathByAddingIndex:[[[self parentNode] childNodes] count]];
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSIndexPath *)nextChildIndexPath;
{
	if ([self isLeaf])
		return [self nextSiblingIndexPath];
	return [[self indexPath] indexPathByAddingIndex:[[self childNodes] count]];
}
@end
