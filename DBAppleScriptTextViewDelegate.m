/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBAppleScriptTextViewDelegate.h"
//---------------------------------------------

#import "DBUndoManager.h"
#import "NoteTaker_AppDelegate.h"

//---------------------------------------------


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
