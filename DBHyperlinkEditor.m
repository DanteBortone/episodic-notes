//
//  DBHyperlinkController.m
//  NoteTaker
//
//  Created by Dante on 2/27/13.
//
//


//---------------------------------------------
#import "DBHyperlinkEditor.h"
//---------------------------------------------
#import "DBControllerOfOutlineViews.h"
#import "DBDetailOutlineViewDelegate.h"
#import "DBDetailOutlineViewController.h"
#import "NoteTaker_AppDelegate.h"
#import "NSCharacterSet_Extensions.h"
#import "NSString_Extensions.h"
#import "DBWikiWord.h"
#import "DBDetailViewController.h"
#import "DBGlobalWiki.h"
#import "DBMainTopic.h"
#import "DBTextFormats.h"
#import "DBTopicObject.h"
#import "DBSubTopic.h"


@implementation DBHyperlinkEditor

//@synthesize wikiFetchRequest;

// -------------------------------------------------------------------------------

// awakeFromNib

// -------------------------------------------------------------------------------

- (void)awakeFromNib {
  
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  controllerOfOutlineViews= appDelegate.controllerOfOutlineViews;
  managedObjectContext = appDelegate.managedObjectContext;
  prohibitedWikiCharacters = [[NSCharacterSet wikiCharacterSet] invertedSet];
  
  plainTextAttributes = appDelegate.textFormatter.plainTextAttributes;
  globalHyperlinkAttributes = appDelegate.textFormatter.globalHyperlinkAttributes;
  localHyperlinkAttributes = appDelegate.textFormatter.localHyperlinkAttributes;
  modelHyperlinkAttributes = appDelegate.textFormatter.modelHyperlinkAttributes;

  [self updateGlobalWikiWordStrings];
  //[self prepWikiFetchPredicate];
  
}


// -------------------------------------------------------------------------------

// setUpHandlingURLEvents

// -------------------------------------------------------------------------------

- (void) setUpHandlingURLEvents
{
 
  NSAppleEventManager *appleEventManager = [NSAppleEventManager sharedAppleEventManager];
  [appleEventManager setEventHandler:self
                         andSelector:@selector(handleGetURLEvent:withReplyEvent:)
                       forEventClass:kInternetEventClass andEventID:kAEGetURL];
  
}


// -------------------------------------------------------------------------------

//  handleGetURLEvent:withReplyEvent:

// -------------------------------------------------------------------------------

- (void)handleGetURLEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{
  
  NSLog(@"handleGetURLEvent");

  [self openWikiLink:[[event paramDescriptorForKeyword:keyDirectObject] stringValue]];

}



// -------------------------------------------------------------------------------

// openWikiLink:

// -------------------------------------------------------------------------------

-(void) openWikiLink:(NSString*)rawLink{
  
  NSMutableString *link = [NSMutableString stringWithString:rawLink];
  [link deleteCharactersInRange:NSMakeRange(0,6)];

  NSRange dotRange = [link rangeOfString:@"."];

  DBTopicObject * topicToAssign;
  
  if (dotRange.location == NSNotFound) {

    topicToAssign = [[self globalWikiFromString:link] topic];
    
  } else {
    
    NSString * globalString =[ link substringToIndex:dotRange.location ];
    NSString * localString = [ link substringFromIndex:dotRange.location + 1 ];
    DBMainTopic * mainTopic = [[self globalWikiFromString:globalString] topic];
    topicToAssign = [mainTopic subTopicFrom:localString];
    
  }
  
  [ [ [ controllerOfOutlineViews targetViewControllerForLinks ] mainDetailViewController] assignTopic:topicToAssign];
  
}


/*
-(void)openLink: (NSString *)link{
  
  //NSLog(@"openLink");

  NSAppleEventDescriptor *event =[NSAppleEventDescriptor
                                  appleEventWithEventClass:kInternetEventClass
                                  eventID:kAEGetURL
                                  targetDescriptor:nil
                                  returnID:kAutoGenerateReturnID
                                  transactionID:kAnyTransactionID];
  
  NSAppleEventDescriptor *linkParameter = [NSAppleEventDescriptor descriptorWithString:link];
  
  [event setDescriptor:linkParameter forKeyword:keyDirectObject];
  
  [self handleGetURLEvent:event withReplyEvent:NULL];
  
}
*/
/*
- (void) prepWikiFetchPredicate {
  
  wikiFetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"GlobalWiki"
                                            inManagedObjectContext:managedObjectContext];
  [wikiFetchRequest setEntity:entity];
  [wikiFetchRequest setFetchLimit:1];//no need to keep searching after 1
  
}
*/

// -------------------------------------------------------------------------------

// addWikiWordsTo: withRespectTo:

// -------------------------------------------------------------------------------

- (NSAttributedString *) addWikiWordsToEntire:(NSString *) text withRespectTo:(DBTopicObject *)topic{
  
  //NSLog(@"addWikiWordsTo");
  //get local topic wikiwords if any exist
  BOOL hasSubTopics = NO;
  NSArray * localWords;
  DBMainTopic * mainTopic;
  if (topic.isGlobal) {
    
    mainTopic = (DBMainTopic *) topic;
    
  } else {
    
    mainTopic = [(DBSubTopic*)topic mainTopic];
    
    //get subgroups of parent
  }
  
  localWords = [ mainTopic allLocalWikiStrings ];
  
  if (localWords.count > 0) {
    
    hasSubTopics = YES;
    
  }
  
  
  
  NSMutableAttributedString *mutAttrString = [[NSMutableAttributedString alloc] initWithString:text];
  
  //set plain text of string
  
  [mutAttrString addAttributes:plainTextAttributes range:NSMakeRange(0, text.length)];
  
  //divide text into words
  NSArray *wordRanges = [text wordRangesWithSeparators:prohibitedWikiCharacters];
  
  //for (NSValue * range in wordRanges) {
  for (int index = 0; index < wordRanges.count; index += 1 ) {
    NSRange range = [[wordRanges objectAtIndex:index] rangeValue];
    NSString *word = [text substringWithRange:range];
    
    //wikiWord = [self wikiWordFromString:word];
    
    if ([self globalWikiWordsIncludesString:word]) {

      [mutAttrString addAttributes:globalHyperlinkAttributes
                                range:range];
      
      [mutAttrString addAttribute:@"wikiWordURL"
                            value:[NSString stringWithFormat:@"epi://%@", word]
                            range:range];
      
      //then check if wiki word has a dot after it and another word range right after
      //  but don't check if it's the last word
      
      if (index < wordRanges.count - 1) {
        NSInteger dotIndex = range.location + range.length;
        //NSLog(@"charatecter after wikiWord: %@" );
        if ([text characterAtIndex:dotIndex] == '.') {
          
          //make sure next range directly follows the "."
          NSRange nextRange = [[wordRanges objectAtIndex:index + 1] rangeValue];
          if (dotIndex == nextRange.location-1) {
            // range directly follows the dot
            
            //need to match the global wikiword to get the subtopics
            
            NSString *nextWord = [[text substringWithRange:nextRange] lowercaseString];
            
            DBMainTopic * mainTopicOfWord = [[self globalWikiFromString:word] topic];
            NSArray *subTopicWords = [mainTopicOfWord allLocalWikiStrings];

            for (NSString * localWikiWord in subTopicWords) {
              
              if ([[localWikiWord lowercaseString] isEqualToString:nextWord]) {
                // found subtopic for last wiki word
                
                [mutAttrString addAttributes:localHyperlinkAttributes
                                       range:nextRange];
                
                [mutAttrString addAttribute:@"wikiWordURL"
                                      value:[NSString stringWithFormat:@"epi://%@.%@", word, nextWord]
                                      range:nextRange];
                
                index += 1;
                break;
              }
            }
          }
        }
        
        
      }
      //then check if wiki word has a dot after it and another word range right after
      //check the next word for being a local topic wrt main topic
      //if so iterate past the next word and keep going
      
    } else {
      
      if ([localWords containsObject:[word lowercaseString]]) {
        
        NSString * parentWord = [[mainTopic.wikiWords anyObject] valueForKey:@"word"];
        
        //[mutAttrString addAttribute:NSLinkAttributeName
          //                    value:[NSString stringWithFormat:@"epi://%@.%@", parentWord ,word]
            //                  range:[range rangeValue]];
        
        [mutAttrString addAttribute:@"wikiWordURL"
                              value:[NSString stringWithFormat:@"epi://%@.%@", parentWord, word]
                              range:range];
        
        [mutAttrString addAttributes:localHyperlinkAttributes
                               range:range];
        
      }
      
    }
    
    
  }//end for

  return mutAttrString;//returns attributed string instead of mutable
          
}



// -------------------------------------------------------------------------------

// addHyperlinksTo: withRespectTo:

// -------------------------------------------------------------------------------

// for wiki words
- (void) addHyperlinksToEntireTextOf:(NSTextView *)textObject withRespectTo:(DBTopicObject *)topic
{
  NSString * text;

  text = [textObject string];
  
  //NSLog(@"addHyperlinksTo: %@", text);

  [[textObject textStorage] setAttributedString: [self addWikiWordsToEntire:text withRespectTo:topic]];
  
}



// -------------------------------------------------------------------------------

// addModelLinksTo:

// -------------------------------------------------------------------------------

// for topic links only. sets hyper link to @"model".  This tells the mousedown event to determine the link target through the item selected and the model.

- (void) addModelLinksTo:(NSTextView *)textObject {
  
  NSMutableAttributedString * mutAttrString = [[NSMutableAttributedString alloc] initWithString:[textObject string]];
  
  NSRange range = NSMakeRange(0, mutAttrString.length);
  
  [mutAttrString addAttributes:plainTextAttributes range:range];
  [mutAttrString addAttributes:modelHyperlinkAttributes range:range];
  
  [[textObject textStorage] setAttributedString: mutAttrString];

}


// -------------------------------------------------------------------------------

// globalWikiFromString:

// -------------------------------------------------------------------------------

- (DBGlobalWiki *) globalWikiFromString:(NSString *) string{
//need as much as possible to be preloaded so this can run fast
  //NSLog(@"DBHyperLinkEditor wikiWordFromString");
  
  NSFetchRequest *wikiFetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"GlobalWiki"
                                            inManagedObjectContext:managedObjectContext];
  [wikiFetchRequest setEntity:entity];
  [wikiFetchRequest setFetchLimit:1];//no need to keep searching after 1
  
  DBGlobalWiki * wikiWord = NULL;
  NSArray * fetchResults;
  NSPredicate* predicate;
  
  predicate = [NSPredicate predicateWithFormat:@"word MATCHES[cd] %@", string ];
  
  [wikiFetchRequest setPredicate:predicate];

  //NSError *error;
  
  fetchResults = [managedObjectContext executeFetchRequest:wikiFetchRequest error:NULL];
  
  if (fetchResults.count == 1) {
    wikiWord = [fetchResults objectAtIndex:0];
  }
    
  return wikiWord;
  
}

// -------------------------------------------------------------------------------

// wikiWordFromString:

// -------------------------------------------------------------------------------

- (DBWikiWord *) wikiWordFromString:(NSString *) string{
  //need as much as possible to be preloaded so this can run fast
  //NSLog(@"DBHyperLinkEditor wikiWordFromString");
  
  NSFetchRequest *wikiFetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"WikiWord"
                                            inManagedObjectContext:managedObjectContext];
  [wikiFetchRequest setEntity:entity];
  [wikiFetchRequest setFetchLimit:1];//no need to keep searching after 1
  
  DBWikiWord * wikiWord = NULL;
  NSArray * fetchResults;
  NSPredicate* predicate;
  
  predicate = [NSPredicate predicateWithFormat:@"word MATCHES[cd] %@", string ];
  
  [wikiFetchRequest setPredicate:predicate];
  
  //NSError *error;
  
  fetchResults = [managedObjectContext executeFetchRequest:wikiFetchRequest error:NULL];
  
  if (fetchResults.count == 1) {
    wikiWord = [fetchResults objectAtIndex:0];
  }
  
  return wikiWord;
  
}

// -------------------------------------------------------------------------------

// updateGlobalWikiWordStrings

// -------------------------------------------------------------------------------

//sets globalWikiWordStrings to lowercase list of wikiWords
-(void) updateGlobalWikiWordStrings {
  //NSLog(@"updateGlobalWikiWordStrings");
  
  NSFetchRequest * globalWikiFetchRequest = [[NSFetchRequest alloc] init];
  
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"GlobalWiki"
                                            inManagedObjectContext:managedObjectContext];
  
  [globalWikiFetchRequest setEntity:entity];
  
  NSArray *fetchResults = [managedObjectContext executeFetchRequest:globalWikiFetchRequest error:NULL];
  
  NSMutableArray * mutableArray = [NSMutableArray arrayWithArray:[fetchResults valueForKey:@"word"]];
                                     
  for (int index = 0; index < mutableArray.count; index += 1){
    
    NSString * string = [[mutableArray objectAtIndex:index] lowercaseString];
    
    [mutableArray setObject:string atIndexedSubscript:index];
    
  }
  
  globalWikiWordStrings = [NSArray arrayWithArray: mutableArray];
  
  //NSLog(@"global WikiWord strings: %@", globalWikiWordStrings);

}

// -------------------------------------------------------------------------------

// globalWikiWordsIncludesString:

// -------------------------------------------------------------------------------

- (BOOL) globalWikiWordsIncludesString: (NSString *) string
{
  
  return [globalWikiWordStrings containsObject:[string lowercaseString]];
  
}


@end
