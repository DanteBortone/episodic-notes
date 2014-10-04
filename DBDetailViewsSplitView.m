//
//  DBSplitView.m
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 12/9/12.
//
//


//---------------------------------------------
#import "DBDetailViewsSplitView.h"
//---------------------------------------------
#import "NoteTaker_AppDelegate.h"
#import "NSView_Extensions.h"
#import "DBMainWindow.h"
#import "DBControllerOfOutlineViews.h"
#import "DBDetailViewController.h"
#import "DBHighlightView.h"

//static float minSplitViewSize = 175;


@implementation DBDetailViewsSplitView

@synthesize gotBigger;
@synthesize makingRoomForDetailViews;


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)awakeFromNib
{
  
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  controllerOfOutlineViews = appDelegate.controllerOfOutlineViews;
  [self setDelegate:[super delegate]];
  [super setDelegate:self];
  makingRoomForDetailViews = NO;
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)viewIndex;
{

  NSView * subview = [[self subviews] objectAtIndex:viewIndex];
  NSRect subviewFrame = subview.frame;
	CGFloat frameOrigin = subviewFrame.origin.x;

  return frameOrigin + [self minSizeOfSubviewAtIndex:viewIndex];

}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(float) minSizeOfSubviewAtIndex:(NSInteger)subviewIndex{

  DBDetailViewController * viewController = [[controllerOfOutlineViews detailViewControllerArray] objectAtIndex:subviewIndex];
  
  
  return viewController.minViewWidth;
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(CGFloat)myMinimumViewSize{
  
  //NSLog(@"DBDetailviewsSplitView myMinimumViewSize");
  
  CGFloat minSize = 0.0f;
  NSArray * controllerArray = [NSArray arrayWithArray:[controllerOfOutlineViews detailViewControllerArray]];
  
  if (controllerArray.count > 0) {
    
    for( DBDetailViewController * viewController in controllerArray ){
      
      minSize += viewController.minViewWidth;
      //NSLog(@"DBDetailviewsSplitView minViewWidth: %f",
            //minSize += viewController.minViewWidth);
      
    }
    
    minSize += self.dividerThickness * (controllerArray.count-1);
  }

  //NSLog(@"DBDetailviewsSplitView dividerThickness: %f", self.dividerThickness * (controllerArray.count-1));


  return minSize;

}

/*
-(float) minSplitViewSize{
  //value of the fixed columns plus some minimum for the displayname column
  
  
  
  return minDisplayNameSize;
  
}
*/

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)viewIndex;
{

  // don't allow expansion if it crushes the view next to it
  
    NSView * nextView = [[self subviews] objectAtIndex:viewIndex+1];
    NSRect nextViewFrame = nextView.frame;
    CGFloat frameOrigin = nextViewFrame.origin.x;
    CGFloat leeway = nextView.frame.size.width - [self minSizeOfSubviewAtIndex:viewIndex+1];
    return frameOrigin + leeway;
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)addSubview:(NSView *)newView positioned:(NSWindowOrderingMode)place relativeTo:(NSView *)otherView{

  //NSLog(@"DBDetailviewsSplitView addSubview");

  //NSLog(@"adding subview");
  //check if the view is big enough
  CGFloat myWidth = self.frame.size.width;
  NSInteger viewCount = [[self subviews] count] + 1;
  CGFloat widthNeeded = self.myMinimumViewSize;
  
  if (myWidth < widthNeeded) {

    //NSLog(@"need to make window bigger");
    makingRoomForDetailViews = YES;
    
    NSWindow *mainWindow = appDelegate.mainWindow;
    CGFloat newWindowWidth = mainWindow.frame.size.width + widthNeeded - myWidth;
    NSRect newWindowRect = NSMakeRect(mainWindow.frame.origin.x, mainWindow.frame.origin.y, newWindowWidth, mainWindow.frame.size.height);
    
    [mainWindow setFrame:newWindowRect display:YES];
    
    myWidth = self.frame.size.width;
  
  }
  
  [super addSubview:newView positioned:place relativeTo:otherView];
  
  makingRoomForDetailViews = NO;
//set widths to the minwidth plus the average of what's left over
  CGFloat addWidth = (myWidth - widthNeeded - self.dividerThickness * (viewCount-1))/viewCount;
  
  //CGFloat averageWidth = (myWidth - [self dividerThickness] * (viewCount-1))/viewCount;
  
  for (DBDetailViewController * viewController in controllerOfOutlineViews.detailViewControllerArray){
    
    [ viewController.myView changeWidthTo:(viewController.minViewWidth + addWidth)];
  
  }
  
  
//  for (NSView *view in [self subviews]){
    
  //  [view changeWidthTo:averageWidth];
    
//  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(NSInteger)indexOfSubView:(NSView *)subView{

  //NSLog(@"DBDetailviewsSplitView indexOfSubView");

  NSArray * subviews = [self subviews];
  
  if (subviews.count > 0){
    
    for (NSInteger index = 0; index < subviews.count; index += 1){
      
      if ( subView == [subviews objectAtIndex:index]){
        
        return index;
        
      }
      
    }
  
  }
    
  return NULL;

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)subview{
  //NSLog(@"DBDetailviewsSplitView shouldAdjustSizeOfSubview");

  
  if ([(DBMainWindow *)appDelegate.mainWindow gettingBigger]) {
    return YES;
  }
  
  //if (gotBigger) {
  
    //return YES;
  
  //}
  
  if (subview.frame.size.width > [self minSizeOfSubviewAtIndex:[self indexOfSubView:subview]]) {
  
    return YES;
  
  } else {
  
    return NO;

  }
  
}

/*
-(CGFloat) myMinimumViewSize{

  
  NSInteger viewCount = [[self subviews] count];
  CGFloat widthNeeded = viewCount * minSplitViewSize + [self dividerThickness] * (viewCount-1);
  
  return widthNeeded;
  
}
*/


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)resizeSubviewsWithOldSize:(NSSize)oldBoundsSize{
  //NSLog(@"DBDetailviewsSplitView resizeSubviewsWithOldSize");

  gotBigger = (oldBoundsSize.width < self.frame.size.width);
  
  [super resizeSubviewsWithOldSize:oldBoundsSize];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(BOOL) shouldAdjustMySize{
  //NSLog(@"DBDetailviewsSplitView shouldAdjustMySize");

  if (makingRoomForDetailViews) {
    return YES;
  }
  
  if ( [(DBMainWindow *)appDelegate.mainWindow gettingBigger]) {
    
    return YES;
  
  }
  
  CGFloat myWidth = self.frame.size.width;
  //NSInteger viewCount = [[self subviews] count];
  CGFloat widthNeeded = self.myMinimumViewSize;

  if (myWidth > widthNeeded) {
    
    //NSLog(@"shouldAdjustMySize:YES");
    return YES;
    
  } else {
    
    //NSLog(@"shouldAdjustMySize:NO");
    return NO;
  
  }
  
}


@end
