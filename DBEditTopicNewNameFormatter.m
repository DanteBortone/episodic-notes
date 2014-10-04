//
//  DBEditTopicNewNameFormatter.m
//  NoteTaker
//
//  Created by Dante on 4/23/13.
//
//


//---------------------------------------------
#import "DBEditTopicNewNameFormatter.h"
//---------------------------------------------
#import "DBDetailController.h"
#import "DBEditTopicController.h"
#import "NoteTaker_AppDelegate.h"
#import "NSCharacterSet_Extensions.h"


@implementation DBEditTopicNewNameFormatter


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

-(void)takeActionOnNewLineCharacter{
  
  NSLog(@"newline character detected");
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) takeActionWithPartialString:(NSString*)partialString
{
  
   // initialize the add topic panel based on the partial string
   //want to tell if
        //  it's the same name
        //  it already exists as a topic
        //  it is empty.
  //  how about validateNewName method for editnewnamecontroller?
  
  [ editTopicController validateNewName: partialString ];  //returned boolean unused
  
}
@end
