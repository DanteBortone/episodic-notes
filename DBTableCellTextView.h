//
//  DBTableCellView.h
//  NoteTaker
//
//  Created by Angela Bortone on 8/15/13.
//
//

#import <Cocoa/Cocoa.h>

@class DBTextViewCell;

@interface DBTableCellTextView : NSTableCellView {
  
  
}

@property (strong) IBOutlet id textView;//added strong to try to prevent zombie with this object

@end
