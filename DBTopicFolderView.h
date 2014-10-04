//
//  DBTopicFolderView.h
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 6/16/12.
//  Copyright 2012 Dante Bortone. All rights reserved.
//


#import "DBOutlineView.h"

@class DBEditTopicController;


@interface DBTopicFolderView : DBOutlineView {

  IBOutlet DBEditTopicController * editTopicController;
  
}

-(IBAction)testButton:(id)sender;


@end