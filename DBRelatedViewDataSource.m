//
//  DBDateRelatedViewDataSource.m
//  NoteTaker
//
//  Created by Dante on 6/2/13.
//
//


//---------------------------------------------
#import "DBRelatedViewDataSource.h"
//---------------------------------------------

@implementation DBRelatedViewDataSource


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)outlineView:(NSOutlineView *)receivingView
         acceptDrop:(id <NSDraggingInfo>)info
               item:(id)item
         childIndex:(NSInteger)index {
 
  return NO;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSDragOperation)outlineView:(NSOutlineView *)outlineView
                  validateDrop:(id <NSDraggingInfo>)info
                  proposedItem:(id)item
            proposedChildIndex:(NSInteger)index {

	return NSDragOperationNone;
}


@end
