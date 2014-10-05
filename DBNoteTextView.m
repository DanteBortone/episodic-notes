/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBNoteTextView.h"
//---------------------------------------------

#import "DBDetailViewController.h"
#import "DBHyperlinkEditor.h"
#import "NoteTaker_AppDelegate.h"
#import "DBUndoManager.h"

//---------------------------------------------


@implementation DBNoteTextView

@synthesize detailViewController;


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)awakeFromNib{
  
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//  textview size changes from superview size when moved around a lot

-(void) setFrame:(NSRect)oldTextViewFrame{
  
  NSRect superviewFrame = self.superview.frame;

  NSRect newTextViewFrame = NSMakeRect(oldTextViewFrame.origin.x, oldTextViewFrame.origin.y, superviewFrame.size.width, oldTextViewFrame.size.height);
  
  [super setFrame:newTextViewFrame];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) mouseDown:(NSEvent *)theEvent{
  
  BOOL passToSuper = YES;
  
  NSInteger characterIndexOfTextView = [self characterIndexForInsertionAtPoint:[self convertPoint:theEvent.locationInWindow fromView:nil ]];
  
  if (characterIndexOfTextView < self.textStorage.length) {
        
    NSString * link = [[self textStorage] attribute:@"wikiWordURL" atIndex:characterIndexOfTextView effectiveRange:NULL];
    
    if (link){

      [appDelegate.hyperlinkEditor openWikiLink:link];

      passToSuper = NO;
      
    } 
    
  }
  
  // should check if it is first responder already
  [detailViewController becomeActiveViewController];
  
  [[self window] makeFirstResponder:self];// or else the responder status goes to the detailViewController and never goes back
  
  
  if (passToSuper){
    
    //[appDelegate.undoManager makeUndoable]; //see DBNoteDelegate textDidEndEditing for the stop making undoable command
    
    [super mouseDown:theEvent];
  
  }
  
}


@end
