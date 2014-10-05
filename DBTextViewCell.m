/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBTextViewCell.h"
//---------------------------------------------

#import "DBHyperlinkEditor.h"
#import "DBOutlineViewDelegate.h"
#import "DBControllerOfOutlineViews.h"
#import "NSString_Extensions.h"
#import "NoteTaker_AppDelegate.h"
#import "DBOutlineViewController.h"
#import "DBOutlineView.h"
#import "DBDetailOutlineView.h"
#import "DBDetailViewController.h"
#import "DBDetailOutlineViewController.h"
#import "DBTableCellTextView.h"
#import "DBDetail.h"
#import "NSCharacterSet_Extensions.h"
#import "DBUndoManager.h"

//debug
#import "NSIndexPath_Extensions.h"

//---------------------------------------------


@implementation DBTextViewCell 

@synthesize outlineViewController;//set by DBDetailOutlineViewDelegate
@synthesize treeNode;
@synthesize editingText;
//@synthesize tableCellView;


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) awakeFromNib{
  
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  controllerOfOutlineViews = appDelegate.controllerOfOutlineViews;
  hyperlinkEditor = appDelegate.hyperlinkEditor;
  
  [self setDrawsBackground: YES];
  
  [self setBackgroundColor: [NSColor clearColor]];
  [self setDelegate:self];
  [self setDisplaysLinkToolTips:NO];

  // trying to keep text from getting clipped
  //NSRect myRect = self.frame;
  
  //[self setFrame:NSMakeRect(myRect.origin.x, myRect.origin.y, myRect.size.width, 20.0f)];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(BOOL) isEditable {
    
  return [[(DBDetailOutlineView *)outlineViewController.view selectRowIndexesEnabled] boolValue];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//gets original cursor position for calculating correct postion after adding hyperlinks

- (void)textViewDidChangeSelection:(NSNotification *)aNotification{
  
  //NSLog(@"DBTextViewCell: textViewDidChangeSelection");
  //don't want other edits to name to 
  if ([appDelegate.mainWindow firstResponder]==self){

    //NSLog(@"textViewDidChangeSelection");
    textLength = self.string.length;
    insertionPoint = [[[self selectedRanges] objectAtIndex:0] rangeValue].location;
    
    
    //why is this here?
    //20131006 [outlineViewController.view becomeFirstResponder];
    //20131006 [outlineViewController.tree setSelectionIndexPath:[treeNode indexPath]];
    //20131006 [appDelegate.mainWindow makeFirstResponder:self];
  
  }

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


-(NSView *)hitTest:(NSPoint)aPoint{
  
  //NSLog(@"DBTextViewCell: hitTest");

  //[[NSCursor pointingHandCursor] set];

  //need to stop the textView from hogging the mouse events
  //so if it's not aready the first responder we don't let it take the hit
  if ([appDelegate.mainWindow firstResponder] == self ) {
    
    return self;

  } else {
    
    return NULL;//outlineViewController.view;
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

 //messed with this to try to get rid of selection highlight left over after resigningFirstResponder
 //it crashes when i initially select the item, if I try to clear the selection. changing the selection colors only change the active selection.
//it resigns firstResponder often, even if just clicking on a different part of the text
-(BOOL) resignFirstResponder {
  
  //NSLog(@"DBTextViewCell:resignFirstResponder to nextResponder: %@", [self nextResponder]);
  //if ([self nextResponder] == [self superview]) {
    //NSLog(@"resigning to my superview");
  //}
  
  BOOL returnValue = [super resignFirstResponder];
  
  return returnValue;
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// Important note: had trouble with begin editing notifications not being called.

// "Begin editing" is rarely called so I'm bypassing this with becomeFirstResponder. This class has a property called editingText.  This property not only holds the original text (so it can be restored if an empty string is entered), but by simply having a value tells us this view is being edited.   becomeFirstResponder effectively takes the place of beginEditing.  It first asks if this view is "editingText" and then proceeds to set the orignal text and do the beginediting tasks.  textReallyDidEndEditing is used in the place of textDidEndEditing.  This method mainly checks if the text is empty and replaces it with the original contents (editingText) if it is.  It also clears editingText to let us know the view isn't editing.  The calls to this method had to be done manually.
- (BOOL) becomeFirstResponder {

  if (!editingText) {
    
    NSLog(@"becomeFirstResponder");

    self.editingText = [NSString stringWithString:[self string]];

    [self setBackgroundColor:[NSColor whiteColor]];
    
    [self setSelectedTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSColor colorWithDeviceRed:(float)176/255 green:(float)211/255 blue:(float)255/255 alpha:1.0], NSBackgroundColorAttributeName, nil]];
    
    //[self setBackgroundColor:[NSColor colorWithDeviceRed:(float)233/255 green:(float)242/255 blue:(float)250/255 alpha:1.0]];
    
    //[self setSelectedTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
      //                               [NSColor lightGrayColor], NSBackgroundColorAttributeName, nil]];
  }
  
  
  DBUndoManager *undoManager = appDelegate.undoManager;
  
  //NSLog(@"grouping level at begin: %li", [undoManager groupingLevel]);
  [undoManager makeUndoable];
  //NSLog(@"grouping level at end: %li", [undoManager groupingLevel]);
  
  return [super becomeFirstResponder];

  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)textDidEndEditing:(NSNotification *)notification{

  
  NSLog(@"textDidEndEditing");

  //  automatically called on:
    //  new selection
    //  window changing responder
    //  assiging new topic
  // called manually when:
    //  pressing enter from text view
    //  adding/removing details or views through DBDetailOutlineView:checkTextViewCellforEndEditing
  
  // ideally could drop the undo action if there's been no change or if the text was deleted but there doesn't seem to be a way to drop the last item from undo stack
  //BOOL cancelUndo = NO;
  
  if (self.editingText) {
    
    //NSLog(@"DBTextViewCell : textDidEndEditing");

    NSString *finalText = [[self string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (finalText.length < 1) {
      
      //NSLog(@"value required: restoring original text");
      //cancelUndo = YES;
      finalText = editingText;
      
    }
    
    //if (finalText == editingText) {
      //cancelUndo = YES;
    //}
    
    DBDetail * detail = treeNode.representedObject;

    [detail setDisplayName:finalText];
    
    [[self textStorage] setAttributedString: [hyperlinkEditor addWikiWordsToEntire:detail.displayName withRespectTo:detail.topic]];
    
    editingText = NULL;
    
    //[appDelegate.mainWindow makeFirstResponder: appDelegate.mainWindow];
    
    // allows up/down arrows and delete key to work after editing
    [appDelegate.mainWindow makeFirstResponder: self.superview.superview.superview];
    

    [self resizeViews];
    
    [self setBackgroundColor: [NSColor clearColor]];
    
    self.selectedTextAttributes = @{}; // gets rid of selection coloring
    
    [detail setDateModified:[NSDate date]];
    
    [ controllerOfOutlineViews updateRelatedContent];

    
    DBUndoManager *undoManager = appDelegate.undoManager;
    
    //NSLog(@"grouping level at end editing: %li", [undoManager groupingLevel]);
    [undoManager stopMakingUndoable];
    //NSLog(@"grouping level after stoping undo: %li", [undoManager groupingLevel]);

  }
  
}






// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------
// used when text is edited for bullet displayNames

- (void)textDidChange:(NSNotification *)aNotification{
  
  //if ([appDelegate.mainWindow firstResponder]==self){
  //NSLog(@"textdid change");
  


  
  NSInteger newInsertionPoint;
  NSInteger newTextLength;
  NSString * text;
  text = [NSString stringWithString:[self string]];

  
  //don't want to allow carrage returns here
  
  if ( [text containsCharacters: [NSCharacterSet endEditingCharacterSet]]){
    
    text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    text = [text stringByReplacingOccurrencesOfString:@"\t" withString:@""];

    [self textDidEndEditing:NULL];
    
  } else {  //  add in hyperlinks and puts cursor back in correct position


    
    //for calculating new cursor position
    newTextLength = text.length;
    
    newInsertionPoint = insertionPoint + newTextLength - textLength;
    
    DBDetail * detail = treeNode.representedObject; 
    
    [[self textStorage] setAttributedString: [hyperlinkEditor addWikiWordsToEntire:text withRespectTo:detail.topic]];// responder change
    
    [self setSelectedRange:NSMakeRange(newInsertionPoint, 0)];

    [self resizeViews];
    
  }

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)resizeViews{
  
  [outlineViewController.view noteHeightOfRowsWithIndexesChanged:[NSIndexSet indexSetWithIndex:[outlineViewController.view rowForItem:treeNode]]];// responder change
  
  //if any other views have the same topic then update these nodes
  NSArray *similarViews = [controllerOfOutlineViews viewControllersWithSameTopicAs:outlineViewController.mainDetailViewController];
  
  DBOutlineView *outline;
  for(DBDetailViewController * detailViewController in similarViews){
    //NSLog(@"similar view found");
    
    outline = detailViewController.primaryOutlineViewController.view;
    [outline reloadData];
    
    //[outline reloadItem:treeNode];
    
    // for every primary outline in these views you need to reload the rowForItem
    // if this doesn't work then we need to what is triggering the update (not textdidchange)
  }
  
}


@end
