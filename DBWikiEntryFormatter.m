//
//  DBWikiEntryFormatter.m
//  NoteTaker
//
//  Created by Dante on 3/1/13.
//
//


//---------------------------------------------
#import "DBWikiEntryFormatter.h"
//---------------------------------------------
#import "NSCharacterSet_Extensions.h"
#import "DBWikiWordController.h"


@implementation DBWikiEntryFormatter


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib {
  
  prohibitedCharacters = [[NSCharacterSet wikiCharacterSet] invertedSet];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) takeActionWithPartialString:(NSString*)partialString
{
  
  [ panelController validateWikiWordName: partialString ];  //returned boolean unused
  
}

@end
