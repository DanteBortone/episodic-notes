//
//  DBPathControl.h
//  NoteTaker
//
//  Created by Dante on 10/15/13.
//
//

#import <Cocoa/Cocoa.h>

@class NoteTaker_AppDelegate;
@class DBApplescriptController;

@interface DBPathControl : NSPathControl {
  
  NoteTaker_AppDelegate *appDelegate;
  DBApplescriptController *applescriptController;
  
}




@end
