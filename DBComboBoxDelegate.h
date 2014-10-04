//
//  DBComboBoxDelegate.h
//  NoteTaker
//
//  Created by Dante on 1/4/13.
//
//


#import <Cocoa/Cocoa.h>

@class NoteTaker_AppDelegate;
@class DBAddTopicController;


@interface DBComboBoxDelegate : NSObject <NSComboBoxDelegate> {
  NoteTaker_AppDelegate *appDelegate;
  NSComboBox * comboBox;
  IBOutlet DBAddTopicController * addTopicController;
  
}

@end
