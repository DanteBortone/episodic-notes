/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBOutlineViewDataSource.h"
//---------------------------------------------

#import "DBDetailController.h"
#import "DBDetailOutlineViewController.h"
#import "DBFolderOrganizer.h"
#import "DBManagedTreeObject.h"
#import "DBOutlineView.h"
#import "DBDateTopic.h"
#import "DBOutlineViewController.h"
#import "DBOutlineViewDelegate.h"
#import "DBDetailOutlineViewDelegate.h"
#import "DBControllerOfOutlineViews.h"
#import "DBTopicFolderView.h"
#import "NSTreeNode_Extensions.h"
#import "NoteTaker_AppDelegate.h"
#import "DBTopicObject.h"
#import "DBDetailViewController.h"
#import "DBViewObject.h"
#import "DBDetailOutlineView.h"
#import "DBHeaderOrganizer.h"
#import "DBSubTopic.h"
#import "DBTopicOutlineViewController.h"
#import "NSNumber_Extensions.h"
#import "DBCalendarController.h" // to update bold dates on calendar
#import "DBUndoManager.h"

//debugging
#import "DBDetail.h"
#import "NSIndexPath_Extensions.h"
#import "NSTreeController_Extensions.h"
#import "DBFileTopic.h"

//---------------------------------------------


@implementation DBOutlineViewDataSource

@synthesize controller = _controller;

/*
- (void)awakeFromNib {

  //NSLog(@"DBOutlineViewDataSource:awakeFromNib");

  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  detailController = appDelegate.detailController;
  controllerOfOutlineViews = appDelegate.controllerOfOutlineViews;
  
}
*/


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (id)init{
  
  if (self = [super init]) {
    
    appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
    detailController = appDelegate.detailController;
    controllerOfOutlineViews = appDelegate.controllerOfOutlineViews;
    
  }
  
  return self;
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) setController:(DBOutlineViewController *)controller
{
  
  _controller = controller;

  treeController = controller.tree;
  thisView = controller.view;
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//should only be run on topic folders...right?
- (BOOL) category:(NSManagedObject* )cat hasSubCategory:(NSManagedObject* )possibleSub {

  if ([cat isKindOfClass:[DBFolderOrganizer class]]) {

    if ( cat == possibleSub ) {

      return YES;
      
    }
    
    NSManagedObject* possSubParent = [possibleSub valueForKey:@"parent"];

    if ( possSubParent == NULL ) {

      return NO;
      
    }
    
    while ( possSubParent != NULL ) {
      if ( possSubParent == cat ) {

        return YES;
        
      } 
      // move up the tree 
      possSubParent = [possSubParent valueForKey:@"parent"];

    }
  } else {
    NSLog(@"Warning - DBOutlineViewDataSource:Category:hasSubCategory attempting to run on non DBFolderOrganizer object.");
  }
	return NO;
} 



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)makeCopyOf:(id)draggedObject{
  
  Boolean createCopy = NO;

  return createCopy;
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//needs to return an ordered array of subgroups so the sort indices can be renumbered
- (NSArray* ) getSubGroupsforParent:(DBManagedTreeObject *)parent {

  NSSortDescriptor* aSortDesc;
  NSArray * sortDescriptorArray;
  //NSArray * returnArray;
  NSSet * subGroups;
  
  aSortDesc = [[NSSortDescriptor alloc] initWithKey:@"sortIndex" ascending:YES];
  sortDescriptorArray = [NSArray arrayWithObject:aSortDesc];
  
  subGroups = parent.subGroups;
  
  return [[subGroups allObjects] sortedArrayUsingDescriptors:sortDescriptorArray];

}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSArray* ) getRootItemsforTopic:(DBTopicObject *)topic {

  NSSortDescriptor* aSortDesc;
  NSArray * sortDescriptorArray;
  NSArray * rootItems;
  
  aSortDesc = [[NSSortDescriptor alloc] initWithKey:@"sortIndex" ascending:YES];
  sortDescriptorArray = [NSArray arrayWithObject:aSortDesc];
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSPredicate* parentPredicate = [NSPredicate predicateWithFormat:@"parent == nil" ];
  NSError *error;
  NSEntityDescription *entity;
  
  if ([thisView class]==[DBDetailOutlineView class]) {
    
    //NSLog(@"getRootItemsforTopic - detail outline");

    NSPredicate* topicPedicate = [NSPredicate predicateWithFormat:@"topic == %@", topic ];
    
    NSArray * subPredicates = [NSArray arrayWithObjects:parentPredicate, topicPedicate, nil];
    
    NSPredicate *combinedPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:subPredicates];

    [fetchRequest setPredicate:combinedPredicate];

    rootItems = [topic.details allObjects];
    
    entity = [NSEntityDescription entityForName:@"Detail" inManagedObjectContext:appDelegate.managedObjectContext];
    
  } else {
    
    //NSLog(@"getRootItemsforTopic - topic outline");

    entity = [NSEntityDescription entityForName:@"OrganizerObject" inManagedObjectContext:appDelegate.managedObjectContext];
    
    [fetchRequest setPredicate:parentPredicate];

  }

  [fetchRequest setEntity:entity];

  rootItems = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
  
  return [rootItems sortedArrayUsingDescriptors:sortDescriptorArray];
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) resortGroupsforParent:(id)parent inTopic: (DBTopicObject*)topic {
  
	NSArray *array;
  //NSLog(@"parent: %@", [parent valueForKey:@"displayName"]);
  if (parent) {
        
    array = [ self getSubGroupsforParent:parent ];

  } else {
    
    array = [ self getRootItemsforTopic: topic ];

  }
  
  //NSLog(@"--- Siblings ----------------------");
  //for (DBDetail * detail in array){
    //NSLog(@"%@", detail.displayName);
  //}
  
  id anObject;

  for (int index = 0; index < array.count; index+=1) {
    
    anObject = [array objectAtIndex:index];
    //NSLog(@"detail: %@", [anObject valueForKey:@"displayName"]);
    [anObject setValue:[ NSNumber numberWithInt:(index * INTERVAL ) ] forKey:@"sortIndex"];
    
  }
  
  [thisView reloadData];
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) resortRootItemsforFolderView {
  
  
  
	NSArray * array = [ detailController getFolderViewRootObjects ];
  
  //NSLog(@"--- Siblings ----------------------");
  //for (DBDetail * detail in array){
  //NSLog(@"%@", detail.displayName);
  //}
  
  DBOrganizerObject * anObject;
  
  for (int index = 0; index < array.count; index+=1) {
    
    anObject = [array objectAtIndex:index];
    //NSLog(@"detail: %@", [anObject valueForKey:@"displayName"]);
    [anObject setValue:[ NSNumber numberWithInt:(index * INTERVAL ) ] forKey:@"sortIndex"];
    
  }
  
}

#pragma mark -
#pragma mark NSOutlineViewDataSource 


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL) outlineView : (NSOutlineView *) outlineView
          writeItems : (NSArray*) items
        toPasteboard : (NSPasteboard*) pboard {
  //NSLog(@"writeItems");
  
  //NSTreeNode * firstNode = [items objectAtIndex:0];
  //DBManagedTreeObject * firstObject = [firstNode representedObject];
  
  
  
  // need this to know if items later were inserted bleow the top most original selection value
  // all of this should be stored as nodes instead of objects
  //    I have to store this anyway to correction the selection
  //    if an item is moved below itself with in the same parent
  
  
  //originalIndexPaths = items;
  
  
  NSArray * founderNodes = [detailController founderNodes:items];
  
  /*
  if ([firstObject isKindOfClass:[DBOrganizerObject class]]){
    
    founderNodes = [detailController topicFounderNodes:founderNodes];
    
  }
  */
  
  //NSLog(@"founderNode count: %li", founderNodes.count);
  
  NSMutableArray * compilingDraggedObjects = [ NSMutableArray array ];
  NSMutableArray * compilingDescendantObjects = [ NSMutableArray array ];
  NSMutableArray * mutableOriginalIndexPaths = [NSMutableArray array];

  for (NSTreeNode * node in founderNodes) {
    
    [mutableOriginalIndexPaths addObject:node.indexPath];
    
    [compilingDraggedObjects addObject:node.representedObject];
    
    [compilingDescendantObjects addObjectsFromArray:[node descendantObjects]];
    
  }
  
  originalIndexPaths = [ NSArray arrayWithArray:mutableOriginalIndexPaths ];
  
	[ pboard declareTypes:self.controller.dragType owner:self ];
  
  NSEvent * dragEvent = [NSEvent mouseEventWithType:NSLeftMouseDragged location:[NSEvent mouseLocation] modifierFlags:NSLeftMouseDraggedMask timestamp:time(NULL) windowNumber:NULL context:NULL eventNumber:0 clickCount:1 pressure:1.0f];
  
  [ outlineView mouseDragged:dragEvent ];
  
  controllerOfOutlineViews.draggedObjects = [ NSArray arrayWithArray:compilingDraggedObjects ];
  
  //setting this so it won't need to be done 5000 times when validating targets
  controllerOfOutlineViews.draggedSubGroups = [ NSArray arrayWithArray:compilingDescendantObjects ]; //an array of details
  
	return YES;	 

}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// This method gets called by the framework but 
// the values from bindings are used instead 
- (id)outlineView:(NSOutlineView *)outlineView 
objectValueForTableColumn:(NSTableColumn *)tableColumn 
           byItem:(id)item {
  
  //destination = outlineView;
	return NULL;
  
} 



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//happens before accept drop

- (NSDragOperation)outlineView:(NSOutlineView *)receivingView
                  validateDrop:(id <NSDraggingInfo>)info
                  proposedItem:(id)item
            proposedChildIndex:(NSInteger)index {
  
  
  
  DBManagedTreeObject * targetForDrop = [item representedObject];
  
  
  // if the receiving view is a detail view and the original view is the topic view then the drop is valid ( they are going to be copied objects with no chance of putting an item inside themselves )
  Class topicFolderViewClass = [DBTopicFolderView class];
  DBOutlineView * originalView = controllerOfOutlineViews.activeOutlineViewController.view;
  if ([originalView isKindOfClass:topicFolderViewClass] &&
      ![receivingView isKindOfClass:topicFolderViewClass]){

  	return NSDragOperationMove;
  
  }
  
  
  // the receiving view is a topic view and the the original view is a detail view then this drag is okay only if the target item is a topic header ( we're just going to move/copy the items inside the topic )
  
  if ([receivingView isKindOfClass: topicFolderViewClass] &&
      ![originalView isKindOfClass: topicFolderViewClass]){
  
    // don't want it to allow draging to a subfolder of the header just on the header topic or subtopic itself
    // the index will be -1 if dropped onto a folder itself
    if (index != -1) {
      
      return NSDragOperationNone;
    
    }

    if ([[item representedObject] isKindOfClass:[ DBHeaderOrganizer class ]]) {

      return NSDragOperationMove;

    } else {
      
      return NSDragOperationNone;
      
    }
    
  }
  
  
  //don't allow dragging of item onto leaf/divider
  BOOL aLeaf = [targetForDrop isALeaf];
  if (aLeaf) return NSDragOperationNone;//takes care of dividers and headerOrganizers
  
  for (DBManagedTreeObject * draggedObject in controllerOfOutlineViews.draggedObjects) {
    
    if ([draggedObject isKindOfClass:[DBHeaderOrganizer class]]) {
      
      // only allow drags within same parent
      
      DBTopicObject * draggedTopic = [(DBHeaderOrganizer *)draggedObject topic];
      
      if (draggedTopic.isGlobal) {
        
        if ([targetForDrop isKindOfClass:[DBHeaderOrganizer class]]) {
          
          return NSDragOperationNone;
          
        }
        
      } else { // isLocal
        
        if (targetForDrop != draggedObject.parent) {
          
          return NSDragOperationNone;
          
        }
        
      }
      
    }
    
    // if dragged object is a folder organizer and the target is not a folder organizer or the root (NULL) don't allow drag
    if ([draggedObject isKindOfClass:[DBFolderOrganizer class]]) {
      if (targetForDrop) {
        //NSLog(@"class of target: %@", [targetForDrop className]);
        if ( ! [targetForDrop isKindOfClass:[DBFolderOrganizer class]]) {
          return NSDragOperationNone;
        }
      }
    }
  }
  
  
  //don't allow dragging of item onto itself (ie from searchview to topic view)
  if ( [ controllerOfOutlineViews.draggedObjects containsObject: targetForDrop ]) {
    
    //NSLog(@"draggedObject: %@", draggedObject.displayName);
    //NSLog(@"targetForDrop: %@", targetForDrop.displayName);
    
    return NSDragOperationNone;
    
  }

  // Verify that we are not dragging a parent to one of it's ancestors
	// causes a parent loop where a group of nodes point to each other
	// and disappear from the control
  if([controllerOfOutlineViews.draggedSubGroups containsObject:targetForDrop]){
    //NSLog(@"validateDrop attempt to drag item into itself");
    return NSDragOperationNone;
  }
  
  // NSLog(@"made it!");
	return NSDragOperationMove;
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// validate drop happens first

// ideally this would use a similar method with paste and insert from detailController

// big difference though is that this method don't start off with the indexPaths
//    eg: insert update through setChildrenIndices, but that would be hard here unless
//        we start putting nodes as the dragged objects
- (BOOL)outlineView:(DBOutlineView *)receivingView
         acceptDrop:(id <NSDraggingInfo>)info 
               item:(id)item 
         childIndex:(NSInteger)index {

  [appDelegate.undoManager makeUndoable];
  
  NSArray * draggedObjects = controllerOfOutlineViews.draggedObjects;
  
  NSArray * placedObjects;
  
  NSTreeNode * newParentNode = item;
  NSIndexPath * newParentIndex;
  NSUInteger rootArray[] = {}; 
  DBManagedTreeObject * newParentObject = [ item representedObject ];
  
  NSWindow * thisWindow = [receivingView window];
  DBTopicObject * originalTopic;  // to update views
  DBTopicObject * receivingTopic;  // to updates views
  
  controllerOfOutlineViews.draggedObjects = NULL;// not needed after accepting drag
  controllerOfOutlineViews.draggedSubGroups = NULL;//draggedSubGroups was set on writingItem to pasteboard to make it faster to validate drop.  It isn't needed after drop is accepted.
  
  
  NSMutableArray * oldParentObjects = [ NSMutableArray array ]; // need these to recalc sortindices of these when items are pulled out
  
  
  BOOL movingItemsFromRoot = NO;
  
  for (DBManagedTreeObject * draggedObject in draggedObjects) {
    
    DBManagedTreeObject * parent = draggedObject.parent;
    
    //NSLog(@"parent: %@", parent.displayName);
    
    if (parent) {
    
      if(![oldParentObjects containsObject: parent] ) {
      
        [ oldParentObjects addObject: parent ];
      
      }
      
    } else {
      
      movingItemsFromRoot = YES;
      
    }
    
  }
  
  // disabled drag by copy after adding copy cut paste options
  //NSNumber * dragSelectionindex = [[NSUserDefaults standardUserDefaults] objectForKey:@"dragTypeIndex"];
  //BOOL dragByCopy = [dragSelectionindex isEqualToNumber:[NSNumber numberWithInt:1]];

  BOOL dragByCopy = NO;
  
  Boolean isDetailView;
  if ([receivingView isKindOfClass:[DBTopicFolderView class]]) {
   
    isDetailView = NO;
    //dragSelectionindex = [NSNumber numberWithInt:0];
    
  } else {
    
    isDetailView = YES;
    originalTopic = controllerOfOutlineViews.activeOutlineViewController.viewTopic;
    
  }

  
  
  // ---------------------- < determine objects to place > ----------------------
  
  // check for drag from topic to detail
  DBOutlineView * originalView = controllerOfOutlineViews.activeOutlineViewController.view;
  Class topicFolderViewClass = [DBTopicFolderView class];
  
  
  // dropping into the topic header is a special case that will need to skip a lot of other steps
  // like selecting the items afterwards
  BOOL droppedIntoTopicHeader = NO;
  
  if ([receivingView isKindOfClass: topicFolderViewClass] &&
      ![originalView isKindOfClass: topicFolderViewClass]){
    
    droppedIntoTopicHeader = YES;
    newParentObject = NULL;
    originalTopic = controllerOfOutlineViews.activeOutlineViewController.viewTopic;

  }
  
  
  
  if ([originalView isKindOfClass:topicFolderViewClass] &&
      ![receivingView isKindOfClass:topicFolderViewClass]){
    
    dragByCopy = YES;
    
    NSMutableArray * convertedOrganizers = [NSMutableArray array];

    for (DBOrganizerObject * draggedObject in draggedObjects) {
      
      [ convertedOrganizers addObject:[detailController copyOrganizerAsDetailWithSubGroups:draggedObject toParent:NULL ] ];
      
    }
    
    placedObjects = [ NSArray arrayWithArray:convertedOrganizers ];
    
    // check for drag from topic to detail
  } else if ( ! dragByCopy ) { //move

    //placedObject = draggedObject;
    placedObjects = draggedObjects;
    
  } else { //copy

    NSMutableArray * compilingPlacedObjects = [NSMutableArray array];
    /// HERE is where we need  do transfers to drag topics into details
    if (isDetailView){
      
      for (DBDetail * draggedObject in draggedObjects) {
        
        [ compilingPlacedObjects addObject:[detailController copyDetailWithSubGroups:draggedObject toParent:NULL ] ];

      }
      
      placedObjects = [NSArray arrayWithArray:compilingPlacedObjects];
      
    } else {
      
      for (DBOrganizerObject * draggedObject in draggedObjects) {
        
        [ compilingPlacedObjects addObject:[detailController copyOrganizerWithSubGroups:draggedObject toParent:NULL ] ];
        
      }
      
      placedObjects = [NSArray arrayWithArray:compilingPlacedObjects];
      
    }

    
  }
  // ---------------------- < / determine objects to place > ----------------------

  //parent is null for root drags
  if (droppedIntoTopicHeader) {
    
    for (DBManagedTreeObject * placedObject in placedObjects) {
      // parents of items droppedIntoTopicHeader needs to be set here so that they
      //   get counted as root items when the indexes are set
      //NSLog(@"dragged object class name: %@", [placedObject className]);
      //NSLog(@"newParentObject: %@",newParentObject.displayName);
      [placedObject setParent:newParentObject];
      
    }
    
  }
  
  
  
  // details need to change topic value
  if (isDetailView || droppedIntoTopicHeader) {
    if (isDetailView) {
      
      receivingTopic = [self.controller valueForKey:@"viewTopic"];

    } else {
      
      // we know the item has to be a DBHeaderOrganizer because validateDrop checked this
      receivingTopic = [[newParentNode representedObject] valueForKey:@"topic"];
      
    }
    
    for (DBDetail * placedObject in placedObjects) {
      
      [placedObject setValue:receivingTopic forKey:@"topic"];
      
      //[ detailController assignDetailAndSubGroupsOf:(DBDetail *)placedObject toTopic:receivingTopic];
      if ([receivingTopic isKindOfClass:[DBDateTopic class]]) {
        
        [placedObject setValue:[receivingTopic valueForKey:@"date"] forKey:@"dateAssociated"];
        
      }
    }
    //
  }
  
  
  // set selection index
  if (newParentNode != NULL){
    newParentIndex = [newParentNode indexPath];
  } else {
    newParentIndex = [NSIndexPath indexPathWithIndexes:rootArray length:0];//root index
  }
  
  if(droppedIntoTopicHeader){
    
    // index is the number root items from the topic
    //    we already added our items so lets subtract those
    //    this could cause problem if the items haven't updated yet
    index = receivingTopic.rootSet.count - draggedObjects.count;
    //NSLog(@"receivingTopic: %@", receivingTopic.displayName);

    //NSLog(@"index: %li", index);
    
  } else {
    
    //newParentObject.isExpanded = [NSNumber numberWithBool:YES]; //does this automatically
    
    if ( index == -1){// index is -1 if dropped on folder
      
      if (newParentIndex.length == 0) { // a root insert

        index = [treeController.arrangedObjects count];

      } else { // not a root insert
        
        index = newParentObject.subGroups.count;
        
      }
      
    }
    
  }
  
  //  change sortIndexes of placed objects
  NSInteger newSortIndex = index * 10;
  
  for (DBManagedTreeObject * placedObject in placedObjects){
    
    //NSLog(@"%@ newSortIndex: %li",placedObject.displayName, newSortIndex);
    placedObject.sortIndex = [NSNumber numberWithInteger:newSortIndex];
    
    newSortIndex += 10;
    
  }
  
  NSIndexPath * movedToIndexPath;
  NSMutableArray * objectIndexPaths;

  //==================== < not needed for drops into Topic Folder > =============================
  
  if (!droppedIntoTopicHeader) {
  
    movedToIndexPath = [newParentIndex  indexPathByAddingIndex:(NSUInteger)index ];
    
    
    // increase sortindex for all groups that would follow the pasted items -----
    
    // from detail controller paste method
    //   root inserts will not go in correct places without this step
    //   pasted items have not been inserted yet
    
    NSInteger increaseSortIndex = draggedObjects.count * 10;
    
    //NSLog(@"increaseSortIndex: %li", increaseSortIndex);
    
    NSTreeNode * nextNode = [treeController nodeAtIndexPath:movedToIndexPath];
    while (nextNode) {
      
      DBManagedTreeObject * objectToUpdate = [nextNode representedObject];
      
      // be careful not to update index of an item that might be in the tree still but will move soon
      // this will mess up the sort index we just made up above
      if (![ placedObjects containsObject: objectToUpdate ]) {

        objectToUpdate.sortIndex = [ objectToUpdate.sortIndex incrementBy:increaseSortIndex ];

      }
      //NSLog(@"increasing index of: %@", objectToUpdate.displayName);
      
      nextNode = [treeController nextSiblingOfNodeAtIndexPath:[nextNode indexPath]];
      
    }
    
    // ---------------------------------------------------------------------------
    
    //parent is null for root drags
    
    for (DBManagedTreeObject * placedObject in placedObjects) {
      
      //NSLog(@"newParentObject: %@",newParentObject.displayName);
      [placedObject setParent:newParentObject];
      
    }
    
    
    // ----------- < fill index path array for inserted objects > --------------------
    //        - from detail controller paste method
    
    NSIndexPath *incrementIndexPath = movedToIndexPath;
    //  NSLog(@"----movedToIndexPath: %@", movedToIndexPath.indexPathString);
      //NSLog(@"Filling object index path ------ ");
    
    objectIndexPaths = [NSMutableArray array];

    for (int index = 0; index < placedObjects.count; index += 1) {
      
      //NSLog(@"%@ index path: %@", [[placedObjects objectAtIndex:index] valueForKey:@"displayName"],incrementIndexPath.indexPathString);
      
      [ objectIndexPaths addObject:incrementIndexPath];
      
      incrementIndexPath  = [incrementIndexPath indexPathByIncrementingLastIndex];
      
    }
    // ----------- < / fill index path array for inserted objects > --------------------
  }
  // =================== < / not needed for drops into Topic Folder > =================
  

  
  //NSLog(@"movedToIndexPath: %@", [movedToIndexPath indexPathString]);
    
  [thisWindow makeFirstResponder:receivingView];
    
  [appDelegate.managedObjectContext processPendingChanges];
  
  
  // recalc sortIndices of previous parents
  
  for (DBManagedTreeObject * previousParent in oldParentObjects) {
    
    [self resortGroupsforParent:previousParent inTopic:originalTopic];
    
  }
  

  if (isDetailView || droppedIntoTopicHeader){
    
    if (movingItemsFromRoot) {
      
      [self resortGroupsforParent:NULL inTopic:originalTopic];
      
    }
    
    // update the outline views
    
    for (DBDetailViewController * detailViewController in controllerOfOutlineViews.detailViewControllerArray){
      
      //should check first if view has either received or lost a detail
      if (detailViewController.managedViewObject.viewTopic == receivingTopic || detailViewController.managedViewObject.viewTopic == originalTopic) {
        
        detailViewController.managedViewObject = detailViewController.managedViewObject;
      }
      
    }
  
  } else {
    
    [ self resortRootItemsforFolderView ];
    [ treeController rearrangeObjects ];
    
  }
  
// when an item is moved within the same parent and below its previous location, the index will be one lower
  
  //this is just adjusting the selection afterwards
    // to adjust for moveing an items under itself
    //    can worry aobut this later

   // should however, make it so old index of items are stored
   //     count the objects of the those that were above the new insert place
   //     and move the selection up by that amount
  
  
  // if items are MOVED below themselves the selection needs to be moved to a
  
  if ( !dragByCopy && !droppedIntoTopicHeader ) {
    
    //  if item has the same topic as before
    if ( originalTopic == receivingTopic ) {
      
      NSInteger bumpSelectionIndex = 0;
      // need to loop through origanal index paths to see how many were above the current index. The new selection needs to be moved by this amount
      for (NSIndexPath * previousPath in originalIndexPaths) {
        
        NSIndexPath * previousParentIndex = [previousPath indexPathByRemovingLastIndex];

        if ([newParentIndex compare:previousParentIndex] == NSOrderedSame) {
          // parent index and topic are the same so the parent is the same

          // add to the count if the previous index was above the destination
          if ([previousPath lastIndex] < [movedToIndexPath lastIndex]) {

            bumpSelectionIndex +=1;
            
          }
        }
      }
      
      if (bumpSelectionIndex > 0) {
        
        NSInteger numObjects = objectIndexPaths.count;
        
        for (int index = 0; index < numObjects; index += 1) {
          
          NSIndexPath * movePath = [[objectIndexPaths objectAtIndex:index] indexPathByDecrementingLastIndexBy:bumpSelectionIndex];
          
          //NSLog(@"movePath: %@", movePath.indexPathString);
          [objectIndexPaths setObject:movePath atIndexedSubscript:index];
          
        }
        
      }
    }
  }

  
  // this next line is odd and needs some explanation ---------
  // for the first drag into a view before that view is clicked or inserted into
  // no selection can be made in the view
  //    the tree has a selection but the view does not
  //    tried lots fo things:
  //            [view endUpdates];
  //            [view setRefusesFirstResponder:NO];
  //            [view becomeFirstResponder];
  //            [view setNeedsDisplay];
  //    and others, but nothing ever works
  
  [ receivingView mouseDown:NULL ]; // works... dunno why
  
  // ----------------------------------------------------------
  
  if (!droppedIntoTopicHeader) {
    
    [ treeController setSelectionIndexPaths:objectIndexPaths ];
  }
  
  //NSLog(@"tree selection has: %li", treeController.selectedObjects.count);
  //NSLog(@"view selection has: %li", receivingView.selectedRowIndexes.count);
  
  [ controllerOfOutlineViews updateRelatedContent ];
  
  if (isDetailView || droppedIntoTopicHeader) {

    for (DBDetail * placedObject in placedObjects) {
      
      [placedObject setDateModified:[NSDate date]];

    }
    
    
  }
  
  
  if ([originalTopic isKindOfClass:[DBDateTopic class]]||[receivingTopic isKindOfClass:[DBDateTopic class]]){
    //NSLog(@"marking dates with entries");
    [appDelegate.calendarController markDatesWithEntries];
  }
  
  // if details were dropped into a topic header then the items will be dropped inside the topic itself ( not as a node in the view ) and return NSDragOperationNone so the folder doesn't open but we don't want it to animate a slide back to the original location
  
  [appDelegate.undoManager stopMakingUndoable];

  
  if (droppedIntoTopicHeader) {
  
    originalView.animatesToStartingPositionsOnCancelOrFail = NO;
    
    return NSDragOperationNone;
    
  } else {

    originalView.animatesToStartingPositionsOnCancelOrFail = YES;
    
    return NSDragOperationMove;

  }

  

}




/* The following are implemented as stubs because they are 
 required when implementing an NSOutlineViewDataSource. 
 Because we use bindings on the table column these methods are never called. 
 The NSLog statements have been included to prove that these methods are not called. */ 

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item { 
	NSLog(@"numberOfChildrenOfItem"); 
	return 1; 
} 

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item { 
	NSLog(@"isItemExpandable"); 
	return YES; 
} 

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item { 
	NSLog(@"child of Item"); 
	return NULL; } 


@end