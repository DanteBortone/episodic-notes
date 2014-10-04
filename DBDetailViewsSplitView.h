//
//  DBSplitView.h
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 12/9/12.
//  Copyright 2012 Dante Bortone. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class NoteTaker_AppDelegate;
@class DBControllerOfOutlineViews;


@interface DBDetailViewsSplitView : NSSplitView <NSSplitViewDelegate>{

  NoteTaker_AppDelegate *appDelegate; //to change size of main window to accomdate more views
  DBControllerOfOutlineViews * controllerOfOutlineViews;
} 

@property BOOL makingRoomForDetailViews; //to make sure navigation view doesn't gank the space made for the detail views
@property BOOL gotBigger;


-(BOOL) shouldAdjustMySize;
-(CGFloat) myMinimumViewSize;

@end
