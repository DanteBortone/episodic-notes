//
//  DBRelatedOutlineView.h
//  NoteTaker
//
//  Created by Dante on 6/4/13.
//
//

//#import <Cocoa/Cocoa.h>
#import "DBOutlineView.h"

@class DBDetailOutlineViewDelegate;


@interface DBRelatedOutlineView : DBOutlineView {
  
  //IBOutlet DBDetailOutlineViewDelegate * mainViewDelegate;
  NSScrollView * scrollView;
  BOOL dragInProgress;
}

@property (strong) NSNumber *selectRowIndexesEnabled;

@end
