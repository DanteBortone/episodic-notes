//
//  DBViewObject.m
//  NoteTaker
//
//  Created by Dante on 7/11/13.
//
//

//---------------------------------------------
#import "DBViewObject.h"
//---------------------------------------------

// debugging
#import "DBDetail.h"
#import "DBDetailViewController.h"

#define DETAIL_PANEL_MINSIZE 132

@implementation DBViewObject

// Attributes -------------
@dynamic sortIndex;
@dynamic detailPanelHidden;
@dynamic detailPanelSize;
//@dynamic relatedPanelHidden;
//@dynamic relatedPanelSize;
@dynamic tabViewIndex;
@dynamic detailRelatedTabIndex;

// Relationships ----------
@dynamic viewTopic;

@synthesize detailViewController;



- (void) awakeFromInsert //after it's inserted
{
  //NSLog(@"awakeFromInsert view");

  [super awakeFromInsert];
  
  // want to set this here rather than in the model default so the minsize can be set in one place
  self.detailPanelSize = [NSNumber numberWithInteger: DETAIL_PANEL_MINSIZE];

}

\
// -------------------------------------------------------------------------------

// takeSettingsFrom:

// -------------------------------------------------------------------------------

- (void) takeSettingsFrom:(DBViewObject *) viewObject
{
  
  if (viewObject) {
    
    [self setDetailPanelHidden:viewObject.detailPanelHidden];
    [self setDetailPanelSize:viewObject.detailPanelSize];
    //[self setRelatedPanelHidden:viewObject.relatedPanelHidden];
    //[self setRelatedPanelSize:viewObject.relatedPanelSize];
    [self setTabViewIndex: viewObject.tabViewIndex];
    [self setDetailRelatedTabIndex: viewObject.detailRelatedTabIndex];

  } //else NSLog(@"viewobjectblank");

}


// -------------------------------------------------------------------------------

// resetView

// -------------------------------------------------------------------------------

- (void) resetView
{
  //want to reset panel show size & hidden, detail related tab and detail tab
  self.detailPanelHidden = [ NSNumber numberWithBool:YES ];
  self.detailPanelSize = [ NSNumber numberWithInteger: DETAIL_PANEL_MINSIZE ];
  self.detailRelatedTabIndex = [ NSNumber numberWithInteger: 0 ]; // detail tab
  self.tabViewIndex = [ NSNumber numberWithInteger: 1 ];          // note tab
  
}


@end
