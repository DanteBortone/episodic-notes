//
//  DBOutlineViewDelegate.h
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 5/8/12.
//  Copyright 2012 Dante Bortone. All rights reserved.
//


#import <Cocoa/Cocoa.h>

@class DBOutlineViewDelegate;
@class DBControllerOfOutlineViews;
@class DBTopicObject;
@class NoteTaker_AppDelegate;
@class DBOutlineViewController;

@interface DBOutlineView : NSOutlineView {

  NoteTaker_AppDelegate *appDelegate; //for subclasses to access activeTree
  DBControllerOfOutlineViews * controllerOfOutlineViews;
  
}

@property (strong) DBOutlineViewController * controller;  //the controllers will assign this at awakeFromNIB
@property (retain) DBOutlineViewDelegate * myDelegate;
//@property (strong) IBOutlet NSTextField * header;
//@property (strong) DBTopicObject * viewTopic;
@property BOOL animatesToStartingPositionsOnCancelOrFail;

- (NSTableColumn *) columnWithIndex:(NSInteger)index;
- (BOOL)becomeFirstResponder;
- (void)reloadDataAndReselect;
- (id)tableCellViewFromEvent:(NSEvent *) theEvent;
- (void)copy:(id)sender;
- (void)cut:(id)sender;
- (void)paste:(id)sender;

@end