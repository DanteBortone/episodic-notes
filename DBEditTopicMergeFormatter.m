//
//  DBEditTopicMergeFormatter.m
//  NoteTaker
//
//  Created by Dante on 4/23/13.
//
//


//---------------------------------------------
#import "DBEditTopicMergeFormatter.h"
//---------------------------------------------
#import "DBEditTopicController.h"
#import "NSCharacterSet_Extensions.h"
#import "NoteTaker_AppDelegate.h"

@implementation DBEditTopicMergeFormatter


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib
{
  
  prohibitedCharacters = [[NSCharacterSet topicNameCharacterSet] invertedSet];
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  detailController = appDelegate.detailController;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) takeActionWithPartialString:(NSString*)partialString
{
  
  //[ editTopicController validateMergeTopicName: partialString ];  //returned boolean unused

}


@end
