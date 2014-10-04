//
//  DBObjectController.m
//  NoteTaker
//
//  Created by Dante on 6/30/13.
//
//


//---------------------------------------------
#import "DBObjectController.h"
//---------------------------------------------
#import "NoteTaker_AppDelegate.h"


@implementation DBObjectController


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib {
  
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (id)init{
  
  if (self = [super init]) {

    appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];

  }
  
  return self;

}

@end
