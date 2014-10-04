//
//  DBAppleScriptTextViewDelegate.m
//  NoteTaker
//
//  Created by Dante on 10/8/13.
//
//
//---------------------------------------------
#import "DBAppleScriptTextViewDelegate.h"
//---------------------------------------------
#import "DBUndoManager.h"
#import "NoteTaker_AppDelegate.h"

@implementation DBAppleScriptTextViewDelegate


@synthesize myTextView;

// -------------------------------------------------------------------------------

// textDidEndEditing

// -------------------------------------------------------------------------------

// to close undo grouping
// see DBScriptTextView becomseFirstResponder for makeUndoable

- (void)textDidEndEditing:(NSNotification *)notification
{

  NSLog(@"DBAppleScriptTextViewDelegate - textDidEndEditing");
  NoteTaker_AppDelegate *appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  
  DBUndoManager *undoManager = appDelegate.undoManager;
  
  [undoManager stopMakingUndoable];
  
  
  
}
// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//gets original cursor position for calculating correct postion after adding hyperlinks
/*
- (void)textViewDidChangeSelection:(NSNotification *)aNotification{
  
  //textLength = myTextView.string.length;
  //insertionPoint = [[[myTextView selectedRanges] objectAtIndex:0] rangeValue].location;
  
}
*/

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------
/*
//adds in applescript formatting and puts cursor back in correct position
- (void)textDidChange:(NSNotification *)aNotification{
  //set the value of compilesSuccessfully
  
  //NSLog(@"textDidChange");

  NSInteger newInsertionPoint;
  NSInteger newTextLength;
  
  newTextLength = myTextView.string.length;
  
  newInsertionPoint = insertionPoint + newTextLength - textLength;
  

  NSAppleScript * script = [[NSAppleScript alloc] initWithSource:myTextView.string];
  
  NSDictionary *errorDict;
    
  if ( ![script compileAndReturnError:&errorDict] ) {
    
    NSLog(@"Script generated a compile error: %@", errorDict);
    
  } else {

    [myTextView.textStorage setAttributedString:[script richTextSource]];
    
  }
  

  //[myTextView setSelectedRange:NSMakeRange(newInsertionPoint, 0)];
  
  
}
*/

@end
