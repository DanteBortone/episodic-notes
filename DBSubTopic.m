//
//  DBSubTopic.m
//  NoteTaker
//
//  Created by Dante on 11/20/13.
//
//

#import "DBSubTopic.h"
#import "DBLocalWiki.h"
#import "DBHeaderOrganizer.h"
#import "DBMainTopic.h"

@implementation DBSubTopic

// Attributes -------------
@dynamic sortIndex;

// Relationships ----------
@dynamic mainTopic;
@dynamic wikiWords;


// -------------------------------------------------------------------------------

// isGlobal

// -------------------------------------------------------------------------------

- (BOOL) isGlobal
{

  return NO;
  
}

// -------------------------------------------------------------------------------

// wikiString

// -------------------------------------------------------------------------------

// returns wiki word in dot syntax

- (NSString *) wikiString
{
  // returns wiki word in dot syntax
  
  NSString * wikiWord = [NSString stringWithFormat:@"%@.%@", self.mainTopic.wikiString, self.primaryWikiWord.word];
  
  return wikiWord;

}



// -------------------------------------------------------------------------------

// tabbedName

// -------------------------------------------------------------------------------

- (NSString *) tabbedName
{
  
  return [NSString stringWithFormat:@"   %@", self.displayName];
  
}

// -------------------------------------------------------------------------------

// formattedName

// -------------------------------------------------------------------------------

- (NSString *) formattedName
{
  
    return [NSString stringWithFormat:@"%@ : %@", self.mainTopic.displayName, self.displayName];
  
}


// -------------------------------------------------------------------------------

// primaryWikiWord

// -------------------------------------------------------------------------------

- (DBLocalWiki *) primaryWikiWord
{
  
  for (DBLocalWiki * wikiWord in self.wikiWords) {
    
    if ([wikiWord.isPrimary boolValue]) return wikiWord;
    
  }
  
  return NULL;
  
}


// -------------------------------------------------------------------------------

// setSortIndex :

// -------------------------------------------------------------------------------

- (void) setSortIndex:(NSNumber *)sortIndex
{
  
  [self willChangeValueForKey:@"sortIndex"];
  [self setPrimitiveValue:sortIndex forKey:@"sortIndex"];
  [self didChangeValueForKey:@"sortIndex"];
  
  NSSet * headers = [self headers];
  if (headers.count > 1) {// if it's just one header then we know that's the one that set the local topic's header
    for (DBHeaderOrganizer *header in headers) {
      if ([header.sortIndex integerValue] != [sortIndex integerValue]) {
        [header primativeSetSortIndex: sortIndex]; // setting through setSortindex would make a loop
      }
    }
  }

}


// -------------------------------------------------------------------------------

// localWikiWordStrings

// -------------------------------------------------------------------------------

// returns lowercase list of wikiword strings
- (NSArray *) localWikiWordStrings
{
  
  NSMutableArray * mArray = [NSMutableArray array];
  
  for (DBWikiWord * wikiWord in self.wikiWords) {
    
    [mArray addObject:[wikiWord.word lowercaseString]];
    
  }
  
  
  return [NSArray arrayWithArray:mArray];
  
}

// -------------------------------------------------------------------------------

// isWikiTopic

// -------------------------------------------------------------------------------

// to be implemented by Named and Subtopics
// sets whether detail view button is hidden

-(BOOL) isWikiTopic
{
  return YES;
}

@end
