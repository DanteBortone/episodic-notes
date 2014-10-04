//
//  DBViewObject.h
//  NoteTaker
//
//  Created by Dante on 7/11/13.
//
//

#import <CoreData/CoreData.h>

@class DBTopicObject;
@class DBDetail;
@class DBDetailViewController;

@interface DBViewObject : NSManagedObject{
  
  
}

// Attributes -------------
@property (strong) NSNumber * sortIndex;
@property (strong) NSNumber * detailPanelHidden;
@property (strong) NSNumber * detailPanelSize;
//@property (strong) NSNumber * relatedPanelHidden;
//@property (strong) NSNumber * relatedPanelSize;
@property (strong) NSNumber * tabViewIndex;
@property (strong) NSNumber * detailRelatedTabIndex;

// Relationships ----------
@property (strong) DBTopicObject * viewTopic;


@property (strong) DBDetailViewController *detailViewController;


//-(BOOL)isDetailPanelHidden;
//-(BOOL)isRelatedPanelHidden;
- (void) takeSettingsFrom:(DBViewObject *)viewObject;
- (void) resetView;



@end
