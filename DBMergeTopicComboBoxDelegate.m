//
//  DBMergeTopicComboBoxDelegate.m
//  NoteTaker
//
//  Created by Dante on 5/25/13.
//
//


//---------------------------------------------
#import "DBMergeTopicComboBoxDelegate.h"
//---------------------------------------------
#import "DBEditTopicController.h"


@implementation DBMergeTopicComboBoxDelegate


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib {
  
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  //comboBox = editTopicController.topicComboBox;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)comboBoxSelectionDidChange:(NSNotification *)notification{
  
  if ([comboBox objectValueOfSelectedItem]) {
    
    //[ editTopicController validateMergeTopicName: [comboBox objectValueOfSelectedItem] ];
    
  } else {
    
    //[editTopicController validateMergeTopicName:comboBox.stringValue];
    
  }
  
}

@end
