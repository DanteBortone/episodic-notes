//
//  DBNoteTextView.m
//  NoteTaker
//
//  Created by Dante on 11/13/13.
//
//


//---------------------------------------------
#import "DBNoteTextView.h"
//---------------------------------------------
#import "DBDetailViewController.h"
#import "DBHyperlinkEditor.h"
#import "NoteTaker_AppDelegate.h"
#import "DBUndoManager.h"

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
