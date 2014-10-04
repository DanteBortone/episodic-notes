//
//  DBMainTopic.h
//  NoteTaker
//
//  Created by Dante on 11/20/13.
//
//

#import "DBTopicObject.h"

@class DBGlobalWiki;
@class DBLocalWiki;
@class DBSubTopic;

@interface DBMainTopic : DBTopicObject


// Relationships ----------
@property (strong) NSSet* subTopics;
@property (strong) NSSet * wikiWords;


- (NSString *) wikiString;

- (DBGlobalWiki *) primaryWikiWord;
- (NSArray *) allLocalWikiWords;
- (NSArray *) allLocalWikiStrings;
- (NSArray *) allGlobalWikiStrings;
- (DBLocalWiki *) localWikiFrom:(NSString *)string;
- (DBSubTopic *) subTopicFrom:(NSString *)string;

@end
