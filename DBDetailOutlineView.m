//
//  DBDetailOutlineView.m
//  NoteTaker
//
//  Created by Dante on 7/4/13.
//
//


//---------------------------------------------
#import "DBDetailOutlineView.h"
//---------------------------------------------
#import "DBDetailOutlineViewDelegate.h"
#import "DBDetailOutlineViewController.h"
#import "DBTopicOutlineViewController.h"
#import "DBControllerOfOutlineViews.h"
#import "NoteTaker_AppDelegate.h"
#import "NSTreeController_Extensions.h"
#import "DBRelatedOutlineViewController.h"
#import "DBDetailViewController.h"
#import "DBViewObject.h"
#import "DBDetail.h"
#import "NSIndexPath_Extensions.h"
#import "DBTableCellTextView.h"
#import "DBTextViewCell.h"
#import "DBHyperlinkEditor.h"
#import "DBTableCellFileView.h"
//#import "DBTableCellNoteView.h"
#import "DBCalendarController.h"
#import "DBDetailController.h"

@implementation DBDetailOutlineView

#define kOutlineCellWidth 11
#define kOutlineMinLeftMargin 6

@synthesize selectRowIndexesEnabled;


// -------------------------------------------------------------------------------

// awakeFromNib

// -------------------------------------------------------------------------------

- (void) awakeFromNib
{
  
  [super awakeFromNib];
  [self setDoubleAction:@selector(doubleClicked:)];
  
  NSTableColumn * noteColumn = [self tableColumnWithIdentifier:@"Note"];
  [[noteColumn headerCell] setImage:[NSImage imageNamed:@"TableHeaderNote"]];
  
  NSTableColumn * fileColumn = [self tableColumnWithIdentifier:@"File"];
  [[fileColumn headerCell] setImage:[NSImage imageNamed:@"TableHeaderFile"]];
  
  NSTableColumn * checkColumn = [self tableColumnWithIdentifier:@"Check"];
  [[checkColumn headerCell] setImage:[NSImage imageNamed:@"SmallCheck"]];
  
  NSTableColumn * imageColumn = [self tableColumnWithIdentifier:@"Image"];
  [[imageColumn headerCell] setImage:[NSImage imageNamed:@"16x16 camera"]];
  
  // for wiki word overlays
  
  NSTrackingArea *tracker = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingEnabledDuringMouseDrag|NSTrackingMouseMoved|NSTrackingActiveInActiveApp owner:self userInfo:nil];
  //NSTrackingMouseEnteredAndExited
  
  scrollView = [self enclosingScrollView];
  
  dragInProgress = NO;

  [self addTrackingArea:tracker];
  
}


// -------------------------------------------------------------------------------

// draggingSession: movedToPoint:

// -------------------------------------------------------------------------------

-(void) draggingSession:(NSDraggingSession *)session movedToPoint:(NSPoint)screenPoint{
  
  //NSLog(@"draggingSession:movedToPoint");
  
  // if details were dropped into a topic header then the items will be dropped inside the topic itself ( not as a node in the view ) and return NSDragOperationNone so the folder doesn't open but we don't want it to animate a slide back to the original location
      
  [session setAnimatesToStartingPositionsOnCancelOrFail:self.animatesToStartingPositionsOnCancelOrFail];
  
}


// -------------------------------------------------------------------------------

// noteHeightOfRowsWithIndexesChanged:

// -------------------------------------------------------------------------------

- (void) noteHeightOfRowsWithIndexesChanged:(NSIndexSet *)indexSet{
  
  //NSLog(@"noteHeightOfRowsWithIndexesChanged");
  
  [super noteHeightOfRowsWithIndexesChanged:indexSet];
}

/*
-(NSRect)frameOfCellAtColumn:(NSInteger)column row:(NSInteger)row
{
  
  NSRect superFrame = [super frameOfCellAtColumn:column row:row];
  
  return superFrame;
  
}
*/


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// THIS is how view-based TableViews select
-(void)selectRowIndexes:(NSIndexSet *)indexes byExtendingSelection:(BOOL)extend{
  //NSLog(@"selectRowIndexes:byExtendingSelection");
  if ([selectRowIndexesEnabled boolValue]) {
    
    [super selectRowIndexes:indexes byExtendingSelection:extend];

  } else {
    // this is set to yes by mouseDown
    indexes = [NSIndexSet indexSet];
    [super selectRowIndexes:indexes byExtendingSelection:NO];
  }

}

// -------------------------------------------------------------------------------

// mouseDragged:

// -------------------------------------------------------------------------------

-(void) mouseDragged:(NSEvent *)theEvent
{
  
  // this only works for me if it's called by the datasource
  // mousedown has to call [super mouseDown] before drag can be detected
  // NSLog(@"Mouse dragged");

  dragInProgress = YES;
  
}

// -------------------------------------------------------------------------------

// mouseUp:

// -------------------------------------------------------------------------------

//-(void) mouseUp:(NSEvent *)theEvent
//{
  
  // only works for on the outline not the row
  //NSLog(@"Mouse up");
  
//}



// -------------------------------------------------------------------------------

// selectedRowFromEvent:

// -------------------------------------------------------------------------------

//Tries to select row and returns
// 1 if row was selected
// 0 if row was already selected
//    and only selects this row if more than one row was selected previously
// NULL if the row could not be selected

-(NSNumber *)selectedRowFromEvent:(NSEvent *)theEvent
{
  //NSLog(@"selectedRowFromEvent --------------");
  
    self.selectRowIndexesEnabled = [NSNumber numberWithBool:YES];
    NSPoint tablePoint = [self convertPoint:theEvent.locationInWindow fromView:nil];
    //NSLog(@"event location: %f, %f", tablePoint.x, tablePoint.y);

    NSInteger rowNum = [self rowAtPoint:tablePoint];
    //NSLog(@"rowNum: %li", rowNum);
    //NSInteger colNum = [self columnAtPoint:tablePoint];

    //NSIndexPath * selectionPath = self.controller.tree.selectionIndexPath;
    NSArray * selectionPaths = self.controller.tree.selectionIndexPaths;
    
    if (rowNum >-1 ) {  //valid row clicked

      //Boolean clickedRowWasPreviouslySelected = ([clickedItemPath compare:selectionPath] == NSOrderedSame); // aside: if NULL is first it will always return NSOrderedSame)

      NSIndexPath * clickedItemPath = [[self itemAtRow:rowNum] indexPath];

      Boolean clickedRowWasPreviouslySelected = NO;

      for (NSIndexPath * selectionPath in selectionPaths){
        
        // aside: if NULL is first it will always return NSOrderedSame)
        if ([clickedItemPath compare:selectionPath] == NSOrderedSame) clickedRowWasPreviouslySelected = YES;
        
      };
      
      NSUInteger flags = [theEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask;

      if ( ! clickedRowWasPreviouslySelected ){

        // does nothing if the shift key is down so that multiple rows can be selected
        
        //if( flags != NSShiftKeyMask ){
          
          //NSLog(@"no shift key");
          //[self.controller.tree setSelectionIndexPath:clickedItemPath]; // prevents selection of multiple rows
          
        //}
        return [NSNumber numberWithInt:1]; //  row was newly selected
        
      } else {
        
        // if it was already selected in a group then let's limit it to just one so that right clicks can select the correct item
        if (selectionPaths.count > 1) {
          

          // holding down shift allows multiple rows selected
          //if((flags != NSShiftKeyMask) && (flags == NSControlKeyMask)){ //right click
          if(flags == NSControlKeyMask){ //right click
            
            //NSLog(@"no shift key");
            [self.controller.tree setSelectionIndexPath:clickedItemPath]; // prevents selection of multiple rows
            
          }
          
        }
        
        return [NSNumber numberWithInt:0]; //  row was already selected
        
      }
          
    } else {
      
      //NSLog(@"select none");
      [self.controller.tree selectNone];
      
      return nil;  // couldn't select row

    }

}

// -------------------------------------------------------------------------------

// checkTextViewCellforEndEditing

// -------------------------------------------------------------------------------


// end editing in textViewCell
// see if a row is selected
// see if that row's textViewCell is being edited

-(void)checkTextViewCellforEndEditing
{
  
  //NSLog(@"assignTopic called: checkTextViewCellforEndEditing");
  
  NSInteger selectedRow = [self selectedRow];

  //NSLog(@"selected row: %li",selectedRow);
  
  if (selectedRow > -1 ){
    
    NSInteger column = [self columnWithIdentifier:@"Detail"];
    
    //NSLog(@"column: %li", column);
    
    DBTableCellTextView * tableCell = [self viewAtColumn:column row:selectedRow makeIfNecessary:NO];
    
    if (tableCell) {
      
      //NSLog(@"tableCell has a value");
      
    } //else {
      
      //NSLog(@"tableCell is null");
      
    //}
    
    DBTextViewCell * textViewCell = [tableCell textView];
    
    if (textViewCell.editingText) {
      
      //NSLog(@"view was editing");
      
      [textViewCell textDidEndEditing:NULL];
      
    } //else {
      
      //NSLog(@"view was NOT editing");
      
    //}
    
  }
  
}

/* moved to super
//assumes a row is selected
-(id)tableCellViewFromEvent:(NSEvent *) theEvent{
  
  NSPoint tablePoint = [self convertPoint:theEvent.locationInWindow fromView:nil];
  NSInteger rowNum = [self rowAtPoint:tablePoint];
  NSInteger colNum = [self columnAtPoint:tablePoint];
  
  return [self viewAtColumn:colNum row:rowNum makeIfNecessary:NO];
}
*/


// -------------------------------------------------------------------------------

// mouseDown:

// -------------------------------------------------------------------------------


-(void)mouseDown:(NSEvent *)theEvent
{
  //NSLog(@"Mouse down");
  NSNumber *rowSelected = [self selectedRowFromEvent:theEvent]; // selects row; YES = newly selected; NO was already selected; NULL couldn't select a row
  
  BOOL openWikiLink = false;
  
  if (rowSelected != NULL){ // means a valid row is selected
    
    id tableCellView = [self tableCellViewFromEvent:theEvent];
    NSString * link;
    Boolean textViewClicked = [tableCellView isKindOfClass:[DBTableCellTextView class]]; // all DBTableCellTextViews have a textView
    
    Boolean doubleClicked;
    
    if ([theEvent clickCount]>=2){
      
      doubleClicked = YES;
      
    } else {
      
      doubleClicked = NO;
      
    }
    //first check for a link
    // then check for a double click
    // then send the mouse even on
    // if a drag didn't start, then
    // select the row if it wasn't previously selected
    
    DBTextViewCell *textViewCell;
    NSInteger characterIndexOfTextView;
    
    if (textViewClicked) {  //check a link was clicked on
      
      textViewCell = [(DBTableCellTextView*)tableCellView textView];
      
      characterIndexOfTextView = [textViewCell characterIndexForInsertionAtPoint:[textViewCell convertPoint:theEvent.locationInWindow fromView:nil ]];
      
      //if the user clicks on the empty space to the right of the word, characterIndexOfTextView returns an index that is one too large
      if (characterIndexOfTextView < textViewCell.textStorage.length) {
        
        //NSLog(@"accepted characterIndex: %li",characterIndexOfTextView);
        
        link = [[textViewCell textStorage] attribute:@"wikiWordURL" atIndex:characterIndexOfTextView effectiveRange:NULL];
        
        //NSLog(@"DBDetailOutlineView: %@", link);
        
        if (link) {
          
          if ([link isEqualToString:@"model"]) {

            //NSLog(@"using model to link...");
            
            NSString * viewIdentifier = [tableCellView identifier];
            DBDetail * detail = [tableCellView objectValue];
            
            if ([viewIdentifier isEqualToString:@"AssociatedCellView"]) {
              
              [appDelegate.calendarController assignDateTopicFromDate: detail.dateAssociated throughLink:YES];
              
            } else if ([viewIdentifier isEqualToString:@"CreatedCellView"]){
              
              [appDelegate.calendarController assignDateTopicFromDate: detail.dateCreated throughLink:YES];

              
            } else if ([viewIdentifier isEqualToString:@"ModifiedCellView"]){
             
              [appDelegate.calendarController assignDateTopicFromDate: detail.dateModified throughLink:YES];
              
            }
            
          } else {
            //NSLog(@"open link");
            openWikiLink = true;

            //[ appDelegate.hyperlinkEditor openWikiLink:link ];
          
          }
          
        } else if (doubleClicked) {
          
          // select everything
          
          [appDelegate.mainWindow makeFirstResponder:textViewCell];
          
          [textViewCell setSelectedRange:NSMakeRange(0, textViewCell.textStorage.length)];
          
        }
        
      }
      
    }
    
    if (!doubleClicked){
      
      // everything before [super mouseDown] is at mouse down
      // calling here allows us to prevent the direct entry to edit mode
      // but allows the drag detection from the datasource
      [super mouseDown:theEvent];//has to be after so previous row is deselected
      //  everything after [super mouseDown] is at mouse up
      
      if (!dragInProgress) {
        
        //NSLog(@"no drag");
        // link here!!
        
        if (openWikiLink) {
          
          [ appDelegate.hyperlinkEditor openWikiLink:link ];

        } else {

          if (![rowSelected boolValue]){ // row was already selected.  insert cursor
            
            if (textViewClicked) {
              
              [appDelegate.mainWindow makeFirstResponder:textViewCell];
              
              [textViewCell setSelectedRange:NSMakeRange(0, textViewCell.textStorage.length)];
              
            }
            
          }
        }
        
      } else {  // drag IS in progress
        
        //if there is a drag in progress we need to reset this variable
        
        dragInProgress = NO;
        
      }
      
    } // (!doubleClicked)
    
  } // (rowSelected != NULL)

}



// -------------------------------------------------------------------------------

// setSortDescriptors:

// -------------------------------------------------------------------------------

//disable reodering when clicking on header
-(void) setSortDescriptors:(NSArray *)array
{
  //NSLog(@"DBDetailOutlineView:setSortDescriptors");
}



// -------------------------------------------------------------------------------

// mouseMoved

// -------------------------------------------------------------------------------

-(void)mouseMoved:(NSEvent *)theEvent
{
  //  NSLog(@"mouseMoved");

  // don't want to see the IBeam unless the textView that the cursor over is the first responder

  NSPoint tablePoint = [self convertPoint:theEvent.locationInWindow fromView:nil];
  NSInteger rowNum = [self rowAtPoint:tablePoint];
  NSInteger colNum = [self columnAtPoint:tablePoint];
  
  if (rowNum > -1) {
    
    id viewCursorIsOver = [self viewAtColumn:colNum row:rowNum makeIfNecessary:NO];
    
    if ([viewCursorIsOver isKindOfClass:[DBTableCellTextView class]]) {
      
      if ( [ appDelegate.mainWindow firstResponder ] != (DBTextViewCell*)[viewCursorIsOver textView] ) {
        
        if ([NSCursor currentCursor] == [NSCursor IBeamCursor]) {
          [[NSCursor arrowCursor]set];
        }
      
      }
    
    }
    
  }
  
}


// -------------------------------------------------------------------------------

// becomeFirstResponder

// -------------------------------------------------------------------------------


- (BOOL)becomeFirstResponder
{
  
  [self.controller.mainDetailViewController becomeActiveViewController];
  
  [self.controller.mainDetailViewController.controllerOfOutlineViews.topicOutlineViewController.tree selectNone];
  
  NSArrayController *recentTopicController = self.controller.mainDetailViewController.controllerOfOutlineViews.recentTopicController;
  [recentTopicController removeSelectionIndexes:[recentTopicController selectionIndexes]];
  
  return [super becomeFirstResponder];//important this is last
    
}


// -------------------------------------------------------------------------------

// reloadData

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

// -------------------------------------------------------------------------------

// createDefaultItemWithString:

// -------------------------------------------------------------------------------

-(void) createDefaultItemWithString:(NSString *)string
{

  //NSLog(@"create default item for detail outline view passing key: %@", string);
  [ appDelegate.detailController insertBulletWithString: string ];
  
}

@end
