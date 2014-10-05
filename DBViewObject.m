/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBViewObject.h"
//---------------------------------------------

// debugging
#import "DBDetail.h"
#import "DBDetailViewController.h"

//---------------------------------------------


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
