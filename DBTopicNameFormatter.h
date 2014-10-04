//
//  DBTopicNameFormatter.h
//  NoteTaker
//
//  Created by Dante on 3/6/13.
//
//


// for add global wiki topic panel combo box

#import "DBFormatter.h"

@class DBAddTopicController;
@class DBDetailController;
@class NoteTaker_AppDelegate;


@interface DBTopicNameFormatter : DBFormatter
{

  NoteTaker_AppDelegate *appDelegate; //for subclasses to access activeTree
  DBDetailController * detailController;
  
  IBOutlet DBAddTopicController * addTopicController;
  
}

@end
