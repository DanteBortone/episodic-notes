/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import <Cocoa/Cocoa.h>
//---------------------------------------------

@class DBDetailViewController;

//---------------------------------------------


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
