//
//  DBFixedCodeTextviewDelegate.h
//  NoteTaker
//
//  Created by Dante on 10/15/13.
//
//

#import <Foundation/Foundation.h>

@class NoteTaker_AppDelegate;
@class DBApplescriptController;

@interface DBFixedCodeTextviewDelegate : NSObject <NSTextViewDelegate>{
  
  NoteTaker_AppDelegate *appDelegate;
  DBApplescriptController *applescriptController;
  
}





@end
