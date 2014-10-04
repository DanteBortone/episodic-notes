//
//  DBRelatedOutlineViewController.h
//  NoteTaker
//
//  Created by Dante on 7/7/13.
//
//

#import "DBOutlineViewcontroller.h"
@class DBDetailOutlineViewController;
@class DBDetailViewController;

@interface DBRelatedOutlineViewController : DBOutlineViewController

@property (strong) NSArray * relatedContent;
//@property (strong) DBDetailOutlineViewController * mainOutlineController;
//@property (strong) DBDetailViewController * mainDetailViewController;


- (void) updateRelatedContent;

@end
