//
//  DBNewTopicComboBocView.m
//  Episodic Notes
//
//  Created by Dante Bortone on 4/6/14.
//
//

// -----------------------------------------
#import "DBAddNewTopicComboBox.h"
// -----------------------------------------

#import "DBAddTopicController.h"
#import "DBEnterEnabledButton.h"

@implementation DBAddNewTopicComboBox

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib {
  
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  [self setDelegate:self];
  //[self setTarget:self];
  //[self setAction:@selector(returnEntered:)];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//these handle enabling/disabling the "add existing topic button"

- (void)comboBoxSelectionDidChange:(NSNotification *)notification{
  
  NSLog(@"comboBoxSelectionDidChange");
  
  if ([self objectValueOfSelectedItem]) {
    //NSLog(@"objectValueOfSelectedItem");

    [addTopicController initExistingTopicItems];
    
  }
  
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
// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//-(IBAction)returnEntered:(id)sender{
  
  //[ self ]
  //NSLog(@"returnEntered");
  //[ self resignFirstResponder ];
  //[ buttonToSelect becomeFirstResponder ];

//}

@end
