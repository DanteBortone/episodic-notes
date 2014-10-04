//
//  DBRelatedTextViewCell.h
//  NoteTaker
//
//  Created by Dante on 10/5/13.
//
//

#import <Cocoa/Cocoa.h>

@class NoteTaker_AppDelegate;
@class DBOutlineViewController;


//doesn't have the same editing methods as DBTextViewCell

@interface DBRelatedTextViewCell : NSTextView  <NSTextViewDelegate>{
  
  NoteTaker_AppDelegate *appDelegate;

}

//@property (strong) DBOutlineViewController *outlineViewController;

@end
