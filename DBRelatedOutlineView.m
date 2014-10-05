/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBRelatedOutlineView.h"
//---------------------------------------------

#import "DBOutlineView.h"
#import "DBDetailOutlineViewDelegate.h"
#import "DBOutlineViewcontroller.h"
#import "DBRelatedOutlineViewController.h"
#import "DBDetailOutlineViewController.h"
#import "DBDetailViewController.h"
#import "DBTableCellTextView.h"
#import "NoteTaker_AppDelegate.h"
#import "DBRelatedTextViewCell.h"
#import "NSTreeController_Extensions.h"
#import "DBHyperlinkEditor.h"
#import "DBControllerOfOutlineViews.h"
#import "DBDetail.h"
#import "DBCalendarController.h"
//---------------------------------------------


@implementation DBRelatedOutlineView

@synthesize selectRowIndexesEnabled;


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib{
  
  [super awakeFromNib];
  
  // for wiki word overlays
  
  NSTrackingArea *tracker = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingEnabledDuringMouseDrag|NSTrackingMouseMoved|NSTrackingActiveInActiveApp owner:self userInfo:nil];
  //NSTrackingMouseEnteredAndExited
  
  scrollView = [self enclosingScrollView];
  
  dragInProgress = NO;
  //rowNum = -1;
  //colNum = -1;
  
  [self addTrackingArea:tracker];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)becomeFirstResponder
{
  DBDetailViewController * mainDetailViewController;
  
  mainDetailViewController = [(DBOutlineViewController *)(self.controller) mainDetailViewController];
  
  [ mainDetailViewController.primaryOutlineViewController.view becomeFirstResponder];
  
  [[self delegate] outlineViewSelectionDidChange:NULL];

  //[super becomeFirstResponder];
  
  return YES;

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

/*20131103 these aren't doing anything if you subclass NSTableRowView
 
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
/*
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
*/



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//Tries to select row and returns
// 1 if row was selected
// 0 if row was already selected
// NULL if the row could not be selected

// same as DBDetailOutlineView except: no text editing is needed

-(NSNumber *)selectedRowFromEvent:(NSEvent *)theEvent {
  
  self.selectRowIndexesEnabled = [NSNumber numberWithBool:YES];
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
      //NSLog(@"this row WAS already selected");

      return [NSNumber numberWithInt:0]; //  row was already selected
      
    }
    
  } else {
    
    //NSLog(@"couldn't select a row");
    
    [self.controller.tree selectNone];
    
    return nil;  // couldn't select row
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//assumes a row is selected
-(id)tableCellViewFromEvent:(NSEvent *) theEvent{
  
  NSPoint tablePoint = [self convertPoint:theEvent.locationInWindow fromView:nil];
  NSInteger rowNum = [self rowAtPoint:tablePoint];
  NSInteger colNum = [self columnAtPoint:tablePoint];
    
  return [self viewAtColumn:colNum row:rowNum makeIfNecessary:NO];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)mouseDown:(NSEvent *)theEvent{
  //NSLog(@"DBRelatedOutlineView:mouseDown");
  NSNumber *rowSelected = [self selectedRowFromEvent:theEvent]; // selects row; YES = newly selected; NO was already selected; NULL couldn't select a row
  
  if (rowSelected != NULL){ // means a valid row is selected
    
    NSTableCellView * tableCellView = [self tableCellViewFromEvent:theEvent];
    
    //NSLog(@"tableCellView className: %@", [tableCellView className]);
    Boolean textViewClicked = [tableCellView isKindOfClass:[DBTableCellTextView class]]; // all DBTableCellTextViews have a textView
    
    NSTextView *textViewCell;
    NSInteger characterIndexOfTextView;
    
    if (textViewClicked) {  //check a link was clicked on
      
      //NSLog(@"textViewClicked");
      textViewCell = (NSTextView *)[(DBTableCellTextView*)tableCellView textView];
      
      characterIndexOfTextView = [textViewCell characterIndexForInsertionAtPoint:[textViewCell convertPoint:theEvent.locationInWindow fromView:nil ]];
      
      //if the user clicks on the empty space to the right of the word, characterIndexOfTextView returns an index that is one too large
      if (characterIndexOfTextView < textViewCell.textStorage.length) {
        
        //NSLog(@"accepted characterIndex: %li",characterIndexOfTextView);
        
        NSString * link = [[textViewCell textStorage] attribute:@"wikiWordURL" atIndex:characterIndexOfTextView effectiveRange:NULL];
        
        if(link){
      
          if ([link isEqualToString:@"model"]) {
            
            //NSLog(@"using model to link...");

            NSString * viewIdentifier = [tableCellView identifier];
            //DBTopicObject * linkToTopic;
            DBDetail * detail = [tableCellView objectValue];
            if ([viewIdentifier isEqualToString:@"RelatedTopicCellView"]) {
              
              //NSLog(@"linking to detail's topic");

              [ [ [ appDelegate.controllerOfOutlineViews targetViewControllerForLinks ] mainDetailViewController] assignTopic:detail.topic ];
            
            } else if ([viewIdentifier isEqualToString:@"RelatedDateCellView"]) {
             
              [appDelegate.calendarController assignDateTopicFromDate: detail.dateAssociated throughLink:YES];

            }
            
            
          } else {
            
            //NSLog(@"link: %@", link);

            [ appDelegate.hyperlinkEditor openWikiLink:link ];

          }
          
        } //if (link)
      
      }
      
    }
          
    // everything before [super mouseDown] is at mouse down
    // calling here allows us to prevent the direct entry to edit mode
    // but allows the drag detection from the datasource
    [super mouseDown:theEvent];//has to be after so previous row is deselected
    //  everything after [super mouseDown] is at mouse up
    
    if (dragInProgress) {

      //if there is a drag in progress we need to reset this variable
      
      dragInProgress = NO;
      
    }
      
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) mouseDragged:(NSEvent *)theEvent{
  
  // this only works for me if it's called by the datasource when items are written to pasteboard
  // mousedown has to call [super mouseDown] before drag can be detected
  
  //NSLog(@"mouse dragged");
  dragInProgress = YES;
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)mouseMoved:(NSEvent *)theEvent {
  //  NSLog(@"mouseMoved");
  
  // don't want to see the IBeam unless the textView that the cursor over is the first responder
  
  NSPoint tablePoint = [self convertPoint:theEvent.locationInWindow fromView:nil];
  NSInteger rowNum = [self rowAtPoint:tablePoint];
  NSInteger colNum = [self columnAtPoint:tablePoint];
  
  if (rowNum > -1) {
    
    id viewCursorIsOver = [self viewAtColumn:colNum row:rowNum makeIfNecessary:NO];
    
    if ([viewCursorIsOver isKindOfClass:[DBTableCellTextView class]]) {
      
      if ( [ appDelegate.mainWindow firstResponder ] != (DBRelatedTextViewCell*)[viewCursorIsOver textView] ) {
        
        if ([NSCursor currentCursor] == [NSCursor IBeamCursor]) {
          [[NSCursor arrowCursor]set];
        }
        
      }
      
    }
    
  }
 
}

@end
