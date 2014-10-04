//
//  DBComboBoxDelegate.m
//  NoteTaker
//
//  Created by Dante on 1/4/13.
//
//


//---------------------------------------------
#import "DBComboBoxDelegate.h"
//---------------------------------------------
#import "DBAddTopicController.h"


@implementation DBComboBoxDelegate


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib {

  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  comboBox = addTopicController.topicListComboBox;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//these handle enabling/disabling the "add existing topic button"

- (void)comboBoxSelectionDidChange:(NSNotification *)notification{
  
  //NSLog(@"comboBoxSelectionDidChange");
   
  if ([comboBox objectValueOfSelectedItem]) {
  
    [addTopicController initExistingTopicItems];
  
  }

}




@end
