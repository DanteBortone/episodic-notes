//
//  DBRelatedOutlineViewController.m
//  NoteTaker
//
//  Created by Dante on 7/7/13.
//
//

//---------------------------------------------
#import "DBRelatedOutlineViewController.h"
//---------------------------------------------

#import "DBDateTopic.h"
#import "DBDetail.h"
#import "DBDetailOutlineViewController.h"
#import "DBDetailViewController.h"
#import "DBFileTopic.h"
#import "DBManagedTreeObject.h"
#import "DBNamedTopic.h"
#import "DBOutlineView.h"
#import "DBRelatedViewDataSource.h"
#import "DBRelatedViewDelegate.h"
#import "DBViewObject.h"
#import "NoteTaker_AppDelegate.h"
#import "NSDate_Extensions.h"
#import "DBSubTopic.h"
#import "DBLocalWiki.h"
#import "NSString_Extensions.h"
#import "DBDetailController.h"
#import "DBObjectClipboard.h"

@implementation DBRelatedOutlineViewController


@synthesize relatedContent;
//@synthesize mainDetailViewController;
//@synthesize mainOutlineController;


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)awakeFromNib{
  
  self.delegate = [[DBRelatedViewDelegate alloc]init];
  self.dataSource = [ [ DBRelatedViewDataSource alloc ] init ];
  
  self.dragType = [NSArray arrayWithObjects:@"detailDrag", nil];
  [ self.view registerForDraggedTypes:self.dragType ];
  
  [ super awakeFromNib ];
  
}
/*
- (id)init{
  
  if (self = [super init]) {
    
    self.delegate = [[DBRelatedViewDelegate alloc]init];
    self.dataSource = [ [ DBRelatedViewDataSource alloc ] init ];
    
    self.dragType = [NSArray arrayWithObjects:@"detailDrag", nil];
    [ self.view registerForDraggedTypes:self.dragType ];
    
    [ self setupDataSourceforOutlineView ];
    [ self setupDelegateforOutlineView ];
    
  }
  
  return self;
  
}
*/

// VIEW TOPIC NEEDS TO REFERENCE THE MAIN OUTLINE CONTROLLER

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) updateRelatedContent{

  NSSet * wikiWords;
  NSPredicate * fetchPredicate;
  NSEntityDescription * entity;
  NSError *error;
  NSMutableArray * mutableRelatedContent;
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  entity = [NSEntityDescription entityForName:@"Detail" inManagedObjectContext:[appDelegate managedObjectContext]];
  [fetchRequest setEntity:entity];
  
  id viewTopic = self.mainDetailViewController.managedViewObject.viewTopic;
  
  // --------------------------------------------------------------
  // file topics
  // --------------------------------------------------------------
  
  if ([viewTopic isKindOfClass:[DBDateTopic class]]) {
    fetchPredicate = [NSPredicate predicateWithFormat:@"dateAssociated >= %@ && dateAssociated < %@", [[viewTopic valueForKey:@"date"] startOfDay],[[viewTopic valueForKey:@"date"] startOfNextDay]];
    
    [fetchRequest setPredicate:fetchPredicate];
    
    mutableRelatedContent = [NSMutableArray arrayWithArray:[[appDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error]];//crash here on deleting subgroup

    if(error != nil){
      
      NSLog(@"DBRelatedOutlineViewController : updateRelatedContent: fetchrequest error: %@", error);
      
    }
    
    //NSLog(@"all files created on this date------");
    //NSLog(@"%@", [mutableRelatedContent valueForKey:@"displayName"]);

    // --------------------------------------------------------------
    // main topics
    // --------------------------------------------------------------
  } else if ([viewTopic isKindOfClass:[DBNamedTopic class]]) {
    
    NSMutableArray * relatedToWikiWords = [NSMutableArray array];
    
    DBTopicObject * topic = viewTopic;
    
    //if (topic.isGlobal) {
    wikiWords = [[topic valueForKey:@"wikiWords"] valueForKey:@"word"];
    //} else {
      
      //wikiWords = [NSSet setWithArray:[NSArray arrayWithObject:[[[(DBSubTopic * )topic wikiWords] anyObject] word]]];
    
    //}
    

    //NSLog(@"wikiWords pre screen: %@", wikiWords);
    
    // get rid of words that are found within other wikiwords,
    //    these would cause duplicates
    //    cheaper to check here than to check each found item
    NSMutableArray * startingWikiWordArray = [NSMutableArray arrayWithArray:[wikiWords allObjects]];
    NSMutableArray * finalWikiWordArray = [NSMutableArray array];

    for (int i = 0; i < startingWikiWordArray.count; i+=1){
      //NSLog(@"i = %i", i);
      NSString * iString = [startingWikiWordArray objectAtIndex:i];
      
      for (int j = 0; j < startingWikiWordArray.count; j+=1) {
        
        if (i!=j) {
          //NSLog(@"j = %i", j);
          
          NSString * jString = [startingWikiWordArray objectAtIndex:j];
          
          if ([iString containsString:jString]){
            
            //NSLog(@"%@ contains %@. Removing %@...", iString, jString, iString);
            
            break;
            
          }

        }
        
        // if you make it all the way through and it doens't contain any of the others then add it to final list
        if (j == (startingWikiWordArray.count - 1) ) {
          
          [finalWikiWordArray addObject:iString];
          
        }
        
      }
      
    }
    
    //NSLog(@"wikiWords post screen: %@", finalWikiWordArray);


    //should really check word ranges with seperators not the word inserted anywhere
    //    but this would probably take a lot longer
    
    for (NSString * word in finalWikiWordArray){
      fetchPredicate = [NSPredicate predicateWithFormat:@"displayName CONTAINS[CD] %@", word];
      [fetchRequest setPredicate:fetchPredicate];
      //NSLog(@"fetchPredicate: %@", [fetchPredicate predicateFormat]);

      [relatedToWikiWords addObjectsFromArray:[[appDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error]];//CRASH here on second time around

    }
    
    mutableRelatedContent = [NSMutableArray arrayWithArray: [NSArray arrayWithArray:relatedToWikiWords]];

    // --------------------------------------------------------------
    // subtopics
    // --------------------------------------------------------------
  } else if ([viewTopic isKindOfClass:[DBSubTopic class]]) {
   
    DBSubTopic * subTopic = viewTopic;
    DBMainTopic * mainTopic = subTopic.mainTopic;
    NSArray * localWikiWords = [subTopic localWikiWordStrings];
    NSArray * globalWikiWords = [mainTopic allGlobalWikiStrings];
    
    // make all combinations of local and global wikiwords
    NSMutableArray *possibleCombinedWordPredicates = [NSMutableArray array];
    for (NSString * globalWikiWord in globalWikiWords) {
      for (NSString * localWikiWord in localWikiWords) {
        
        NSString * combinedWord = [NSString stringWithFormat:@"%@.%@", globalWikiWord, localWikiWord ];
        NSPredicate * wordPredicate = [ NSPredicate predicateWithFormat:@"displayName CONTAINS[CD] %@",combinedWord ];

        [ possibleCombinedWordPredicates addObject: wordPredicate ];
      
      }
    }
    
    
    
    NSPredicate * compoundPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:possibleCombinedWordPredicates];

    [fetchRequest setPredicate:compoundPredicate];

    mutableRelatedContent = [NSMutableArray arrayWithArray:[[appDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error]];


    
    // now find all applicable single word instances of wiki word
    // get all the details having the local words
    

    NSMutableArray *localWordPredicates = [NSMutableArray array];

    for (NSString * localWikiWord in localWikiWords) {
      
      NSPredicate * wordPredicate = [ NSPredicate predicateWithFormat:@"displayName CONTAINS[CD] %@",localWikiWord ];
      
      [ localWordPredicates addObject: wordPredicate ];
      
    }
    
    NSPredicate * compoundLocalWordPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:localWordPredicates];
    
    
    // and must have a topic in the subTopic it's main topic or it sibling topics
    NSMutableArray *topicPredicates = [NSMutableArray array];
    
    [ topicPredicates addObject: [ NSPredicate predicateWithFormat:@"topic == %@", mainTopic] ];

    for (DBSubTopic * subTopic in mainTopic.subTopics) {
      
      NSPredicate * topicPredicate = [ NSPredicate predicateWithFormat:@"topic == %@", subTopic];
      [ topicPredicates addObject: topicPredicate ];
      
    }
    
    NSPredicate * compoundTopicPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:topicPredicates];

    // combine local words and topic with AND
    NSPredicate * localWordAndTopicPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:
                                                @[compoundLocalWordPredicate, compoundTopicPredicate]];
    
    [fetchRequest setPredicate:localWordAndTopicPredicate];
    
    [mutableRelatedContent addObjectsFromArray:[[appDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error]];

    // --------------------------------------------------------------
    // file topics
    // --------------------------------------------------------------
  } else if ([viewTopic isKindOfClass:[DBFileTopic class]]) {
      
    
    fetchPredicate = [NSPredicate predicateWithFormat:@"sourceFile == %@", viewTopic ];
        
    [fetchRequest setPredicate:fetchPredicate];
    
    mutableRelatedContent = [NSMutableArray arrayWithArray:[[appDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error]];
    
    if (error != nil) {
      NSLog(@"DBRelatedOutlineViewController:updateRelatedContent error: %@", error);
      mutableRelatedContent = NULL;
    }
    
  } else if (viewTopic == NULL) {
    
    fetchPredicate = NULL;
    
  } else {
    
    //NSLog(@"DBOutlineViewDelegate updateRelatedContent did not recognize class: %@", [self.mainDetailViewController.managedViewObject.viewTopic className]);
    fetchPredicate = NULL;
    
  }
  
  // remove details that are in viewTopic
  // might not do this correctly for subGroups of subGroups
  [mutableRelatedContent removeObjectsInArray:[self.mainDetailViewController.managedViewObject.viewTopic.details allObjects]];
  
  
  //NSArray * clipboardObjects = [appDelegate.detailController.objectClipboard flattenedContent];
  
  //NSLog(@"clipboard item: %@", [clipboardObjects valueForKey:@"displayName"]);
  
  // remove clipboard items
  [mutableRelatedContent removeObjectsInArray:[appDelegate.detailController.objectClipboard flattenedContent]];
  relatedContent = [ self removeRepeatedSubGroupsOf:mutableRelatedContent ];
  
  [ self.tree setContent:relatedContent ];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSArray *) removeRepeatedSubGroupsOf: (NSArray * ) originalArray{
  
  NSMutableArray * startingObjects = [NSMutableArray arrayWithArray:originalArray];// holds the items we still want to check
  NSMutableArray * otherObjects = [NSMutableArray array]; //holds starting array items minus the object we're testing
  NSMutableArray * returnObjects = [NSMutableArray array];//the items we return

  NSArray * descendantArray;// the descendants of the otherObject in which we are looking for the testingObject
  
  //NSLog(@"==========================================================");
  
  for (DBManagedTreeObject * testingObject in originalArray){

    // init other object for this test
    otherObjects = [NSMutableArray arrayWithArray:startingObjects];
    [otherObjects removeObject:testingObject];  // don't need to test yourself.

    // Go ahead and put it in there. We'll take it out if things don't check out.
    [returnObjects addObject:testingObject];

    //NSLog(@"testingObject: %@", testingObject.displayName);
    for (DBManagedTreeObject * otherObject in otherObjects) {
      
      descendantArray = [otherObject descendantObjects];
      //NSLog(@"descendantArray count: %li", descendantArray.count);
      //NSLog(@"comparing testing object to: %@", otherObject.displayName);
      //NSLog(@"descendantObjects of %@:", otherObject.displayName);
      //for (DBManagedTreeObject * arrayItem in descendantArray) {
        //NSLog(@"%@", arrayItem.displayName);
      //}
      if ([descendantArray containsObject:testingObject]) {
        
        [returnObjects removeObject:testingObject];   // testedObject is redundant
        [startingObjects removeObject:testingObject]; // don't need to keep comparing testingObjects to this item
        
        break;
      }
      
    }
    //NSLog(@"-----------------------------------------------------------");

  }
  
  return [NSArray arrayWithArray:returnObjects];
  
}



@end
