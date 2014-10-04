//
//  DBTopicNavComboBoxDelegate.h
//  NoteTaker
//
//  Created by Dante on 10/29/13.
//
//

#import <Foundation/Foundation.h>

@class NoteTaker_AppDelegate;

@interface DBTopicNavComboBox : NSComboBox <NSComboBoxDelegate>{
  
  NoteTaker_AppDelegate *appDelegate;
  IBOutlet NSArrayController *myArrayController;
  
}

@end
