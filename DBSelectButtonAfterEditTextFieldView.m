//
//  DBSelectButtonAfterEditTextFieldView.m
//  Episodic Notes
//
//  Created by Dante Bortone on 4/7/14.
//
//

#import "DBSelectButtonAfterEditTextFieldView.h"

@implementation DBSelectButtonAfterEditTextFieldView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------
- (void)textDidEndEditing:(NSNotification *)aNotification
{
  
  //NSLog(@"textDidEndEditing");
  
  // remove selection
  NSWindow * myWindow = [ self window ];
  NSText* textEditor = [myWindow fieldEditor:YES forObject:self];
  [textEditor setSelectedRange:NSMakeRange(0, 0)];
  
  
  [ myWindow makeFirstResponder: buttonToSelect ];
  
}

@end
