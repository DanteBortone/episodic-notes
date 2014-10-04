//
//  DBMainSplitView.h
//  NoteTaker
//
//  Created by Dante on 10/28/13.
//
//

#import <Cocoa/Cocoa.h>

@class NoteTaker_AppDelegate;
@class DBDetailViewsSplitView;

@interface DBMainSplitView : NSSplitView <NSSplitViewDelegate> {
  
  NoteTaker_AppDelegate *appDelegate; //to see if the detailSplitView should resize
  DBDetailViewsSplitView * detailSplitView;
  
  NSView * navigationSubview;
  NSView * detailSubview;
  
  //IBOutlet NSSegmentedControl *viewControl;
  //IBOutlet NSSegmentedControl *detailControl;
  //IBOutlet NSSegmentedControl *linkControl;
  //IBOutlet NSSegmentedControl *dragControl;
  

}

//@property BOOL shouldResetViewOnAwakeFromNib;

- (CGFloat) myMinSize;

@end
