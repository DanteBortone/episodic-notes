//
//  DBEditTopicNewNameFormatter.h
//  NoteTaker
//
//  Created by Dante on 4/23/13.
//
//

#import "DBFormatter.h"

@class DBDetailController;
@class DBEditTopicController;
@class NoteTaker_AppDelegate;

@interface DBEditTopicNewNameFormatter : DBFormatter {

NoteTaker_AppDelegate *appDelegate;
DBDetailController * detailController;

IBOutlet DBEditTopicController * editTopicController;

}

@end
