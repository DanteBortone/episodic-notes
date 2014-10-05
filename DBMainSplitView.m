/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBMainSplitView.h"
//---------------------------------------------

#import "NoteTaker_AppDelegate.h"
#import "DBControllerOfOutlineViews.h"
#import "DBDetailViewsSplitView.h"
#import  "DBMainWindow.h"

//---------------------------------------------


#define RESET_DIVIDER_POSITION 180.0f

static float minNavigationSubviewSize = 160.0f;


@implementation DBMainSplitView

//@synthesize shouldResetViewOnAwakeFromNib;

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)awakeFromNib
{
  [ super awakeFromNib ];
  
  [ self setDelegate:self ];

  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  detailSplitView = appDelegate.controllerOfOutlineViews.detailSplitView;

  navigationSubview = [[self subviews] objectAtIndex:0];
  detailSubview = [[self subviews] objectAtIndex:1];

  //[self checkIfLeftSideOf:viewControl overlapsWith:linkControl];
  //[self checkIfLeftSideOf:detailControl overlapsWith:dragControl];
  
  if (appDelegate.shouldResetViews) [self resetView];
  

}

// -------------------------------------------------------------------------------

// resetView

// -------------------------------------------------------------------------------

-(void) resetView
{

  NSLog(@"reset postion of mainSplitView divider");
  [self setPosition:RESET_DIVIDER_POSITION ofDividerAtIndex: 0];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)viewIndex;
{
  NSView * subview = [[self subviews] objectAtIndex:viewIndex];
  
  if (subview == navigationSubview) {
    return minNavigationSubviewSize;
  } else {
    return 0;
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)viewIndex{
  
  CGFloat minDetailViewSize = [detailSplitView myMinimumViewSize];
  
  NSView * nextView = [[self subviews] objectAtIndex:viewIndex+1];
  NSRect nextViewFrame = nextView.frame;
  CGFloat frameOrigin = nextViewFrame.origin.x;
  CGFloat leeway = nextView.frame.size.width - minDetailViewSize;
  return frameOrigin + leeway;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


- (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)subview {
  //NSLog(@"DBMainSplitView shouldAdjustSizeOfSubview");

  
  if (subview == navigationSubview) {
    
    return NO;
    
    /*
    BOOL gettingBigger = [(DBMainWindow *)appDelegate.mainWindow gettingBigger];

    if (detailSplitView.makingRoomForDetailViews) {
      
      //NSLog(@"navigationSubview: NO - makingRoomForDetailViews");
      
      return NO;
    }
    
    if (gettingBigger){
      
      //NSLog(@"navigationSubview: NO - getting bigger");

      return NO;
      
    } else if(navigationSubview.frame.size.width > minNavigationSubviewSize) {
      
      //NSLog(@"navigationSubview: YES - getting smaller and width > minSize");

      //NSLog(@"%f > %f",navigationSubview.frame.size.width,minNavigationSubviewSize);
      return YES;
    
    } else {
      
      //NSLog(@"navigationSubview: NO - getting smaller and width = minSize");

      //NSLog(@"NO");
      return NO;
    }
    */
    
  } else {
    //need width to be greater than the (minwidth * views - dividerthickness*(views-1))
    BOOL shouldAdjustDetailSplitView = [detailSplitView shouldAdjustMySize];

    
    /* this was for making sure the buttons didn't overlap but those buttons are gone now
    if (shouldAdjustDetailSplitView) {
      
      [self checkIfLeftSideOf:viewControl overlapsWith:linkControl];
      
      [self checkIfLeftSideOf:detailControl overlapsWith:dragControl];
      
    }
    */
    
    //NSLog(@"shouldAdjustDetailSplitView: %@", shouldAdjustDetailSplitView? @"YES":@"NO");
     
    return shouldAdjustDetailSplitView;

  }
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


- (void) checkIfLeftSideOf:(NSSegmentedControl *)leftControl overlapsWith: (NSSegmentedControl *) rightControl{

  CGFloat leftBorder = leftControl.frame.origin.x + leftControl.frame.size.width;
  CGFloat rightBorder = rightControl.frame.origin.x;
  
  [rightControl setHidden: (leftBorder > rightBorder) ];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (CGFloat) myMinSize{
  //NSLog(@"DBMainSplitView myMinSize");

  //CGFloat returnValue = (minNavigationSubviewSize + [detailSplitView myMinimumViewSize]);
  CGFloat returnValue = (navigationSubview.frame.size.width + [detailSplitView myMinimumViewSize]);
  
  ///NSLog(@"mainSplitView myMinSize: %f", returnValue);
  
  return returnValue;
  
}

@end
