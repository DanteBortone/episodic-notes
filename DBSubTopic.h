//
//  DBSubTopic.h
//  NoteTaker
//
//  Created by Dante on 11/20/13.
//
//

#import "DBTopicObject.h"

@class DBMainTopic;
@class DBLocalWiki;


@interface DBSubTopic : DBTopicObject

// Attributes -------------
@property (strong) NSNumber * sortIndex;

// Relationships ----------
@property (strong) DBMainTopic * mainTopic;
@property (strong) NSSet * wikiWords;

- (DBLocalWiki *) primaryWikiWord;
- (NSArray *) localWikiWordStrings;

@end
