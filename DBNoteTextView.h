//
//  DBNoteTextView.h
//  NoteTaker
//
//  Created by Dante on 11/13/13.
//
//

#import <Cocoa/Cocoa.h>
@class DBDetailViewController;
@class NoteTaker_AppDelegate;

@interface DBNoteTextView : NSTextView{
  
  NoteTaker_AppDelegate *appDelegate;
  
}

//@property (strong) IBOutlet NSTreeController *treeController;

@property (weak) DBDetailViewController *detailViewController;

@end
