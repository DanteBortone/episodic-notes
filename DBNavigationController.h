//
//  DBNavigationController.h
//  NoteTaker
//
//  Created by Dante on 7/20/13.
//
//

#import "DBObjectController.h"

#import "DBGradientView.h"

@interface DBNavigationController : DBObjectController 



@property (retain) IBOutlet NSButton * folderTab;
@property (retain) IBOutlet NSButton * filesTab;
@property (retain) IBOutlet NSButton * recentTab;
@property (retain) IBOutlet NSTabView * navTabView;
@property (retain) IBOutlet DBGradientView * fileTableHeader;


- (void) initializeActiveTab;
- (IBAction) selectTab:(NSButton *)sender;

@end
