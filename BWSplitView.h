/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */

/*
 
 This class was built using BWSplitView.h from BWToolkit
 
 Created by Brandon Walkin (www.brandonwalkin.com) and Fraser Kuyvenhoven.
 All code is provided under the New BSD license.
 
 */


//---------------------------------------------
#import <Cocoa/Cocoa.h>
//---------------------------------------------


@interface BWSplitView : NSSplitView <NSSplitViewDelegate>
{
	NSColor *color;
	BOOL colorIsEnabled, dividerCanCollapse, collapsibleSubviewCollapsed;
	NSMutableDictionary *minValues, *maxValues, *minUnits, *maxUnits;  //minUnits - 0 sets units as points; 1 as percent
	NSMutableDictionary *resizableSubviewPreferredProportion, *nonresizableSubviewPreferredSize;
	NSArray *stateForLastPreferredCalculations;
	int collapsiblePopupSelection;
	float uncollapsedSize;
	float dimpleDimension;
	// Collapse button
	NSButton *toggleCollapseButton;
	BOOL isAnimating;
    
//bwsplitview user defined attributes
    // for units: value of 0 is points; 1 is percent
  NSNumber *minValue1, *minValue2, *minUnit1, *minUnit2, *maxValue1, *maxValue2, *maxUnit1, *maxUnit2;
  NSNumber * userDefinedDimpleDimension;
  NSNumber * dividerThickness;

  //to store size of collapsed view after closing program and when restoring the size of the collapsed view
  NSString * userDefaultUncollapseSizeKey;
  
    //for optional settings:
    //  0 neither pane
    //  1 left/top pane
    //  2 right/bottom pane
    int preventResizingOfView;
    int setCollapsibleView;
    
    BOOL collapseByDrag;
    BOOL collapseByDividerClick;
}

@property (strong) NSNumber *userUncollapseSize;//may have manageViewobject take this value in the future to keep values across saves



@property (nonatomic, strong) NSMutableDictionary *minValues, *maxValues, *minUnits, *maxUnits;
@property (strong) NSMutableDictionary *resizableSubviewPreferredProportion, *nonresizableSubviewPreferredSize;
@property (strong) NSArray *stateForLastPreferredCalculations;
@property (unsafe_unretained) id secondaryDelegate;
@property (nonatomic) BOOL collapsibleSubviewCollapsed;
@property int collapsiblePopupSelection;
@property BOOL dividerCanCollapse;//sets if the width of the divider collapses
    // dragging the divider will always collapse the view

//@property BOOL hasAToggleCollapseButton;

// The split view divider color
@property (copy) NSColor *color;

// Flag for whether a custom divider color is enabled. If not, the standard divider color is used.
@property (nonatomic) BOOL colorIsEnabled;

@property (strong) IBOutlet NSButton *toggleCollapseButton;
//declared for debugging purposes--------
- (BOOL)collapsibleSubviewIsCollapsed;
- (NSView *)collapsibleSubview;
//---------------------------------------
- (IBAction)toggleCollapse:(id)sender;
- (IBAction)undoCollapse:(id)sender; //just commented out because I know I'm ot using it right now and need to figure the rest out
//- (IBAction)collapse:(id)sender;
//- (void) collapse;
- (void) undoCollapse;

@end
