//
//  DBSubTopicNameFormatter.m
//  NoteTaker
//
//  Created by Dante on 11/17/13.
//
//


//---------------------------------------------
#import "DBSubTopicNameFormatter.h"
//---------------------------------------------
#import "DBSubTopicController.h"
#import "NSCharacterSet_Extensions.h"

@implementation DBSubTopicNameFormatter


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib
{
  
  prohibitedCharacters = [[NSCharacterSet topicNameCharacterSet] invertedSet];
  //appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  
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
  
  [ panelController validateSubTopicName: partialString ];  //returned boolean unused
  
}

@end
