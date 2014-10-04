//
//  DBOutlineViewDelegate.h
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 5/8/12.
//  Copyright 2012 Dante Bortone. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DBControllerOfOutlineViews;
@class DBHyperlinkEditor;
@class DBOutlineViewController;
@class NoteTaker_AppDelegate;

@interface DBOutlineViewDelegate : NSObjectController <NSOutlineViewDelegate, NSTableViewDelegate> {

  DBControllerOfOutlineViews * controllerOfOutlineViews;
  DBHyperlinkEditor * hyperlinkEditor;
  NoteTaker_AppDelegate *appDelegate;
  
}

@property (strong) DBOutlineViewController * controller;  //set by controllers on awakeFromNib
@property (strong) NSString * event;//add, remove, drag, null (do nothing)


@end
