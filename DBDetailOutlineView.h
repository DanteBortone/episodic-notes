//
//  DBDetailOutlineView.h
//  NoteTaker
//
//  Created by Dante on 7/4/13.
//
//

#import "DBOutlineView.h"

@interface DBDetailOutlineView : DBOutlineView {
  
  //NSInteger rowNum;
  //NSInteger colNum;
  //NSTextView * textOverView;
  NSScrollView * scrollView;
  BOOL dragInProgress;

}




//this is important.  view-based outline/table views utilize this method:
//-(void)selectRowIndexes:(NSIndexSet *)indexes byExtendingSelection:(BOOL)extend{
// to systematically select rows as they are inserted.  This selection cannot be stopped by anything the tree controller does. I don't want my views selected when the views are initialized.  My solution to stop it is to inactivate "selectRowIndexes" during DBDetailViewController assignTopic.  I reactivate selectRowIndexesEnabled when needed: mouseDown on outlineView, add insert or remove, drag, others??? DBTextViewCell also looks to this value to see if it should become editable. It's an NSNumber so we can set value for the key in other places.

@property (strong) NSNumber *selectRowIndexesEnabled;

- (NSNumber *) selectedRowFromEvent:(NSEvent *)theEvent;
- (void) checkTextViewCellforEndEditing;


@end
