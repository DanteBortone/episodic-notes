//
//  DBMainTopic.m
//  NoteTaker
//
//  Created by Dante on 11/20/13.
//
//

#import "DBMainTopic.h"
#import "DBGlobalWiki.h"
#import "DBSubTopic.h"
#import "DBLocalWiki.h"

@implementation DBMainTopic

// Relationships ----------
@dynamic subTopics;
@dynamic wikiWords;

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL) isGlobal{
  
  return YES;
  
}

// -------------------------------------------------------------------------------

// wikiString

// -------------------------------------------------------------------------------

- (NSString *) wikiString
{
  
  return self.primaryWikiWord.word;
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(NSArray *) allLocalWikiWords{
  
  NSArray * array = [NSArray array];
  
  if (self.subTopics.count > 0) {
    NSMutableArray * mutableArray = [NSMutableArray array];
    
    for (DBSubTopic * subTopic in self.subTopics) {
      
      [mutableArray addObjectsFromArray:[subTopic.wikiWords allObjects]];
      
    }
 
    array = [NSArray arrayWithArray:mutableArray ];
  
  }
  
  return array;
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------
// returns lowercase strings of allLocalWikiWords
-(NSArray *) allLocalWikiStrings{
  
  NSMutableArray * localWikiWords = [NSMutableArray arrayWithArray:[[self allLocalWikiWords] valueForKey:@"word"]];
  
  for (int index = 0; index < localWikiWords.count; index+=1) {
    
    NSString * word = [localWikiWords objectAtIndex:index];
    [localWikiWords setObject:[word lowercaseString] atIndexedSubscript:index];
    
  }
  
  return [NSArray arrayWithArray:localWikiWords];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(NSArray *) allGlobalWikiStrings{
  
  NSMutableArray * localWikiWords = [NSMutableArray arrayWithArray:[[self.wikiWords allObjects] valueForKey:@"word"]];
  
  for (int index = 0; index < localWikiWords.count; index+=1) {
    
    NSString * word = [localWikiWords objectAtIndex:index];
    [localWikiWords setObject:[word lowercaseString] atIndexedSubscript:index];
    
  }
  
  return [NSArray arrayWithArray:localWikiWords];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBGlobalWiki *) primaryWikiWord
{
  
  for (DBGlobalWiki * wikiWord in self.wikiWords) {
    
    if ([wikiWord.isPrimary boolValue]) return wikiWord;
    
  }
  
  return NULL;
  
}






// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBLocalWiki *) localWikiFrom:(NSString *)string
{
  
  NSArray * allLocalWikiWords = [self allLocalWikiWords];
  
  string = [string lowercaseString];
  
  for (DBLocalWiki * wikiWord in allLocalWikiWords) {
    
    if ([string isEqualToString:wikiWord.word.lowercaseString]) {
    
      return wikiWord;
    
    }
    
  }
  
  return NULL;

}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (DBSubTopic *) subTopicFrom:(NSString *)string
{
  
  return [[ self localWikiFrom:string ] topic];
  
}


@end
