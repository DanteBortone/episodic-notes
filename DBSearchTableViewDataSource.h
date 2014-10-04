//
//  DBSearchTableViewController.h
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 7/29/12.
//  Copyright 2012 Dante Bortone. All rights reserved.
//


#import <Cocoa/Cocoa.h>

@class NoteTaker_AppDelegate; //needed to get userSearchController
@class DBControllerOfOutlineViews;


@interface DBSearchTableViewDataSource : NSObject <NSTableViewDataSource> {
  NoteTaker_AppDelegate *appDelegate;
	NSArray	*dragType; 
	IBOutlet NSTableView *searchView;
  NSArrayController *searchArrayController;
  DBControllerOfOutlineViews * controllerOfOutlineViews;
}

@end
