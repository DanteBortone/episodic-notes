//
//  DBFileTopic.h
//  NoteTaker
//
//  Created by Dante on 6/16/13.
//
//


#import "DBMainTopic.h"


@interface DBFileTopic : DBMainTopic

// Attributes -------------
@property (strong) NSNumber * activeLink;
@property (strong) NSString * aliasFileName;
@property (strong) NSImage * fileIcon;
@property (strong) NSString * fileName;
@property (strong) NSDate * lastUse;
@property (strong) NSString * recentPath;

// Relationships ----------
@property (strong) NSSet * referencers;

@end
