/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBNoteDelegate.h"
//---------------------------------------------

#import "DBHyperlinkEditor.h"
#import "DBOutlineViewDelegate.h"
#import "DBDetailOutlineViewDelegate.h"
#import "NoteTaker_AppDelegate.h"
#import "DBNoteTextView.h"
#import "DBDetail.h"
#import "DBDetailViewController.h"
#import "DBDetailOutlineViewController.h"
#import "DBUndoManager.h"

//---------------------------------------------


@implementation DBNoteDelegate


@synthesize myTextView;
/*
- (void) awakeFromNib {
  
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  hyperlinkEditor = appDelegate.hyperlinkEditor;
  
}
*/


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (id)init{
  
  if (self = [super init]) {
    
    appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
    hyperlinkEditor = appDelegate.hyperlinkEditor;
    undoManager = appDelegate.undoManager;
    
  }
  
  return self;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//gets original cursor position for calculating correct postion after adding hyperlinks

- (void)textViewDidChangeSelection:(NSNotification *)aNotification{
  
    textLength = myTextView.string.length;
    insertionPoint = [[[myTextView selectedRanges] objectAtIndex:0] rangeValue].location;
    
    //NSLog(@"textViewDidChangeSelection-----------");
    //NSLog(@"textLength: %li", textLength);
    //NSLog(@"insertionPoint: %li", insertionPoint);
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//adds in hyperlinks and puts cursor back in correct position
- (void)textDidChange:(NSNotification *)aNotification{
  //NSLog(@"textDidChange");
  NSInteger newInsertionPoint;
  NSInteger newTextLength;
  
  newTextLength = myTextView.string.length;
  
  newInsertionPoint = insertionPoint + newTextLength - textLength;
  
  //NSLog(@"newInsertionPoint: %li", newInsertionPoint);
  //NSLog(@"newTextLength: %li", newTextLength);
  
  
  // instead of replacing
  [hyperlinkEditor addHyperlinksToEntireTextOf:myTextView withRespectTo:representedObject.topic];
  
  [myTextView setSelectedRange:NSMakeRange(newInsertionPoint, 0)];
  
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) textDidBeginEditing:(NSNotification *)notification{
  //NSLog(@"text began editing");
  NSTreeController * treeController = myTextView.detailViewController.primaryOutlineViewController.tree;

  representedObject = [[treeController selectedObjects] objectAtIndex:0];
  
  //NSLog(@"beging to edit: %@", representedObject.displayName);
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) textDidEndEditing:(NSNotification *)notification{
  
  //NSLog(@"text ended editing");

  //NSLog(@"textDidEndEditing: %@", representedObject.displayName);

  [ representedObject setDateModified: [ NSDate date ] ];
  
  representedObject = NULL;
  
  [undoManager stopMakingUndoable];// look in textShouldBeginEditing for the makeUndoable command

}

-(BOOL) textShouldBeginEditing:(NSText *)textObject
{
  
  [undoManager makeUndoable];// look in DBNoteTextView for the makeUndoable command

  
  return YES;
  
}

@end
