//
//  DBLocalWiki.h
//  NoteTaker
//
//  Created by Dante on 11/21/13.
//
//

#import "DBWikiWord.h"

@class DBSubTopic;

@interface DBLocalWiki : DBWikiWord

@property (strong) DBSubTopic * topic;

@end
