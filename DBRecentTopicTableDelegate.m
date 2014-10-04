//
//  DBRecentTopicTableDelegate.m
//  NoteTaker
//
//  Created by Dante on 7/27/13.
//
//
//---------------------------------------------
#import "DBRecentTopicTableDelegate.h"
//---------------------------------------------
#import "DBTopicObject.h"
#import "DBDetailOutlineViewController.h"
#import "DBControllerOfOutlineViews.h"
#import "NoteTaker_AppDelegate.h"
#import "DBDetailViewController.h"


@implementation DBRecentTopicTableDelegate


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib{
  
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  controllerOfOutlineViews = appDelegate.controllerOfOutlineViews;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification{
  NSArray * selectedObjects = [arrayController selectedObjects];
  DBTopicObject * selectedTopic;
  DBDetailOutlineViewController * activeDetailOutlineViewController;

  if (selectedObjects.count > 0) {
    
    selectedTopic = [selectedObjects objectAtIndex:0];
    activeDetailOutlineViewController = controllerOfOutlineViews.activeDetailOutlineViewController;
    [[(DBDetailOutlineViewController *)activeDetailOutlineViewController mainDetailViewController] assignTopic:selectedTopic];
    
    [arrayController rearrangeObjects];
  }
    
}




@end
