//
//  DBMergeTopicComboBoxDelegate.h
//  NoteTaker
//
//  Created by Dante on 5/25/13.
//
//


#import <Cocoa/Cocoa.h>

@class DBEditTopicController;
@class NoteTaker_AppDelegate;


@interface DBMergeTopicComboBoxDelegate : NSObject <NSComboBoxDelegate> {

  NoteTaker_AppDelegate *appDelegate;
  NSComboBox * comboBox;
  IBOutlet DBEditTopicController * editTopicController;
  
}

@end
