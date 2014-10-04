//
//  DBWikiEntryFormatter.h
//  NoteTaker
//
//  Created by Dante on 3/1/13.
//
//


#import "DBFormatter.h"

@class DBWikiWordController;


@interface DBWikiEntryFormatter : DBFormatter{

  IBOutlet DBWikiWordController * panelController;

}

@end
