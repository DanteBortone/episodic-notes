//
//  DBDetailSplitView.h
//  NoteTaker
//
//  Created by Dante on 10/24/13.
//
//

#import <Cocoa/Cocoa.h>
@class DBDetailViewController;
//@class DBViewObject;

@interface DBDetailSplitView : NSSplitView <NSSplitViewDelegate>{
  
  
  // for all intents and purposes collapsing is just hiding
  // it hasn't been tested for setting the collapsable view as view 0.
  //    I doubt it would work a priori
  
 // NSMutableDictionary *minValues;
  NSView * collapsibleSubview;
  NSView * resizableSubview;
  //IBOutlet DBDetailViewController * detailViewController;
  IBOutlet NSButton *toggleCollapseButton;
  IBOutlet NSBox *lineAboveRelatedView;
  NSString * panelHiddenKey;
  NSString * panelSizeKey;
  
  float dimpleDimension;

//--- User Defined attributes ------------------------------------
  NSNumber *minValue0, *minValue1;

  //  0 left/top pane
  //  1 right/bottom pane
  NSNumber *collapsibleIndexNum;  // collapsable view won't resize either
  
  NSNumber * userDefinedDimpleDimension;
  NSNumber * dividerThickness;
  
//---------------------------------------------------------------

  
}
@property (strong) DBDetailViewController * detailViewController;

-(float) minSize;
- (IBAction)toggleCollapse:(id)sender;
- (void) setKeysAndUpdateSplitViewWith:(DBDetailViewController *)viewController hiddenPanelKey:(NSString*)hiddenKey sizeKey:(NSString*)sizeKey;

//- (BOOL)isHidden;
//- (void) setIsHidden:(BOOL)hiddenValue;
//- (float) uncollapsedSize;
//- (void) setUncollapsedSize:(float)size;
-(void) uncollapse;


@end
