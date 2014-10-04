//
//  DBTopicView.m
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 6/7/12.
//  Copyright 2012 UNC-Chapel Hill. All rights reserved.
//


//---------------------------------------------
#import "DBTopicFolderView.h"
//---------------------------------------------
#import "DBEditTopicController.h"
#import "DBHeaderOrganizer.h"
#import "DBOutlineViewDelegate.h"
#import "DBControllerOfOutlineViews.h"
#import "DBTopicOutlineViewController.h"
#import "DBFolderOrganizer.h"
#import "DBDetailOutlineViewController.h"
#import "DBDetailViewController.h"
#import "NoteTaker_AppDelegate.h"
#import "DBWikiWordController.h"
#import "NSTreeController_Extensions.h"
#import "DBSubTopicController.h"
#import "DBDetailController.h"
#import "DBTopicObject.h"
#import "DBHeaderOrganizer.h"
#import "DBAddTopicController.h"

@implementation DBTopicFolderView
/*
- (void) awakeFromNib {
  
  //NSTableColumn * outlineColumn = [self outlineTableColumn];
  //ImageAndTextCell * imageAndTextCell = [[ImageAndTextCell alloc] init];
  //[outlineColumn setDataCell:imageAndTextCell];


  [super awakeFromNib];

}
*/




// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)editColumn:(NSInteger)columnIndex row:(NSInteger)rowIndex withEvent:(NSEvent *)theEvent select:(BOOL)flag
{
  //DBOutlineViewDelegate won't enter edit mode for topic headers, so no need to worry about that
  id selectedObject = [[self.controller.tree selectedObjects] objectAtIndex:0];
  
  if ([selectedObject isKindOfClass:[DBFolderOrganizer class]]) {
    
    [super editColumn:columnIndex row:rowIndex withEvent:theEvent select:flag];
 
  }
  
}
/*
//same as detailViewOutline except commented out self.selectRowIndexesEnabled
-(NSNumber *)selectedRowFromEvent:(NSEvent *)theEvent {
  //self.selectRowIndexesEnabled = [NSNumber numberWithBool:YES];
  NSPoint tablePoint = [self convertPoint:theEvent.locationInWindow fromView:nil];
  NSInteger rowNum = [self rowAtPoint:tablePoint];
  //NSInteger colNum = [self columnAtPoint:tablePoint];
  
  NSIndexPath * selectionPath = self.controller.tree.selectionIndexPath;
  NSIndexPath * clickedItemPath = [[self itemAtRow:rowNum] indexPath];
  
  if (rowNum >-1 ) {  //valid row clicked
    
    Boolean clickedRowWasPreviouslySelected = ([clickedItemPath compare:selectionPath] == NSOrderedSame); // aside: if NULL is first it will always return NSOrderedSame)
    
    
    if ( ! clickedRowWasPreviouslySelected ){
      
      [self.controller.tree setSelectionIndexPath:clickedItemPath];
      
      return [NSNumber numberWithInt:1]; //  row was newly selected
      
    } else {
      
      return [NSNumber numberWithInt:0]; //  row was already selected
      
    }
    
  } else {
    
    
    [self.controller.tree selectNone];
    
    return nil;  // couldn't select row
    
  }
  
}
 */



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// on double clicks we want to get the row and select the topic if there is one
-(void)mouseDown:(NSEvent *)theEvent{
  
  NSInteger clickCount = [theEvent clickCount];
  NSPoint tablePoint = [self convertPoint:theEvent.locationInWindow fromView:nil];
  NSInteger rowNum = [self rowAtPoint:tablePoint];

  if (rowNum >-1 ) {  //valid row clicked

    DBOrganizerObject *selectedObject = [[self itemAtRow:rowNum] representedObject];
    
    if ([selectedObject isKindOfClass:[DBHeaderOrganizer class]]) {
      //NSLog(@"topic selected: set topic ");

      DBTopicObject * selectedTopic = [ selectedObject valueForKey:@"topic" ];
      
      if ( clickCount >= 2 ){

        [ editTopicController beginEditingTopic: selectedTopic ];
        
      }

      [super mouseDown:theEvent];

    } else if ([selectedObject isKindOfClass:[DBFolderOrganizer class]]){

      [super mouseDown:theEvent];

      if ( clickCount >= 2 ){

        [self editColumn:[self columnWithIdentifier:@"Main"] row: rowNum withEvent:nil select:YES];
        
      }
      
    }
    
  } else {
    

    [self.controller.tree selectNone];
    
  }
  
}




// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)reloadData
{
	[super reloadData];
	NSUInteger row;
	for (row = 0 ; row < [self numberOfRows] ; row++) {
		NSTreeNode *item = [self itemAtRow:row];
		if ([[[item representedObject] valueForKey:@"isExpanded"] boolValue])
			[self expandItem:item];
	}
  
}

/*
- (void)highlightSelectionInClipRect:(NSRect)theClipRect
{
  
  // this method is asking us to draw the hightlights for
  // all of the selected rows that are visible inside theClipRect
  
  // 1. get the range of row indexes that are currently visible
  // 2. get a list of selected rows
  // 3. iterate over the visible rows and if their index is selected
  // 4. draw our custom highlight in the rect of that row.
  
  NSRange         aVisibleRowIndexes = [self rowsInRect:theClipRect];
  NSIndexSet *    aSelectedRowIndexes = [self selectedRowIndexes];
  int             aRow=(int)aVisibleRowIndexes.location;
  int             anEndRow = (int)(aRow + aVisibleRowIndexes.length);
  NSGradient *    gradient;
  //NSColor *       pathColor;
  
  // if the view is focused, use highlight color, otherwise use the out-of-focus highlight color
  if (self == [[self window] firstResponder] && [[self window] isMainWindow] && [[self window] isKeyWindow])
  {
    gradient = [[NSGradient alloc] initWithColorsAndLocations:
                [NSColor colorWithDeviceRed:(float)62/255 green:(float)133/255 blue:(float)197/255 alpha:0.3], 0.0,
                [NSColor colorWithDeviceRed:(float)48/255 green:(float)95/255 blue:(float)152/255 alpha:0.3], 1.0, nil]; //160 80
    
    //pathColor = [[NSColor colorWithDeviceRed:(float)48/255 green:(float)95/255 blue:(float)152/255 alpha:0.3] retain];
  }
  else
  {
    gradient = [[NSGradient alloc] initWithColorsAndLocations:
                [NSColor colorWithDeviceRed:(float)190/255 green:(float)190/255 blue:(float)190/255 alpha:0.5], 0.0,
                [NSColor colorWithDeviceRed:(float)150/255 green:(float)150/255 blue:(float)150/255 alpha:0.5], 1.0, nil];
    
    //pathColor = [[NSColor colorWithDeviceRed:(float)150/255 green:(float)150/255 blue:(float)150/255 alpha:0.5] retain];
  }
  
  // draw highlight for the visible, selected rows
  for (aRow = aRow; aRow < anEndRow; aRow++){
    if([aSelectedRowIndexes containsIndex:aRow])
    {
      NSRect aRowRect = NSInsetRect([self rectOfRow:aRow], 1, 1); //first is horizontal, second is vertical
      //NSBezierPath * path = [NSBezierPath bezierPathWithRoundedRect:aRowRect xRadius:4.0 yRadius:4.0]; //6.0
      NSBezierPath * path = [NSBezierPath bezierPathWithRect:aRowRect]; //6.0
      //[path setLineWidth: 1];
      //[pathColor set];
      //[path stroke];
      
      [gradient drawInBezierPath:path angle:90];
    }
  }
}
*/
 

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//needs work.  see note.
- (BOOL)becomeFirstResponder {

  controllerOfOutlineViews.activeOutlineViewController = controllerOfOutlineViews.topicOutlineViewController;

  [controllerOfOutlineViews highlightActiveOutline];

  //note: this notification makes view load twice on selecting making topicFolderView become first responder and selecting new item...

  [super becomeFirstResponder]; //important this is last
  
  return YES;
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(IBAction)testButton:(id)sender{
  
  [self editColumn:[self columnWithIdentifier:@"Main"] row: 0 withEvent:nil select:YES];

}


// -------------------------------------------------------------------------------

//

// ------------------------------------------------------------------------------

-(void) createDefaultItemWithString:(NSString *)typedKey
{
  // open the topic panel and load the typed key in the text
  [appDelegate.addTopicController openPanel];
  
  NSComboBox * textEntry = appDelegate.addTopicController.topicListComboBox;
 
  if (typedKey) textEntry.stringValue = typedKey;
  
  [[textEntry currentEditor] moveToEndOfLine:nil];
  
  [ appDelegate.addTopicController validateMainTopicName:typedKey ];
  
}

@end
