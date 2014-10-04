//
//  NSTreeNode_Extensions.h
//  SortedTree
//

// If you use it, acknowledgement in an About Page or other appropriate place would be nice.
// For example, "Contains "Sorted Tree" by Jonathan Dann" will do.


#import <Cocoa/Cocoa.h>


@interface NSTreeNode (DBExtensions)
- (NSArray *)descendantNodes;
- (NSArray *)descendantObjects;
- (NSArray *)groupDescendants;
- (NSArray *)leafDescendants;
- (NSArray *)siblingsInclusive;
- (NSArray *)siblingsExclusive;

- (BOOL)isDescendantOfNode:(NSTreeNode *)node;
- (BOOL)isSiblingOfNode:(NSTreeNode *)node;
- (BOOL)isSiblingOfOrDescendantOfNode:(NSTreeNode *)node;
- (NSIndexPath *)adjacentIndexPath;
- (NSIndexPath *)nextSiblingIndexPath;
- (NSIndexPath *)nextChildIndexPath;
@end
