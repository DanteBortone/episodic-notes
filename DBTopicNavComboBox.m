//
//  DBTopicNavComboBoxDelegate.m
//  NoteTaker
//
//  Created by Dante on 10/29/13.
//
//


//---------------------------------------------
#import "DBTopicNavComboBox.h"
//---------------------------------------------
#import "DBNamedTopic.h"
#import "NoteTaker_AppDelegate.h"
#import "DBControllerOfOutlineViews.h"
#import "DBDetailOutlineViewController.h"
#import "DBDetailViewController.h"


@implementation DBTopicNavComboBox


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib {
  
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  [self setDelegate:self];
  [self setTarget:self];
  [self setAction:@selector(returnEntered:)];
  //[self setDataSource:self];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


- (void)comboBoxWillDismiss:(NSNotification *)notification{

  //NSLog(@"comboBoxWillDismiss");
  
  [self tryLoadingTopic];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(IBAction)returnEntered:(id)sender{
  
  //NSLog(@"returnEntered");

  [self tryLoadingTopic];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


- (void) tryLoadingTopic{
  
  //NSLog(@"tryLoadingTopic");

  
  
  NSInteger index = [self indexOfSelectedItem];
  
  if (index > -1) {
    
    DBNamedTopic *topic = [[myArrayController arrangedObjects] objectAtIndex:index];
    //NSLog(@"foundtopic: %@", topic.displayName);
    
    [appDelegate.controllerOfOutlineViews.activeDetailOutlineViewController.mainDetailViewController assignTopic:topic];
    
  }
  
}


@end
