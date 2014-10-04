//
//  NSTreeController_Extensions.m
//  SortedTree

// If you use it, acknowledgement in an About Page or other appropriate place would be nice.
// For example, "Contains "Sorted Tree" by Jonathan Dann" will do.


//---------------------------------------------
#import "NSTreeController_Extensions.h"
//---------------------------------------------
#import "NSTreeNode_Extensions.h"
#import "NSIndexPath_Extensions.h"
#import "NSArray_Extensions.h"
#import "NoteTaker_AppDelegate.h"

@implementation NSTreeController (DBExtensions)


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// will create an NSIndexPath after the selection, or as for the top of the children of a group node
- (NSIndexPath *)indexPathForInsertion;
{
	NSUInteger rootTreeNodesCount = [[self rootNodes] count];
	NSArray *selectedNodes = [self selectedNodes];
	NSTreeNode *selectedNode = [selectedNodes firstObject];
	NSIndexPath *indexPath;
	
	if ([selectedNodes count] == 0)
		indexPath = [NSIndexPath indexPathWithIndex:rootTreeNodesCount];
	else if ([selectedNodes count] == 1) {
		if (![selectedNode isLeaf])
			indexPath = [[selectedNode indexPath] indexPathByAddingIndex:0];
		else {
			if ([selectedNode parentNode])
				indexPath = [selectedNode adjacentIndexPath];
			else
				indexPath = [NSIndexPath indexPathWithIndex:rootTreeNodesCount];
		}
	} else
		indexPath = [[selectedNodes lastObject] adjacentIndexPath];
	return indexPath;
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// makes a blank selection in the outline view
- (void)selectNone;
{
  //[self removeSelectionIndexPaths:[self selectionIndexPaths]];
	[self setSelectionIndexPath:NULL];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSArray *)rootNodes;
{
	return [[self arrangedObjects] childNodes];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSTreeNode *)nodeAtIndexPath:(NSIndexPath *)indexPath;
{
	return [[self arrangedObjects] descendantNodeAtIndexPath:indexPath];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// all the real objects in the tree
- (NSArray *)flattenedContent;
{  

	NSArray * nodeArray = [self flattenedNodes];

  NSMutableArray * objectArray = [NSMutableArray array];
  for (NSTreeNode * thisNode in nodeArray) {
    [objectArray addObject:[thisNode representedObject]];
  }

	return objectArray;
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// all the NSTreeNodes in the tree, depth-first searching
- (NSArray *)flattenedNodes;
{
  NSTreeNode * thisNode;
	NSMutableArray *nodeArray = [NSMutableArray array];
  NSMutableArray *childNodeArray = [NSMutableArray array];

  nodeArray = (NSMutableArray *)[self rootNodes];

  if(nodeArray.count){
    NSInteger j = 0;
    do {
      thisNode = [nodeArray objectAtIndex:j];

      childNodeArray = (NSMutableArray *)[thisNode childNodes];
      [nodeArray addObjectsFromArray:childNodeArray];
      j=j+1;
    } while( j < nodeArray.count);
  }

	return nodeArray;
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


- (NSTreeNode *)treeNodeForObject:(id)object;
{
	NSTreeNode *treeNode = nil;
	for (NSTreeNode *node in [self flattenedNodes]) {
		if ([node representedObject] == object) {
			treeNode = node;
			break;
		}
	}
	return treeNode;
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSIndexPath *)indexPathToObject:(id)object;
{
  return [[self treeNodeForObject:object] indexPath];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)selectParentFromSelection;
{
	if ([[self selectedNodes] count] == 0)
		return;
	
	NSTreeNode *parentNode = [[[self selectedNodes] firstObject] parentNode];
	if (parentNode)
		[self setSelectionIndexPath:[parentNode indexPath]];
	else
		// no parent exists (we are at the top of tree), so make no selection in our outline
		[self selectNone];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSTreeNode *)nextSiblingOfNodeAtIndexPath:(NSIndexPath *)indexPath;
{

  if ([indexPath length] == 1) {
    
    NSInteger lastIndex = [ indexPath lastIndex ];
    NSInteger totalObjects = [[self arrangedObjects] count];
    
    if (lastIndex < totalObjects - 1) {
      
      return [[[self arrangedObjects] childNodes] objectAtIndex:(lastIndex + 1) ];
    
    } else {
    
      //NSLog(@"is last item");
      return NULL;
      
    }
  
  } else {
    
    return [[self arrangedObjects] descendantNodeAtIndexPath:[indexPath indexPathByIncrementingLastIndex]];

  }

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSTreeNode *)nextSiblingOfNode:(NSTreeNode *)node;
{
	return [self nextSiblingOfNodeAtIndexPath:[node indexPath]];
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSTreeNode *)previousSiblingOfNodeAtIndexPath:(NSIndexPath *)indexPath
{

  if ([indexPath length] == 1) {
    
    NSInteger lastIndex = [ indexPath lastIndex ];
    
    if (lastIndex > 0) {

      return [[[self arrangedObjects] childNodes] objectAtIndex:([ indexPath lastIndex ] - 1) ];

    } else {
      
      return NULL;
      
    }
    
  } else {
  
    return [[self arrangedObjects] descendantNodeAtIndexPath:[indexPath indexPathByDecrementingLastIndex]];
  
  }

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSTreeNode *)previousSiblingOfNode:(NSTreeNode *)node;
{
	return [self previousSiblingOfNodeAtIndexPath:[node indexPath]];
}

- (BOOL)hasChildOf:(NSTreeNode *)node;
{
  NSIndexPath * childLocation;
  NSTreeNode * childNode;
  childLocation = [[node indexPath] indexPathByAddingIndex:0];
  childNode = [self nodeAtIndexPath:childLocation];
  if ( childNode != NULL ) {
    return YES;
  } else { 
    return NO;
  }
}

//works on root objects
- (void)setChildrenIndices:(NSIndexPath *)parentIndex
{
  NSIndexPath * incrementIndexPath;
  NSTreeNode * updatingNode;
  //NoteTaker_AppDelegate * appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  //NSUndoManager * undoManager =  [appDelegate undoManager];
  
  //initialize loop
  NSUInteger i = 0;
  incrementIndexPath = [parentIndex indexPathByAddingIndex:i];
  updatingNode = [self nodeAtIndexPath:incrementIndexPath];

  
  // this chunk of code triggers a beginUndoGrouping for some reason
  //    only happens after it updates the last node
  //    setGroupsByEvent:NO prevented this from automatically calling a beginUndoGrouping
  while (updatingNode!=NULL){
    [[updatingNode representedObject] setValue:[ NSNumber numberWithInt:(int)(i * INTERVAL) ]  forKey:@"sortIndex"];
    i++;
    incrementIndexPath = [parentIndex indexPathByAddingIndex:(i)];
    updatingNode = [self nodeAtIndexPath:incrementIndexPath];
    //NSLog(@"index =%lu", (unsigned long)i);
    //NSLog(@"rep obj: %@", [[updatingNode representedObject] valueForKey:@"displayName"] );
  
  }
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------
/*
- (void)setChildrenIndices: (NSIndexPath *)parentIndex
                 withDelay: (NSTimeInterval)seconds;
{
  SEL theSelector;
  NSMethodSignature *aSignature;
  NSInvocation *anInvocation;
  
  theSelector = @selector(setChildrenIndices:);
  aSignature = [NSTreeController instanceMethodSignatureForSelector:theSelector];
  anInvocation = [NSInvocation invocationWithMethodSignature:aSignature];
  [anInvocation setSelector:theSelector];
  [anInvocation setTarget:self];
  [anInvocation setArgument:( void *)(parentIndex) atIndex:2];
  [NSTimer scheduledTimerWithTimeInterval:seconds invocation:anInvocation repeats:NO];

}

*/
// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)setSelectionIndexPath: (NSIndexPath *)selectIndexPath withDelay:(NSTimeInterval)seconds;
{
  SEL theSelector;
  NSMethodSignature *aSignature;
  NSInvocation *anInvocation;
  
  theSelector = @selector(setSelectionIndexPath:);
  aSignature = [NSTreeController instanceMethodSignatureForSelector:theSelector];
  anInvocation = [NSInvocation invocationWithMethodSignature:aSignature];
  [anInvocation setSelector:theSelector];
  [anInvocation setTarget:self];
  [anInvocation setArgument:(__bridge void *)(selectIndexPath) atIndex:2];
  [NSTimer scheduledTimerWithTimeInterval:seconds invocation:anInvocation repeats:NO];	  
 
}

@end
