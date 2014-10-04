//
//  DBTextViewCell.h
//  NoteTaker
//
//  Created by Angela Bortone on 8/16/13.
//
//

#import <Cocoa/Cocoa.h>

@class DBHyperlinkEditor;
@class DBControllerOfOutlineViews;
@class NoteTaker_AppDelegate;
@class DBOutlineViewController;
@class DBTableCellTextView;

@interface DBTextViewCell : NSTextView <NSTextViewDelegate> {
  
  NoteTaker_AppDelegate *appDelegate;
  DBControllerOfOutlineViews *controllerOfOutlineViews;
  DBHyperlinkEditor * hyperlinkEditor;
  
  NSInteger insertionPoint;
  NSInteger textLength;
  //NSString * editingText;
  
}

@property (strong) NSString * editingText;
@property (strong) NSTreeNode *treeNode;
@property (strong) DBOutlineViewController *outlineViewController;

//@property (strong) DBTableCellTextView *tableCellView;

//- (void) textReallyDidEndEditing;


@end
