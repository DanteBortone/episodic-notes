//
//  DBNewTopicComboBocView.h
//  Episodic Notes
//
//  Created by Dante Bortone on 4/6/14.
//
//

#import <Cocoa/Cocoa.h>


@class NoteTaker_AppDelegate;
@class DBAddTopicController;
@class DBEnterEnabledButton;

@interface DBAddNewTopicComboBox : NSComboBox <NSComboBoxDelegate> {
  
  NoteTaker_AppDelegate *appDelegate;
  //NSComboBox * comboBox;
  IBOutlet DBAddTopicController * addTopicController;
  IBOutlet DBEnterEnabledButton * buttonToSelect;
  
}



@end
