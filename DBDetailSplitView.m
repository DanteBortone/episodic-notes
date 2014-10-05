/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBDetailSplitView.h"
//---------------------------------------------

#import "DBDetailViewController.h"
#import "DBViewObject.h"
#import "NSColor_Extensions.h"

//---------------------------------------------


static float scaleFactor = 1.0f;
static NSGradient *gradient;
static NSColor *borderColor, *gradientStartColor, *gradientEndColor;
static NSImage *dimpleImageBitmap, *dimpleImageVector;

static float minDisplayNameSize = 100;


@implementation DBDetailSplitView

@synthesize detailViewController;


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

+ (void)initialize;
{

  scaleFactor = [[NSScreen mainScreen] backingScaleFactor];

  borderColor        = [NSColor colorWithCalibratedWhite:(165.0f / 255.0f) alpha:1];
  gradientStartColor = [NSColor colorWithCalibratedWhite:(253.0f / 255.0f) alpha:1];
  gradientEndColor   = [NSColor colorWithCalibratedWhite:(222.0f / 255.0f) alpha:1];
  
  gradient           = [[NSGradient alloc] initWithStartingColor:gradientStartColor endingColor:gradientEndColor];

  NSBundle *bundle = [NSBundle bundleForClass:[DBDetailSplitView class]];

	dimpleImageBitmap  = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"GradientSplitViewDimpleBitmap.tif"]];
	dimpleImageVector  = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"GradientSplitViewDimpleVector.pdf"]];
  [dimpleImageBitmap setFlipped:YES];
	[dimpleImageVector setFlipped:YES];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)awakeFromNib
{
  [self setDelegate:[super delegate]];
  [super setDelegate:self];
  
	scaleFactor = [[NSScreen mainScreen] backingScaleFactor];

// convert user defined attributes -----------------------------
  NSInteger collapsibleViewIndex = [collapsibleIndexNum integerValue];//  0 left/top pane; 1 right/bottom pane

  collapsibleSubview = [[self subviews] objectAtIndex:collapsibleViewIndex];
  
  if(collapsibleViewIndex == 0){
    resizableSubview = [[self subviews] objectAtIndex:1];
  } else {
    resizableSubview = [[self subviews] objectAtIndex:0];
  }
  
  if (userDefinedDimpleDimension == NULL){
    
    //NSLog(@"dimple dimension not specified");
    dimpleDimension = 2.5f;
    
  } else {
    
    dimpleDimension = [userDefinedDimpleDimension floatValue];
    
  }
  
  if (dividerThickness==NULL) {
    //NSLog(@"Divider thickness not specified");
    
    if ([self dividerStyle] == NSSplitViewDividerStyleThin ) {
      
      dividerThickness = [NSNumber numberWithFloat:0];
      
    } else {
      
      dividerThickness = [NSNumber numberWithFloat:10];
      
    }
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// called by DBDetailViewController:setManagedViewObject
- (void) setKeysAndUpdateSplitViewWith:(DBDetailViewController *)viewController hiddenPanelKey:(NSString*)hiddenKey sizeKey:(NSString*)sizeKey;
{
  detailViewController = viewController;
  panelHiddenKey = hiddenKey;
  panelSizeKey = sizeKey;
  
  float constantWidth = collapsibleSubview.frame.size.width;
  [collapsibleSubview setFrameSize:NSMakeSize(constantWidth, self.uncollapsedSize)];


  [self updateCollapsibleView];
  

}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)drawDividerInRect:(NSRect)aRect
{

	if ([self dividerThickness] < 1.01)
	{
			[super drawDividerInRect:aRect];
	}
	else
	{
		[self drawGradientDividerInRect:aRect];
	}
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)drawGradientDividerInRect:(NSRect)aRect
{
	aRect = [self centerScanRect:aRect];
  
	if ([self isVertical])
	{
		// Draw gradient
		NSRect gradRect = NSMakeRect(aRect.origin.x + 1 / scaleFactor,aRect.origin.y,aRect.size.width - 1 / scaleFactor,aRect.size.height);
		[gradient drawInRect:gradRect angle:0];
    
		// Draw left and right borders
		[borderColor bwDrawPixelThickLineAtPosition:0 withInset:0 inRect:aRect inView:self horizontal:NO flip:NO];
		[borderColor bwDrawPixelThickLineAtPosition:0 withInset:0 inRect:aRect inView:self horizontal:NO flip:YES];
	}
	else
	{
		// Draw gradient
		NSRect gradRect = NSMakeRect(aRect.origin.x,aRect.origin.y + 1 / scaleFactor,aRect.size.width,aRect.size.height - 1 / scaleFactor);
		[gradient drawInRect:gradRect angle:90];
    
		// Draw top and bottom borders
		[borderColor bwDrawPixelThickLineAtPosition:0 withInset:0 inRect:aRect inView:self horizontal:YES flip:NO];
		[borderColor bwDrawPixelThickLineAtPosition:0 withInset:0 inRect:aRect inView:self horizontal:YES flip:YES];
	}
	
	[self drawDimpleInRect:aRect];
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)drawDimpleInRect:(NSRect)aRect
{
  float startY = aRect.origin.y + roundf((aRect.size.height / 2) - (dimpleDimension / 2));
  float startX = aRect.origin.x + roundf((aRect.size.width / 2) - (dimpleDimension / 2));
  NSRect destRect = NSMakeRect(startX,startY,dimpleDimension,dimpleDimension);
	
	// Draw at pixel bounds
	destRect = [self convertRectToBacking:destRect];
	destRect.origin.x = floor(destRect.origin.x);
	
	double param, fractPart, intPart;
	param = destRect.origin.y;
	fractPart = modf(param, &intPart);
	if (fractPart < 0.99)
		destRect.origin.y = floor(destRect.origin.y);
	destRect = [self convertRectFromBacking:destRect];
	
	if (scaleFactor == 1)
	{
		NSRect dimpleRect = NSMakeRect(0,0,dimpleDimension,dimpleDimension);
		[dimpleImageBitmap drawInRect:destRect fromRect:dimpleRect operation:NSCompositeSourceOver fraction:1];
	}
  else
	{
		NSRect dimpleRect = NSMakeRect(0,0,[dimpleImageVector size].width,[dimpleImageVector size].height);
		[dimpleImageVector drawInRect:destRect fromRect:dimpleRect operation:NSCompositeSourceOver fraction:1];
	}
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)collapsibleViewHidden {
 
  //NSLog(@"collapsibleViewHidden");
 
  return [[detailViewController.managedViewObject valueForKey:panelHiddenKey] boolValue];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) setCollapsibleViewHidden:(BOOL)hiddenValue {
  
  [detailViewController.managedViewObject setValue:[NSNumber numberWithBool:hiddenValue] forKey:panelHiddenKey];
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (float) uncollapsedSize{
  
  return [[detailViewController.managedViewObject valueForKey:panelSizeKey] floatValue];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) setUncollapsedSize:(float)size{
  
  //NSLog(@"setUncollapsedSize: %f", size);
  [detailViewController.managedViewObject setValue:[NSNumber numberWithFloat:size] forKey:panelSizeKey];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


-(float) minSize{
  //value of the fixed columns plus some minimum for the displayname column
  
  
  
  return minDisplayNameSize;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)subview
{
  NSView * topSubview = [[self subviews] objectAtIndex:0];
  
  
  if (subview == topSubview) {
    if(subview.frame.size.height > [minValue0 floatValue])
      return YES;
    else
      return NO;
  } else {
    
    // this prevents the sizing of the outer view from modifying the detail panel size on startup
    // also we're assuming people will set these panels at the minimum that they want and we won't mess with that unless the collasping of the upper view requires it.
    
    if(topSubview.frame.size.height > [minValue0 floatValue])
      return NO;
    else
      return YES;
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex;
{
		
	CGFloat min = [minValue0 floatValue];
  
  return min;
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex;
{
  
	CGFloat max = self.frame.size.height - [self dividerThickness] - [minValue1 floatValue];
  
  return max;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)splitViewDidResizeSubviews:(NSNotification *)aNotification
{
  //NSLog(@"splitViewDidResizeSubview.......");
  
  float height = [[NSNumber numberWithFloat:collapsibleSubview.frame.size.height] floatValue];
  
  //don't want the to get set to 0 (a collapsed panel)
  if (height > 0) {
    
    [self setUncollapsedSize:height];

  }
  
  if ([self isSubviewCollapsed:collapsibleSubview]) {
    [self collapse]; // because dragged collapse doesn't leave things the way we like them
  } else if ([self collapsibleViewHidden]){
    [self uncollapse];
  }
  
  [self adjustSubviews];
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview{
  //NSLog(@"canCollapseSubView");
  
  if (subview == collapsibleSubview) {
    return YES;
  } else {
    return NO;
  }
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)toggleCollapse:(id)sender;
{

  if (self.collapsibleViewHidden)
  {
    [self uncollapse];
  }
  else
  {
    [self collapse];
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


- (void) updateCollapsibleView{
  
  if (self.collapsibleViewHidden)
  {
    [self collapse];
  }
  else
  {
    [self uncollapse];
  }
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


-(void) collapse
{
  
  //NSLog(@"COLLAPSE");
  
  [self setCollapsibleViewHidden:YES];
  //set state of toggle collapse button
  [toggleCollapseButton setState:0];// disclosure triangle points to side
  
  [lineAboveRelatedView setHidden:YES];
  
  float constantWidth = collapsibleSubview.frame.size.width;
  
  [resizableSubview setFrameSize:NSMakeSize(constantWidth, self.frame.size.height - [self dividerThickness])];
  
  [collapsibleSubview setHidden:YES];

  [self adjustSubviews];

}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


-(void) uncollapse
{
  
  //NSLog(@"UNCOLLAPSE");
  
  [self setCollapsibleViewHidden:NO];

  [lineAboveRelatedView setHidden:NO];

  [toggleCollapseButton setState:1]; // disclosure triangle points down

  float constantWidth = collapsibleSubview.frame.size.width;
  
  [collapsibleSubview setFrameSize:NSMakeSize(constantWidth, self.uncollapsedSize)];
  [resizableSubview setFrameSize:NSMakeSize(constantWidth, (self.frame.size.height - self.uncollapsedSize - [self dividerThickness]))];

  [collapsibleSubview setHidden:NO];
  
  [self adjustSubviews];
}
 

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (CGFloat)dividerThickness {
  
  return [dividerThickness floatValue];
}


@end
