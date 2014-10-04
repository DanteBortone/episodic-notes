//
//  DBSearchController.h
//  NoteTaker
//
//  Created by Dante on 3/16/13.
//
//


#import "DBObjectController.h"


@interface DBSearchController : DBObjectController <NSWindowDelegate>


@property (strong) NSPredicate *userSearchPredicate;
@property (nonatomic, strong) IBOutlet NSWindow * searchWindow;
@property (strong) IBOutlet NSArrayController *searchArrayController;
@property (strong) IBOutlet NSPredicateEditor * predicateEditor;
//@property (strong) IBOutlet NSTableView *myTable;


- (void) initializeSearchPredicate;
- (void) storeSearchPredicate;

- (IBAction)toggleSearchWindow:(id)sender;
//- (IBAction)closeSearchWindow:(id)sender;

-(IBAction)testButton:(id)sender;




@end
