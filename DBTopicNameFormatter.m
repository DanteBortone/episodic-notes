//
//  DBTopicNameFormatter.m
//  NoteTaker
//
//  Created by Dante on 3/6/13.
//
//


//---------------------------------------------
#import "DBTopicNameFormatter.h"
//---------------------------------------------
#import "DBAddTopicController.h"
#import "DBDetailController.h"
#import "NoteTaker_AppDelegate.h"
#import "NSCharacterSet_Extensions.h"


@implementation DBTopicNameFormatter


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib {
  
  prohibitedCharacters = [[NSCharacterSet topicNameCharacterSet] invertedSet];
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  detailController = appDelegate.detailController;
  
  //[super awakeFromNib]; //overwrites prohibited characters
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)takeActionOnNewLineCharacter{
  
  NSLog(@"newline character detected");
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) takeActionWithPartialString:(NSString*)partialString
{

  [addTopicController validateMainTopicName: partialString];

}



@end
