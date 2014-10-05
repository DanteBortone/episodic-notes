//
//  BWSplitView.m
//  BWToolkit
//
//  Created by Brandon Walkin (www.brandonwalkin.com) and Fraser Kuyvenhoven.
//  All code is provided under the New BSD license.
//


//---------------------------------------------
#import "BWSplitView.h"
//---------------------------------------------

#import "NSColor_Extensions.h"

//---------------------------------------------


static NSGradient *gradient;
static NSImage *dimpleImageBitmap, *dimpleImageVector;
static NSColor *borderColor, *gradientStartColor, *gradientEndColor;
static float scaleFactor = 1.0f;

#define RESIZE_DEBUG_LOGS 0


@interface BWSplitView (BWSVPrivate)

- (void)drawDimpleInRect:(NSRect)aRect;
- (void)drawGradientDividerInRect:(NSRect)aRect;
- (int)resizableSubviews;
- (BOOL)subviewIsResizable:(NSView *)subview;

- (BOOL)subviewIsCollapsible:(NSView *)subview;
- (BOOL)subviewIsCollapsed:(NSView *)subview;
- (int)collapsibleSubviewIndex;
- (NSView *)collapsibleSubview;
- (BOOL)hasCollapsibleSubview;
- (BOOL)collapsibleSubviewIsCollapsed;

- (CGFloat)subviewMinimumSize:(int)subviewIndex;
- (CGFloat)subviewMaximumSize:(int)subviewIndex;

- (void)recalculatePreferredProportionsAndSizes;
- (BOOL)validatePreferredProportionsAndSizes;
- (void)validateAndCalculatePreferredProportionsAndSizes;
- (void)clearPreferredProportionsAndSizes;

- (void)resizeAndAdjustSubviews;

@end

@implementation BWSplitView

@synthesize color, colorIsEnabled, minValues, maxValues, minUnits, maxUnits, collapsiblePopupSelection, dividerCanCollapse, collapsibleSubviewCollapsed;
@synthesize resizableSubviewPreferredProportion, nonresizableSubviewPreferredSize, stateForLastPreferredCalculations;
@synthesize toggleCollapseButton, secondaryDelegate;

@synthesize userUncollapseSize;


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

+ (void)initialize;
{
  borderColor        = [NSColor colorWithCalibratedWhite:(165.0f / 255.0f) alpha:1];
  gradientStartColor = [NSColor colorWithCalibratedWhite:(253.0f / 255.0f) alpha:1];
  gradientEndColor   = [NSColor colorWithCalibratedWhite:(222.0f / 255.0f) alpha:1];

  gradient           = [[NSGradient alloc] initWithStartingColor:gradientStartColor endingColor:gradientEndColor];

	NSBundle *bundle = [NSBundle bundleForClass:[BWSplitView class]];
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
       
    [minValues setDictionary: [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: minValue1, minValue2, nil]
                                            forKeys: [NSArray arrayWithObjects: [NSNumber numberWithInt:0],
                                                                                [NSNumber numberWithInt:1], nil]]];
    [minUnits setDictionary: [NSDictionary dictionaryWithObjects:
                 [NSArray arrayWithObjects: minUnit1, minUnit2, nil]
                                           forKeys: [NSArray arrayWithObjects:  [NSNumber numberWithInt:0],
                                                                                [NSNumber numberWithInt:1], nil]]];
    [maxValues setDictionary:[NSDictionary dictionaryWithObjects:
                 [NSArray arrayWithObjects: maxValue1, maxValue2, nil]
                                            forKeys: [NSArray arrayWithObjects: [NSNumber numberWithInt:0],
                                                                                [NSNumber numberWithInt:1], nil]]];
    [maxUnits setDictionary: [NSDictionary dictionaryWithObjects:
                [NSArray arrayWithObjects: maxUnit1, maxUnit2, nil]
                                           forKeys: [NSArray arrayWithObjects:  [NSNumber numberWithInt:0],
                                                                                [NSNumber numberWithInt:1], nil]]];
    collapsiblePopupSelection = setCollapsibleView;
    
    //setAutoresizesSubviews
    NSView *subview1 = [[self subviews] objectAtIndex:0];
    NSView *subview2 = [[self subviews] objectAtIndex:1];
    int resizeMask;
    
    if ([self isVertical]) {
        resizeMask = NSViewWidthSizable;
    } else {
        resizeMask = NSViewHeightSizable;
    }
    
    switch (preventResizingOfView) {
        case 1:
            [subview1 setAutoresizingMask:NSViewNotSizable];
            [subview2 setAutoresizingMask:resizeMask];
            break;
        case 2:
            [subview1 setAutoresizingMask:resizeMask];
            [subview2 setAutoresizingMask:NSViewNotSizable];
            break;
        default:
            [subview1 setAutoresizingMask:resizeMask];
            [subview2 setAutoresizingMask:resizeMask];
            break;
    }

  //needed to know when to coordinate with disclosure triangle settings on startup
/*  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  
  [nc addObserver:self
         selector:@selector(applicationDidFinishLaunching:)
             name:@"applicationDidFinishLaunching"
           object:nil ];
*/
  
  if (dividerThickness==NULL) {
    //NSLog(@"Divider thickness not specified");

    if ([self dividerStyle] == NSSplitViewDividerStyleThin ) {

      dividerThickness = [NSNumber numberWithFloat:0];

    } else {
      
      dividerThickness = [NSNumber numberWithFloat:10];

    }

  }
  
  
  if (userDefinedDimpleDimension == NULL){
    
    //NSLog(@"dimple dimension not specified");
    dimpleDimension = 2.5f;
    
  } else {
    
    dimpleDimension = [userDefinedDimpleDimension floatValue];
    
  }

}

// not usable now since views are made dynamically
//need to wait until application finishes launching so we can get correct values from the disclosure buttons and match them to the disclosure button
/*
- (void) applicationDidFinishLaunching:(NSNotification *) notification{

  //


  if (userDefaultUncollapseSizeKey){

    //NSLog(@"userDefaultUncollapseSizeKey: %@",userDefaultUncollapseSizeKey);
    uncollapsedSize = [[[NSUserDefaults standardUserDefaults] objectForKey:userDefaultUncollapseSizeKey] floatValue];
    
  } else {
    
    //NSLog(@"No userDefaultUncollapseSizeKey specified.  Setting restore size to min value.");
    NSNumber *minSize = [minValues objectForKey:[NSNumber numberWithInt:(int)[[self subviews] indexOfObject:[self collapsibleSubview]]]];
    uncollapsedSize = [minSize floatValue];
  
  }

  

  if ([toggleCollapseButton action]) {
    
    //hasAToggleCollapseButton = YES;
    
    if ([toggleCollapseButton state] == NSOnState ){
      
      [[self collapsibleSubview] setHidden:NO];
      [self setCollapsibleSubviewCollapsed:NO];
      
    } else if ([toggleCollapseButton state] == NSOffState ){

      NSLog(@"setting to collapible state");

      [self setCollapsibleSubviewCollapsed:YES];
      
    }
    
    
  } //else {
    
   //hasAToggleCollapseButton = NO;
  
  //}

  
}
*/


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)drawDividerInRect:(NSRect)aRect
{
///
 //   NSLog(@"value at index 0: %i", [[minValues valueForKey:@"1"] intValue]);
///
	if ([self dividerThickness] < 1.01)
	{
		if (colorIsEnabled && color != nil)
			[color drawSwatchInRect:aRect];
		else
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

- (void)setDelegate:(id)anObj
{
	if (secondaryDelegate != self)
		secondaryDelegate = anObj;
	else
		secondaryDelegate = nil;
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)subviewIsCollapsible:(NSView *)subview;
{
	// check if this is the collapsible subview
	int subviewIndex = (int)[[self subviews] indexOfObject:subview];
	
	BOOL isCollapsibleSubview = (([self collapsiblePopupSelection] == 1 && subviewIndex == 0) || ([self collapsiblePopupSelection] == 2 && subviewIndex == [[self subviews] count] - 1));
	
	return isCollapsibleSubview;
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)subviewIsCollapsed:(NSView *)subview;
{
	BOOL isCollapsibleSubview = [self subviewIsCollapsible:subview];
	
	return [super isSubviewCollapsed:subview] || (isCollapsibleSubview && collapsibleSubviewCollapsed);
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)collapsibleSubviewIsCollapsed;
{
	return [self subviewIsCollapsed:[self collapsibleSubview]];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (int)collapsibleSubviewIndex;
{
	switch ([self collapsiblePopupSelection]) {
		case 1:
			return 0;
			break;
		case 2:
			return (int)[[self subviews] count] - 1;
			break;
		default:
			return -1;
			break;
	}
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSView *)collapsibleSubview;
{
	int index = [self collapsibleSubviewIndex];
	
	if (index >= 0)
		return [[self subviews] objectAtIndex:index];
	else
		return nil;
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)hasCollapsibleSubview;
{
	if ([self respondsToSelector:@selector(ibDidAddToDesignableDocument:)])
		return NO;
	
	return [self collapsiblePopupSelection] != 0;
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// This is done to support the use of Core Animation to collapse subviews
- (void)adjustSubviews
{
	[super adjustSubviews];
	[[self window] invalidateCursorRectsForView:self];
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)setCollapsibleSubviewCollapsedHelper:(NSNumber *)flag
{
	[self setCollapsibleSubviewCollapsed:[flag boolValue]];
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)animationEnded
{
	isAnimating = NO;
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (float)animationDuration
{
	if ([[NSApp currentEvent] modifierFlags] & NSShiftKeyMask) //[NSEvent bwShiftKeyIsDown] removed to drop classes
		return 2.0;
	
	return 0.25;
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)hasCollapsibleDivider
{
	if ([self hasCollapsibleSubview] && (dividerCanCollapse || [self dividerThickness] < 1.01))
		return YES;
	
	return NO;
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (int)collapsibleDividerIndex
{
	if ([self hasCollapsibleDivider])
	{
		if ([self collapsiblePopupSelection] == 1)
			return 0;
		else if ([self collapsiblePopupSelection] == 2)
			return (int)[self subviews].count - 2;
	}
	
	return -1;
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)setCollapsibleSubviewCollapsed:(BOOL)flag
{
	collapsibleSubviewCollapsed = flag;

	if (flag)
		[[self toggleCollapseButton] setState:0];
	else
		[[self toggleCollapseButton] setState:1];	
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)setMinSizeForCollapsibleSubview:(NSNumber *)minSize
{
	if ([self hasCollapsibleSubview])
	{
		NSMutableDictionary *tempMinValues = [[self minValues] mutableCopy];
		[tempMinValues setObject:minSize forKey:[NSNumber numberWithInt:(int)[[self subviews] indexOfObject:[self collapsibleSubview]]]];
		[self setMinValues:tempMinValues];
	}
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)removeMinSizeForCollapsibleSubview
{
	if ([self hasCollapsibleSubview])
	{
		NSMutableDictionary *tempMinValues = [[self minValues] mutableCopy];
		[tempMinValues removeObjectForKey:[NSNumber numberWithInt:(int)[[self subviews] indexOfObject:[self collapsibleSubview]]]];
		[self setMinValues:tempMinValues];
	}
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)restoreAutoresizesSubviews:(NSNumber *)flag
{
	[[self collapsibleSubview] setAutoresizesSubviews:[flag boolValue]];
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)setHidden:(BOOL)flag{
    NSLog(@"setHidden");
    [super setHidden:flag];
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)toggleCollapse:(id)sender
{
 NSLog(@"BWSplitView:toggleCollapse");

	if ([self respondsToSelector:@selector(ibDidAddToDesignableDocument:)])
		return;
	
	if ([self hasCollapsibleSubview] == NO || [self collapsibleSubview] == nil)
		return; 
	
	if (isAnimating)
		return;
	
	
	// Check to see if the collapsible subview has a minimum width/height and record it.
	// We'll later remove the min size temporarily while animating and then restore it.
	BOOL hasMinSize = NO;
	NSNumber *minSize = [minValues objectForKey:[NSNumber numberWithInt:(int)[[self subviews] indexOfObject:[self collapsibleSubview]]]];
	minSize = [minSize copy];
	
	if (minSize != nil || [minSize intValue] != 0)
		hasMinSize = YES;
	
	
	// Get a reference to the button and modify its behavior
	if ([self toggleCollapseButton] == nil)
	{
		[self setToggleCollapseButton:sender];

		[[toggleCollapseButton cell] setHighlightsBy:NSPushInCellMask];
		[[toggleCollapseButton cell] setShowsStateBy:NSContentsCellMask];
        
	}
	
	
	// Temporary: For simplicty, there should only be 1 subview other than the collapsible subview that's resizable for the collapse to happen
	NSView *resizableSubview = nil;
	
	for (NSView *subview in [self subviews])
	{
		if ([self subviewIsResizable:subview] && subview != [self collapsibleSubview])
		{
			resizableSubview = subview;
		}
			
	}
	
	if (resizableSubview == nil)
		return;
	
	// Record whether the collapsible subview is set to autoresize subviews so we can restore it after the animation
	BOOL autoresizesSubviews = [[self collapsibleSubview] autoresizesSubviews];
	
	// Turn off autoresizesSubviews on the collapsible subview
	[[self collapsibleSubview] setAutoresizesSubviews:NO];
	
	// Get the thickness of the collapsible divider. If the divider cannot collapse, we set it to 0 so it doesn't affect our calculations.
	float collapsibleDividerThickness = [self dividerThickness];
	
	if ([self hasCollapsibleDivider] == NO)
		collapsibleDividerThickness = 0;
	
	// Collapsing by dragging the divider sets the view to be hidden, so unhide it
	[[self collapsibleSubview] setHidden:NO];
	
	if ([self isVertical])
	{
		float constantHeight = [self collapsibleSubview].frame.size.height;
		
		if ([self collapsibleSubviewCollapsed] == NO)//<---COLLAPSE CODE
		{
			uncollapsedSize = [self collapsibleSubview].frame.size.width;
      [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat: uncollapsedSize ] forKey:userDefaultUncollapseSizeKey];

			if (hasMinSize)
				[self removeMinSizeForCollapsibleSubview];
			
			[NSAnimationContext beginGrouping];
			[[NSAnimationContext currentContext] setDuration:([self animationDuration])];			
			[[[self collapsibleSubview] animator] setFrameSize:NSMakeSize(0.0, constantHeight)];
			[[resizableSubview animator] setFrameSize:NSMakeSize(resizableSubview.frame.size.width + uncollapsedSize + collapsibleDividerThickness, constantHeight)];
			[NSAnimationContext endGrouping];
			
			if (hasMinSize)
				[self performSelector:@selector(setMinSizeForCollapsibleSubview:) withObject:minSize afterDelay:[self animationDuration]];
			
			[self performSelector:@selector(setCollapsibleSubviewCollapsedHelper:) withObject:[NSNumber numberWithBool:YES] afterDelay:[self animationDuration]];
		}
		else //<---UNCOLLAPSE CODE
		{

			if (hasMinSize)
				[self removeMinSizeForCollapsibleSubview];
			
			[NSAnimationContext beginGrouping];
			[[NSAnimationContext currentContext] setDuration:([self animationDuration])];
			[[[self collapsibleSubview] animator] setFrameSize:NSMakeSize(uncollapsedSize, constantHeight)];
			[[resizableSubview animator] setFrameSize:NSMakeSize(resizableSubview.frame.size.width - uncollapsedSize - collapsibleDividerThickness, constantHeight)];
			[NSAnimationContext endGrouping];
	
			if (hasMinSize)
				[self performSelector:@selector(setMinSizeForCollapsibleSubview:) withObject:minSize afterDelay:[self animationDuration]];
			
			[self setCollapsibleSubviewCollapsed:NO];
		}
	}
	else
	{
		float constantWidth = [self collapsibleSubview].frame.size.width;
		
		if ([self collapsibleSubviewCollapsed] == NO)
		{
      //NSLog(@"COLLAPSE");

			uncollapsedSize = [self collapsibleSubview].frame.size.height;
      [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat: uncollapsedSize ] forKey:userDefaultUncollapseSizeKey];
			if (hasMinSize)
				[self removeMinSizeForCollapsibleSubview];
			
			[NSAnimationContext beginGrouping];
			[[NSAnimationContext currentContext] setDuration:([self animationDuration])];			
			[[[self collapsibleSubview] animator] setFrameSize:NSMakeSize(constantWidth, 0.0)];
			[[resizableSubview animator] setFrameSize:NSMakeSize(constantWidth, resizableSubview.frame.size.height + uncollapsedSize + collapsibleDividerThickness)];
			[NSAnimationContext endGrouping];
			
			if (hasMinSize)
				[self performSelector:@selector(setMinSizeForCollapsibleSubview:) withObject:minSize afterDelay:[self animationDuration]];
			
			[self performSelector:@selector(setCollapsibleSubviewCollapsedHelper:) withObject:[NSNumber numberWithBool:YES] afterDelay:[self animationDuration]];
		}
		else
		{
      //NSLog(@"UNCOLLAPSE");

			if (hasMinSize)
				[self removeMinSizeForCollapsibleSubview];
			
			[NSAnimationContext beginGrouping];
			[[NSAnimationContext currentContext] setDuration:([self animationDuration])];
			[[[self collapsibleSubview] animator] setFrameSize:NSMakeSize(constantWidth, uncollapsedSize)];
			[[resizableSubview animator] setFrameSize:NSMakeSize(constantWidth, resizableSubview.frame.size.height - uncollapsedSize - collapsibleDividerThickness)];
			[NSAnimationContext endGrouping];
			
			if (hasMinSize)
				[self performSelector:@selector(setMinSizeForCollapsibleSubview:) withObject:minSize afterDelay:[self animationDuration]];
			
			[self setCollapsibleSubviewCollapsed:NO];
		}
	}
	
	isAnimating = YES;
	[self performSelector:@selector(animationEnded) withObject:nil afterDelay:[self animationDuration]];
	[self performSelector:@selector(restoreAutoresizesSubviews:) withObject:[NSNumber numberWithBool:autoresizesSubviews] afterDelay:[self animationDuration]];
	
	[self performSelector:@selector(resizeAndAdjustSubviews) withObject:nil afterDelay:[self animationDuration]];
}

/*
- (IBAction) collapse:(id)sender {
    [self collapse];
  
  //NSLog(@"BWSplitView:collapse:");

    // Get a reference to the button and modify its behavior
	if ([self toggleCollapseButton] != nil)
	{
        [toggleCollapseButton setState:0];

		//[[toggleCollapseButton cell] setHighlightsBy:NSPushInCellMask];
		//[[toggleCollapseButton cell] setShowsStateBy:NSContentsCellMask];
	}
}
*/
/*
-(void) collapse
{

	if ([self respondsToSelector:@selector(ibDidAddToDesignableDocument:)])
		return;
	
	if ([self hasCollapsibleSubview] == NO || [self collapsibleSubview] == nil)
		return;
	
	if (isAnimating)
		return;
	
	
	// Check to see if the collapsible subview has a minimum width/height and record it.
	// We'll later remove the min size temporarily while animating and then restore it.
	BOOL hasMinSize = NO;
	NSNumber *minSize = [minValues objectForKey:[NSNumber numberWithInt:(int)[[self subviews] indexOfObject:[self collapsibleSubview]]]];
	minSize = [minSize copy];
	
	if (minSize != nil || [minSize intValue] != 0)
		hasMinSize = YES;
	
	// Temporary: For simplicty, there should only be 1 subview other than the collapsible subview that's resizable for the collapse to happen
	NSView *resizableSubview = nil;
	
	for (NSView *subview in [self subviews])
	{
		if ([self subviewIsResizable:subview] && subview != [self collapsibleSubview])
		{
			resizableSubview = subview;
		}
        
	}
	
	if (resizableSubview == nil)
		return;
	
	// Record whether the collapsible subview is set to autoresize subviews so we can restore it after the animation
	BOOL autoresizesSubviews = [[self collapsibleSubview] autoresizesSubviews];
	
	// Turn off autoresizesSubviews on the collapsible subview
	[[self collapsibleSubview] setAutoresizesSubviews:NO];
	
	// Get the thickness of the collapsible divider. If the divider cannot collapse, we set it to 0 so it doesn't affect our calculations.
	float collapsibleDividerThickness = [self dividerThickness];
	
	if ([self hasCollapsibleDivider] == NO)
		collapsibleDividerThickness = 0;
	
	// Collapsing by dragging the divider sets the view to be hidden, so unhide it
	[[self collapsibleSubview] setHidden:NO];
    if ([self collapsibleSubviewCollapsed] == NO)
    {
        if ([self isVertical])
        {
        
            float constantHeight = [self collapsibleSubview].frame.size.height;
            
            uncollapsedSize = [self collapsibleSubview].frame.size.width;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat: uncollapsedSize ] forKey:userDefaultUncollapseSizeKey];
          
            if (hasMinSize)
                [self removeMinSizeForCollapsibleSubview];
            
            [NSAnimationContext beginGrouping];
            [[NSAnimationContext currentContext] setDuration:([self animationDuration])];
            [[[self collapsibleSubview] animator] setFrameSize:NSMakeSize(0.0, constantHeight)];
            [[resizableSubview animator] setFrameSize:NSMakeSize(resizableSubview.frame.size.width + uncollapsedSize + collapsibleDividerThickness, constantHeight)];
            [NSAnimationContext endGrouping];
            
            if (hasMinSize)
                [self performSelector:@selector(setMinSizeForCollapsibleSubview:) withObject:minSize afterDelay:[self animationDuration]];
            
            [self performSelector:@selector(setCollapsibleSubviewCollapsedHelper:) withObject:[NSNumber numberWithBool:YES] afterDelay:[self animationDuration]];
        }
        else
        {
            float constantWidth = [self collapsibleSubview].frame.size.width;
            
            uncollapsedSize = [self collapsibleSubview].frame.size.height;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat: uncollapsedSize ] forKey:userDefaultUncollapseSizeKey];
            if (hasMinSize)
                [self removeMinSizeForCollapsibleSubview];
            
            [NSAnimationContext beginGrouping];
            [[NSAnimationContext currentContext] setDuration:([self animationDuration])];
            [[[self collapsibleSubview] animator] setFrameSize:NSMakeSize(constantWidth, 0.0)];
            [[resizableSubview animator] setFrameSize:NSMakeSize(constantWidth, resizableSubview.frame.size.height + uncollapsedSize + collapsibleDividerThickness)];
            [NSAnimationContext endGrouping];
            
            if (hasMinSize)
                [self performSelector:@selector(setMinSizeForCollapsibleSubview:) withObject:minSize afterDelay:[self animationDuration]];
            
            [self performSelector:@selector(setCollapsibleSubviewCollapsedHelper:) withObject:[NSNumber numberWithBool:YES] afterDelay:[self animationDuration]];
        }
	}
	
	isAnimating = YES;
	[self performSelector:@selector(animationEnded) withObject:nil afterDelay:[self animationDuration]];
	[self performSelector:@selector(restoreAutoresizesSubviews:) withObject:[NSNumber numberWithBool:autoresizesSubviews] afterDelay:[self animationDuration]];
	
	[self performSelector:@selector(resizeAndAdjustSubviews) withObject:nil afterDelay:[self animationDuration]];
}
*/


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction) undoCollapse:(id)sender {
    [self undoCollapse];

    // Get a reference to the button and modify its behavior
	if ([self toggleCollapseButton] != nil)
	{
        [toggleCollapseButton setState:1];
		//[[toggleCollapseButton cell] setHighlightsBy:NSPushInCellMask];
		//[[toggleCollapseButton cell] setShowsStateBy:NSContentsCellMask];
        
	}
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) undoCollapse{

  //NSLog(@"BWSplitView:undoCollapse");
  
	if ([self respondsToSelector:@selector(ibDidAddToDesignableDocument:)])
		return;
	
	if ([self hasCollapsibleSubview] == NO || [self collapsibleSubview] == nil)
		return;
	
	if (isAnimating)
		return;
	
	
	// Check to see if the collapsible subview has a minimum width/height and record it.
	// We'll later remove the min size temporarily while animating and then restore it.
	BOOL hasMinSize = NO;
	NSNumber *minSize = [minValues objectForKey:[NSNumber numberWithInt:(int)[[self subviews] indexOfObject:[self collapsibleSubview]]]];
	minSize = [minSize copy];
	
	if (minSize != nil || [minSize intValue] != 0)
		hasMinSize = YES;
	
	// Temporary: For simplicty, there should only be 1 subview other than the collapsible subview that's resizable for the collapse to happen
	NSView *resizableSubview = nil;
	
	for (NSView *subview in [self subviews])
	{
		if ([self subviewIsResizable:subview] && subview != [self collapsibleSubview])
		{
			resizableSubview = subview;
		}
        
	}
	
	if (resizableSubview == nil)
		return;
	
	// Record whether the collapsible subview is set to autoresize subviews so we can restore it after the animation
	BOOL autoresizesSubviews = [[self collapsibleSubview] autoresizesSubviews];
	
	// Turn off autoresizesSubviews on the collapsible subview
	[[self collapsibleSubview] setAutoresizesSubviews:NO];
	
	// Get the thickness of the collapsible divider. If the divider cannot collapse, we set it to 0 so it doesn't affect our calculations.
	float collapsibleDividerThickness = [self dividerThickness];
	
	if ([self hasCollapsibleDivider] == NO)
		collapsibleDividerThickness = 0;
	
	// Collapsing by dragging the divider sets the view to be hidden, so unhide it
	[[self collapsibleSubview] setHidden:NO];
    if ([self collapsibleSubviewCollapsed] == YES)        
    {
        if ([self isVertical])
        {
            float constantHeight = [self collapsibleSubview].frame.size.height;
            
            if (hasMinSize)
                [self removeMinSizeForCollapsibleSubview];
            
            [NSAnimationContext beginGrouping];
            [[NSAnimationContext currentContext] setDuration:([self animationDuration])];
            [[[self collapsibleSubview] animator] setFrameSize:NSMakeSize(uncollapsedSize, constantHeight)];
            [[resizableSubview animator] setFrameSize:NSMakeSize(resizableSubview.frame.size.width - uncollapsedSize - collapsibleDividerThickness, constantHeight)];
            [NSAnimationContext endGrouping];
            
            if (hasMinSize)
                [self performSelector:@selector(setMinSizeForCollapsibleSubview:) withObject:minSize afterDelay:[self animationDuration]];
            
            [self setCollapsibleSubviewCollapsed:NO];
            
        }
        else
        {
            float constantWidth = [self collapsibleSubview].frame.size.width;
            
            if (hasMinSize)
                [self removeMinSizeForCollapsibleSubview];
            
            [NSAnimationContext beginGrouping];
            [[NSAnimationContext currentContext] setDuration:([self animationDuration])];
            [[[self collapsibleSubview] animator] setFrameSize:NSMakeSize(constantWidth, uncollapsedSize)];
            [[resizableSubview animator] setFrameSize:NSMakeSize(constantWidth, resizableSubview.frame.size.height - uncollapsedSize - collapsibleDividerThickness)];
            [NSAnimationContext endGrouping];
            
            if (hasMinSize)
                [self performSelector:@selector(setMinSizeForCollapsibleSubview:) withObject:minSize afterDelay:[self animationDuration]];
            
            [self setCollapsibleSubviewCollapsed:NO];
		}
	}
	
	isAnimating = YES;
	[self performSelector:@selector(animationEnded) withObject:nil afterDelay:[self animationDuration]];
	[self performSelector:@selector(restoreAutoresizesSubviews:) withObject:[NSNumber numberWithBool:autoresizesSubviews] afterDelay:[self animationDuration]];
	
	[self performSelector:@selector(resizeAndAdjustSubviews) withObject:nil afterDelay:[self animationDuration]];
}

#pragma mark Mouse Tracking Methods

- (void)mouseDown:(NSEvent *)theEvent
{
	// Set the uncollapsed size whenever the split view is clicked or a drag has began. This lets us uncollapse to the size of the subview before the drag-collapse.
	if ([self hasCollapsibleSubview])
	{
		CGFloat collapsibleViewSize = [self isVertical] ?  [self collapsibleSubview].frame.size.width : [self collapsibleSubview].frame.size.height;
	
		if (!isAnimating && collapsibleViewSize > 0)
			uncollapsedSize = collapsibleViewSize;
      [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat: uncollapsedSize ] forKey:userDefaultUncollapseSizeKey];
	}

	[super mouseDown:theEvent];
}

#pragma mark NSSplitView Delegate Methods

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)splitView:(NSSplitView *)splitView shouldHideDividerAtIndex:(NSInteger)dividerIndex
{
/*	if ([secondaryDelegate respondsToSelector:@selector(splitView:shouldHideDividerAtIndex:)] &&
		[secondaryDelegate isKindOfClass:[BWAnchoredButtonBar class]] == NO)
		return [secondaryDelegate splitView:splitView shouldHideDividerAtIndex:dividerIndex];
*/
	if ([self respondsToSelector:@selector(ibDidAddToDesignableDocument:)] == NO)
	{
		if ([self hasCollapsibleDivider] && [self collapsibleDividerIndex] == dividerIndex)
		{
			[self setDividerCanCollapse:YES];
			return YES;
		}
	}

	return NO;
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSRect)splitView:(NSSplitView *)splitView additionalEffectiveRectOfDividerAtIndex:(NSInteger)dividerIndex
{
	if ([secondaryDelegate respondsToSelector:@selector(splitView:additionalEffectiveRectOfDividerAtIndex:)])
		return [secondaryDelegate splitView:splitView additionalEffectiveRectOfDividerAtIndex:dividerIndex];
	
	return NSZeroRect;
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)splitView:(NSSplitView *)sender canCollapseSubview:(NSView *)subview
{
    if (collapseByDrag) {
        
    /*	if ([secondaryDelegate respondsToSelector:@selector(splitView:canCollapseSubview:)] &&
            [secondaryDelegate isKindOfClass:[BWAnchoredButtonBar class]] == NO)
            return [secondaryDelegate splitView:sender canCollapseSubview:subview];
    */
        int subviewIndex = (int)[[self subviews] indexOfObject:subview];
        
        if ([self respondsToSelector:@selector(ibDidAddToDesignableDocument:)] == NO)
        {
            if ([self collapsiblePopupSelection] == 1 && subviewIndex == 0)
                return YES;
            else if ([self collapsiblePopupSelection] == 2 && subviewIndex == [[self subviews] count] - 1)
                return YES;
        }
	}
	return NO;
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)splitView:(NSSplitView *)splitView shouldCollapseSubview:(NSView *)subview forDoubleClickOnDividerAtIndex:(NSInteger)dividerIndex
{
    
    if (collapseByDividerClick) {
        
    /*	if ([secondaryDelegate respondsToSelector:@selector(splitView:shouldCollapseSubview:forDoubleClickOnDividerAtIndex:)] &&
            [secondaryDelegate isKindOfClass:[BWAnchoredButtonBar class]] == NO)
            return [secondaryDelegate splitView:splitView shouldCollapseSubview:subview forDoubleClickOnDividerAtIndex:dividerIndex];
    */
        //NSLog(@"divider double clicked");
        
        int subviewIndex = (int)[[self subviews] indexOfObject:subview];
        
        if ([self respondsToSelector:@selector(ibDidAddToDesignableDocument:)] == NO)
        {
            if (([self collapsiblePopupSelection] == 1 && subviewIndex == 0 && dividerIndex == 0) ||
                ([self collapsiblePopupSelection] == 2 && subviewIndex == [[self subviews] count] - 1 && dividerIndex == [[splitView subviews] count] - 2))
            {
              if ([self isVertical]){
                    uncollapsedSize = [self collapsibleSubview].frame.size.width;
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat: uncollapsedSize ] forKey:userDefaultUncollapseSizeKey];
              } else {
                    uncollapsedSize = [self collapsibleSubview].frame.size.height;
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat: uncollapsedSize ] forKey:userDefaultUncollapseSizeKey];
              }
                [self setCollapsibleSubviewCollapsed:YES];
                
                // Cause the collapse ourselves by calling the resize method
                [self resizeAndAdjustSubviews];
                [self setNeedsDisplay:YES];
                
                // Since we manually did the resize above, we pretend that we don't want to collapse
                return NO;
            }
        }
	}
	return NO;
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (CGFloat)splitView:(NSSplitView *)sender constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(NSInteger)offset
{
/*	if ([secondaryDelegate respondsToSelector:@selector(splitView:constrainMaxCoordinate:ofSubviewAt:)] &&
		[secondaryDelegate isKindOfClass:[BWAnchoredButtonBar class]] == NO)
		return [secondaryDelegate splitView:sender constrainMaxCoordinate:proposedMax ofSubviewAt:offset];
*/
	// Max coordinate depends on max of subview offset, and the min of subview offset + 1
	CGFloat newMaxFromThisSubview = proposedMax;
	CGFloat newMaxFromNextSubview = proposedMax;
	
	// Max from this subview
	CGFloat maxValue = [self subviewMaximumSize:(int)offset];
	if (maxValue != FLT_MAX)
	{
		NSView *subview = [[self subviews] objectAtIndex:offset];
		CGFloat originCoord = [self isVertical] ? [subview frame].origin.x : [subview frame].origin.y;
		
		newMaxFromThisSubview = originCoord + maxValue;
	}
	
	// Max from the next subview
	int nextOffset = (int)offset + 1;
	if ([[self subviews] count] > nextOffset)
	{
		CGFloat minValue = [self subviewMinimumSize:nextOffset];
		if (minValue != 0)
		{
			NSView *subview = [[self subviews] objectAtIndex:nextOffset];
			CGFloat endCoord = [self isVertical] ? [subview frame].origin.x + [subview frame].size.width : [subview frame].origin.y + [subview frame].size.height;
			
			newMaxFromNextSubview = endCoord - minValue - [self dividerThickness];
			// This could cause trouble when over constrained (TODO)
		}
	}
	
	CGFloat newMax = fminf(newMaxFromThisSubview, newMaxFromNextSubview);
	
	if (newMax < proposedMax)
		return newMax;
	
	return proposedMax;
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (CGFloat)splitView:(NSSplitView *)sender constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(NSInteger)offset
{
/*	if ([secondaryDelegate respondsToSelector:@selector(splitView:constrainMinCoordinate:ofSubviewAt:)] &&
		[secondaryDelegate isKindOfClass:[BWAnchoredButtonBar class]] == NO)
		return [secondaryDelegate splitView:sender constrainMinCoordinate:proposedMin ofSubviewAt:offset];
*/
	// Min coordinate depends on min of subview offset and the max of subview offset + 1
    
	CGFloat newMinFromThisSubview = proposedMin;
	CGFloat newMaxFromNextSubview = proposedMin;
	
	// Min from this subview
	CGFloat minValue = [self subviewMinimumSize:(int)offset];
	if (minValue != 0)
	{
		NSView *subview = [[self subviews] objectAtIndex:offset];
		CGFloat originCoord = [self isVertical] ? [subview frame].origin.x : [subview frame].origin.y;
		
		newMinFromThisSubview = originCoord + minValue;
	}
	
	// Min from the next subview
	int nextOffset = (int)offset+ 1;
	if ([[self subviews] count] > nextOffset)
	{
		CGFloat maxValue = [self subviewMaximumSize:nextOffset];
		if (maxValue != FLT_MAX)
		{
			NSView *subview = [[self subviews] objectAtIndex:nextOffset];
			CGFloat endCoord = [self isVertical] ? [subview frame].origin.x + [subview frame].size.width : [subview frame].origin.y + [subview frame].size.height;
			
			newMaxFromNextSubview = endCoord - maxValue - [self dividerThickness];
			// This could cause trouble when over constrained (TODO)
		}
	}
	
	CGFloat newMin = fmaxf(newMinFromThisSubview, newMaxFromNextSubview);
	
	if (newMin > proposedMin)
		return newMin;
	
	return proposedMin;
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (CGFloat)splitView:(NSSplitView *)sender constrainSplitPosition:(CGFloat)proposedPosition ofSubviewAt:(NSInteger)offset
{
	[self clearPreferredProportionsAndSizes];
	
	if ([self respondsToSelector:@selector(ibDidAddToDesignableDocument:)])
		return proposedPosition;	
	
/*	if ([secondaryDelegate respondsToSelector:@selector(splitView:constrainSplitPosition:ofSubviewAt:)] &&
		[secondaryDelegate isKindOfClass:[BWAnchoredButtonBar class]] == NO)
		return [secondaryDelegate splitView:sender constrainSplitPosition:proposedPosition ofSubviewAt:offset];
*/
	return proposedPosition;
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSRect)splitView:(NSSplitView *)splitView effectiveRect:(NSRect)proposedEffectiveRect forDrawnRect:(NSRect)drawnRect ofDividerAtIndex:(NSInteger)dividerIndex
{
	if ([secondaryDelegate respondsToSelector:@selector(splitView:effectiveRect:forDrawnRect:ofDividerAtIndex:)])
		return [secondaryDelegate splitView:splitView effectiveRect:proposedEffectiveRect forDrawnRect:drawnRect ofDividerAtIndex:dividerIndex];
	
	return proposedEffectiveRect;
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)splitViewDidResizeSubviews:(NSNotification *)aNotification
{
  
    if (collapseByDrag) {
        
        //for when dragged open
        if (collapsibleSubviewCollapsed && ([self isVertical] ? [[self collapsibleSubview] frame].size.width > 0 : [[self collapsibleSubview] frame].size.height > 0))
        {
            [self setCollapsibleSubviewCollapsed:NO];

            [self resizeAndAdjustSubviews];
        }
        
        //triggered for first time used on splitviews?
        //and for closing
        else if (!collapsibleSubviewCollapsed && ([self isVertical] ? [[self collapsibleSubview] frame].size.width < 0.1 : [[self collapsibleSubview] frame].size.height < 0.1))
        {

            [self setCollapsibleSubviewCollapsed:YES];
            
           // [self resizeAndAdjustSubviews];
        }
        //for when shut and stays shut
        else if ([self collapsibleSubviewIsCollapsed])  
        {

            [self resizeAndAdjustSubviews];
        }
        
        [self setNeedsDisplay:YES];
        
        if ([secondaryDelegate respondsToSelector:@selector(splitViewDidResizeSubviews:)])
            [secondaryDelegate splitViewDidResizeSubviews:aNotification];
    }

  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)splitViewWillResizeSubviews:(NSNotification *)aNotification
{
	if ([secondaryDelegate respondsToSelector:@selector(splitViewWillResizeSubviews:)])
		[secondaryDelegate splitViewWillResizeSubviews:aNotification];
}

#pragma mark - Resize Subviews Delegate Method and Helper Methods

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (int)resizableSubviews
{
	int resizableSubviews = 0;
	
	for (NSView *subview in [self subviews])
	{
		if ([self subviewIsResizable:subview])
			resizableSubviews++;
	}
	
	return resizableSubviews;
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)subviewIsResizable:(NSView *)subview
{
	if ([self isVertical] && [subview autoresizingMask] & NSViewWidthSizable)
		return YES;
	
	if (![self isVertical] && [subview autoresizingMask] & NSViewHeightSizable)
		return YES;
	
	return NO;
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (CGFloat)subviewMinimumSize:(int)subviewIndex;
{
	NSNumber *minNum = [minValues objectForKey:[NSNumber numberWithInt:subviewIndex]];
    //NSLog(@"subviewIndex %i minNum is %i", subviewIndex, [minNum intValue]);
	if (!minNum)
		return 0;
	
	int units = 0;
	NSNumber *unitsNum = [minUnits objectForKey:[NSNumber numberWithInt:subviewIndex]];
	if (unitsNum)
		units = [unitsNum intValue];
	
	CGFloat min = [minNum floatValue];
	
	switch (units)
	{
		case 1:
		{
			// Percent
			CGFloat dividerThicknessTotal = [self dividerThickness] * ([[self subviews] count] - 1);
			CGFloat totalSize = [self isVertical] ? [self frame].size.width : [self frame].size.height;
			totalSize -= dividerThicknessTotal;
			
			return roundf((min / 100.0) * totalSize);
			break;
		}
		case 0:
		default:
		{
			// Points
			return min;
			break;
		}
	}
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (CGFloat)subviewMaximumSize:(int)subviewIndex;
{
	NSNumber *maxNum = [maxValues objectForKey:[NSNumber numberWithInt:subviewIndex]];
	if (!maxNum)
		return FLT_MAX;
	
	int units = 0;
	NSNumber *unitsNum = [maxUnits objectForKey:[NSNumber numberWithInt:subviewIndex]];
	if (unitsNum)
		units = [unitsNum intValue];
	
	CGFloat max = [maxNum floatValue];
	
	switch (units)
	{
		case 1:
		{
			// Percent
			CGFloat dividerThicknessTotal = [self dividerThickness] * ([[self subviews] count] - 1);
			CGFloat totalSize = [self isVertical] ? [self frame].size.width : [self frame].size.height;
			totalSize -= dividerThicknessTotal;
			
			return roundf((max / 100.0) * totalSize);
			break;
		}
		case 0:
		default:
		{
			// Points
			return max;
			break;
		}
	}
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// PREFERRED PROPORTIONS AND SIZES
//
// Preferred proportions (for resizable)
// Need to store resizable subviews preferred proportions for calculating new sizes
//
// Preferred sizes (for non-resizable)
// If a non-resizable subview is ever forced larger or smaller than it prefers, we need to know it's preferred size
//
// Need to recalculate both of the above whenever a divider is moved, or a subview is added/removed or changed between resizable/non-resizable

- (void)recalculatePreferredProportionsAndSizes;
{
	NSMutableArray *stateArray = [NSMutableArray arrayWithCapacity:[[self subviews] count]];
	
	NSMutableDictionary *preferredProportions = [NSMutableDictionary dictionary];
	NSMutableDictionary *preferredSizes = [NSMutableDictionary dictionary];
	
	// Total is only the sum of resizable subviews
	CGFloat resizableTotal = 0;
	
	// Calculate resizable total
	for (NSView *subview in [self subviews])
	{
		if ([self subviewIsResizable:subview])
			resizableTotal += [self isVertical] ? [subview frame].size.width : [subview frame].size.height;
	}
	
	// Calculate resizable preferred propotions and set non-resizable preferred sizes
	for (NSView *subview in [self subviews])
	{
		int index = (int)[[self subviews] indexOfObject:subview];
		
		if ([self subviewIsResizable:subview])
		{
			CGFloat size = [self isVertical] ? [subview frame].size.width : [subview frame].size.height;
			CGFloat proportion = (resizableTotal > 0) ? (size / resizableTotal) : 0;
			
			[preferredProportions setObject:[NSNumber numberWithFloat:proportion]
									 forKey:[NSNumber numberWithInt:index]];
			
			[stateArray addObject:[NSNumber numberWithBool:YES]];
		}
		else
		{
			CGFloat size = [self isVertical] ? [subview frame].size.width : [subview frame].size.height;
			
			[preferredSizes setObject:[NSNumber numberWithFloat:size]
							   forKey:[NSNumber numberWithInt:index]];
			
			[stateArray addObject:[NSNumber numberWithBool:NO]];
		}
	}
	
	[self setResizableSubviewPreferredProportion:preferredProportions];
	[self setNonresizableSubviewPreferredSize:preferredSizes];
	
	if (RESIZE_DEBUG_LOGS) NSLog(@"resizableSubviewPreferredProportion: %@", resizableSubviewPreferredProportion);
	if (RESIZE_DEBUG_LOGS) NSLog(@"nonresizableSubviewPreferredSize: %@", nonresizableSubviewPreferredSize);
	
	// Remember state to know when to recalculate	
	[self setStateForLastPreferredCalculations:stateArray];
	if (RESIZE_DEBUG_LOGS) NSLog(@"stateForLastPreferredCalculations: %@", stateForLastPreferredCalculations);
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// Checks if the number or type of subviews has changed since we last recalculated
- (BOOL)validatePreferredProportionsAndSizes;
{
	if (RESIZE_DEBUG_LOGS) NSLog(@"validating preferred proportions and sizes");
	
	// Check if we even have saved proportions and sizes
	if (![self resizableSubviewPreferredProportion] || ![self nonresizableSubviewPreferredSize])
		return NO;
	
	// Check if number of items has changed
	if ([[self subviews] count] != [[self stateForLastPreferredCalculations] count])
		return NO;
	
	// Check if any of the subviews have changed between resizable and non-resizable
	for (NSView *subview in [self subviews])
	{
		int index = (int)[[self subviews] indexOfObject:subview];
		
		if ([self subviewIsResizable:subview] != [[[self stateForLastPreferredCalculations] objectAtIndex:index] boolValue])
			return NO;
	}
	
	return YES;
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)correctCollapsiblePreferredProportionOrSize;
{
	// TODO: Assuming that the collapsible subview does not change between resizable and non-resizable while collapsed
	
	if (![self hasCollapsibleSubview])
		return;
	
	NSMutableDictionary *preferredProportions = [[self resizableSubviewPreferredProportion] mutableCopy];
	NSMutableDictionary *preferredSizes = [[self nonresizableSubviewPreferredSize] mutableCopy];
	
	NSNumber *key = [NSNumber numberWithInt:[self collapsibleSubviewIndex]];
	NSView *subview = [self collapsibleSubview];
	
	// If the collapsible subview is collapsed, we put aside its preferred propotion/size
	if ([self subviewIsCollapsed:subview])
	{
		BOOL resizable = [self subviewIsResizable:subview];
		
		if (!resizable)
		{
			NSNumber *sizeNum = [preferredSizes objectForKey:key];
			if (sizeNum)
			{
				if (RESIZE_DEBUG_LOGS) NSLog(@"removing collapsible view from preferred sizes");
				
				// TODO: Save the size for later
				
				// Remove from preferred sizes
				[preferredSizes removeObjectForKey:key];
			}
		}
		else
		{
			NSNumber *proportionNum = [preferredProportions objectForKey:key];
			if (proportionNum)
			{
				if (RESIZE_DEBUG_LOGS) NSLog(@"removing collapsible view from preferred proportions");
				
				CGFloat proportion = [proportionNum floatValue];
				
				// TODO: Save the proportion for later
				
				// Remove from preferred proportions
				[preferredProportions removeObjectForKey:key];
				
				// Recalculate other proportions
				CGFloat proportionTotal = 1.0 - proportion;
				if (proportionTotal > 0)
				{
					for (NSNumber *pkey in [preferredProportions allKeys])
					{
						CGFloat oldProportion = [[preferredProportions objectForKey:pkey] floatValue];
						CGFloat newPropotion = oldProportion / proportionTotal;
						
						[preferredProportions setObject:[NSNumber numberWithFloat:newPropotion] forKey:pkey];
					}
				}
			}
		}
		
		[self setResizableSubviewPreferredProportion:preferredProportions];
		[self setNonresizableSubviewPreferredSize:preferredSizes];
	}
	else // Otherwise, we reintegrate its preferred proportion/size
	{
		[self clearPreferredProportionsAndSizes];
		[self recalculatePreferredProportionsAndSizes];
	}
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)validateAndCalculatePreferredProportionsAndSizes;
{
	if (![self validatePreferredProportionsAndSizes])
		[self recalculatePreferredProportionsAndSizes];		
	
	// Need to make sure the collapsed subviews preferred size/proportion is in the right place
	[self correctCollapsiblePreferredProportionOrSize];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)clearPreferredProportionsAndSizes;
{
	if (RESIZE_DEBUG_LOGS) NSLog(@"clearing preferred proportions and sizes");
	
	[self setResizableSubviewPreferredProportion:nil];
	[self setNonresizableSubviewPreferredSize:nil];
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// RESIZING ALGORITHM

// non-resizable subviews are given preferred size
// overall remaining size is calculated
// resizable subviews are calculated based on remaining size and preferred proportions
// resizable subviews are checked for min/max constraint violations
//    if violating constraint, set to valid size and remove from resizable subviews
//    recalculate other resizable subviews and repeat
// if all resizable subviews reached constraints without meeting target size, need to resize non-resizable views
// non-resizable subviews are adjusted proportionally to meet target size
// non-resizable subviews are checked for min/max constraint violations
//    if violating constraint, set to valid size and remove from non-resizable subviews
//    recalculate other non-resizable subviews and repeat
// if all subviews reached constraints without meeting target size, need to adjust all views to fit
// proportionally resize all subviews to fit in target size, ignoring min/max constraints

- (void)resizeAndAdjustSubviews;
{
	// Temporary: for now, we will just remember the proportions the first time subviews are resized
	// we should be remember them in the user defaults so they save across quits (TODO)
	
	[self validateAndCalculatePreferredProportionsAndSizes];
	
	if (RESIZE_DEBUG_LOGS) NSLog(@"resizeSubviews begins -----------------------------------------------------");
	
	NSMutableDictionary *newSubviewSizes = [NSMutableDictionary dictionaryWithCapacity:[[self subviews] count]];
	
	// Get new total size
	CGFloat totalAvailableSize = [self isVertical] ? [self frame].size.width : [self frame].size.height;
	if (RESIZE_DEBUG_LOGS) NSLog(@"totalAvailableSize: %f", totalAvailableSize);
	
	// Calculate non-resizable subviews total
	CGFloat nonresizableSubviewsTotalPreferredSize = 0;
	for (NSNumber *size in [nonresizableSubviewPreferredSize allValues])
		nonresizableSubviewsTotalPreferredSize += [size floatValue];
	if (RESIZE_DEBUG_LOGS) NSLog(@"nonresizableSubviewsTotalPreferredSize: %f", nonresizableSubviewsTotalPreferredSize);
	
	// Calculate divider thickness total
	int dividerCount = (int)[[self subviews] count] - 1;
	if ([self collapsibleSubviewIsCollapsed] && dividerCanCollapse) dividerCount--;
	CGFloat dividerThicknessTotal = [self dividerThickness] * dividerCount;		
	if (RESIZE_DEBUG_LOGS) NSLog(@"dividerThicknessTotal: %f", dividerThicknessTotal);
	
	// Calculate overall remaining size (could be negative)
	CGFloat resizableSubviewsTotalAvailableSize = totalAvailableSize - nonresizableSubviewsTotalPreferredSize - dividerThicknessTotal;
	if (RESIZE_DEBUG_LOGS) NSLog(@"resizableSubviewsTotalAvailableSize: %f", resizableSubviewsTotalAvailableSize);
	
	// Special case for the collapsible subview
	if ([self collapsibleSubviewIsCollapsed])
	{
		[newSubviewSizes setObject:[NSNumber numberWithFloat:0.0]
							forKey:[NSNumber numberWithInt:[self collapsibleSubviewIndex]]];
	}
	
	// Set non-resizable subviews to preferred size
	[newSubviewSizes addEntriesFromDictionary:nonresizableSubviewPreferredSize];
	
	// Set sizes of resizable views based on proportions (could be negative)
	CGFloat resizableSubviewAvailableSizeUsed = 0;
	int resizableSubviewCounter = 0;
	int resizableSubviewCount = (int)[resizableSubviewPreferredProportion count];
	for (NSNumber *key in [resizableSubviewPreferredProportion allKeys])
	{
		resizableSubviewCounter++;
		
		CGFloat proportion = [[resizableSubviewPreferredProportion objectForKey:key] floatValue];
		CGFloat size = roundf(proportion * resizableSubviewsTotalAvailableSize);
		resizableSubviewAvailableSizeUsed += size;
		
		if (resizableSubviewCounter == resizableSubviewCount)
		{
			// Make adjustment if necessary
			size += (resizableSubviewsTotalAvailableSize - resizableSubviewAvailableSizeUsed);
		}
		
		[newSubviewSizes setObject:[NSNumber numberWithFloat:size] forKey:key];
	}
	if (RESIZE_DEBUG_LOGS) NSLog(@"newSubviewSizes after resizable proportional resizing: %@", newSubviewSizes);
	
	// TODO: Could add a special case for resizableSubviewsTotalAvailableSize <= 0 : just set all resizable subviews to minimum size 
	
	// Make array of all the resizable subviews indexes
	NSMutableArray *resizableSubviewIndexes = [[resizableSubviewPreferredProportion allKeys] mutableCopy];
	[resizableSubviewIndexes sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES]]];
	
	// Loop until none of the resizable subviews' constraints are violated
	CGFloat proportionTotal = 1;
	CGFloat resizableSubviewsRemainingAvailableSize = resizableSubviewsTotalAvailableSize;
	int i;
	for (i = 0; i < [resizableSubviewIndexes count]; i++)
	{
		NSNumber *key = [resizableSubviewIndexes objectAtIndex:i];
		CGFloat size = [[newSubviewSizes objectForKey:key] floatValue];
		CGFloat minSize = [self subviewMinimumSize:[key intValue]];
		CGFloat maxSize = [self subviewMaximumSize:[key intValue]];
		
		BOOL overMax = size > maxSize;
		BOOL underMin = size < minSize;
		
		// Check if current item in array violates constraints
		if (underMin || overMax)
		{
			CGFloat constrainedSize = underMin ? minSize : maxSize;
			
			if (RESIZE_DEBUG_LOGS) NSLog(@"resizable subview %@ was %@, set to %f", key, (underMin ? @"under min" : @"over max"), constrainedSize);
			
			// Give subview constrained size and remove from array
			[newSubviewSizes setObject:[NSNumber numberWithFloat:constrainedSize] forKey:key];
			[resizableSubviewIndexes removeObject:key];
			
			// Adjust total proportion and remaining available size
			proportionTotal -= [[resizableSubviewPreferredProportion objectForKey:key] floatValue];
			resizableSubviewsRemainingAvailableSize -= underMin ? minSize : maxSize;
			
			// Recalculate remaining subview sizes
			CGFloat resizableSubviewRemainingSizeUsed = 0;
			int j;
			for (j = 0; j < [resizableSubviewIndexes count]; j++)
			{
				NSNumber *jKey = [resizableSubviewIndexes objectAtIndex:j];
				
				CGFloat proportion = 0;
				if (proportionTotal > 0)
					proportion = [[resizableSubviewPreferredProportion objectForKey:jKey] floatValue] / proportionTotal;
				else
					proportion = 1.0 / [resizableSubviewIndexes count];
				
				CGFloat size = roundf(proportion * resizableSubviewsRemainingAvailableSize);
				resizableSubviewRemainingSizeUsed += size;
				
				if (j == [resizableSubviewIndexes count] - 1)
				{
					// Make adjustment if necessary
					size += (resizableSubviewsRemainingAvailableSize - resizableSubviewRemainingSizeUsed);
				}
				
				[newSubviewSizes setObject:[NSNumber numberWithFloat:size] forKey:jKey];
				
				// Reset outer loop to start from beginning
				i = -1;
			}
		}
	}
	if (RESIZE_DEBUG_LOGS) NSLog(@"newSubviewSizes after resizable constraint fulfilling: %@", newSubviewSizes);		
	
	if ([resizableSubviewIndexes count] == 0 && resizableSubviewsRemainingAvailableSize != 0)
	{
		if (RESIZE_DEBUG_LOGS) NSLog(@"entering nonresizable adjustment stage");
		
		// All resizable subviews have reached constraints without reaching the target size
		
		// First try to adjust non-resizable subviews, with resizableSubviewsRemainingAvailableSize being the amount of adjustment needed
		
		// Make array of non-resizable preferred proportions (normally go by preferred sizes)
		NSMutableDictionary *nonresizableSubviewPreferredProportion = [NSMutableDictionary dictionary];
		for (NSNumber *key in [nonresizableSubviewPreferredSize allKeys])
		{
			CGFloat proportion = [[nonresizableSubviewPreferredSize objectForKey:key] floatValue] / nonresizableSubviewsTotalPreferredSize;
			
			[nonresizableSubviewPreferredProportion setObject:[NSNumber numberWithFloat:proportion] forKey:key];
		}
		
		// ResizableSubviewsRemainingAvailableSize is the amount of adjustment needed
		CGFloat nonresizableSubviewsRemainingAvailableSize = nonresizableSubviewsTotalPreferredSize + resizableSubviewsRemainingAvailableSize;
		
		// Set sizes of nonresizable views based on proportions (could be negative)
		CGFloat nonresizableSubviewAvailableSizeUsed = 0;
		int nonresizableSubviewCounter = 0;
		int nonresizableSubviewCount = (int)[nonresizableSubviewPreferredProportion count];
		for (NSNumber *key in [nonresizableSubviewPreferredProportion allKeys])
		{
			nonresizableSubviewCounter++;
			
			CGFloat proportion = [[nonresizableSubviewPreferredProportion objectForKey:key] floatValue];
			CGFloat size = roundf(proportion * nonresizableSubviewsRemainingAvailableSize);
			nonresizableSubviewAvailableSizeUsed += size;
			
			if (nonresizableSubviewCounter == nonresizableSubviewCount)
			{
				// Make adjustment if necessary
				size += (nonresizableSubviewsRemainingAvailableSize - nonresizableSubviewAvailableSizeUsed);
			}
			
			[newSubviewSizes setObject:[NSNumber numberWithFloat:size] forKey:key];
		}
		if (RESIZE_DEBUG_LOGS) NSLog(@"newSubviewSizes after nonresizable proportional resizing: %@", newSubviewSizes);
		
		// Make array of all the non-resizable subviews indexes
		NSMutableArray *nonresizableSubviewIndexes = [[nonresizableSubviewPreferredSize allKeys] mutableCopy];
		[nonresizableSubviewIndexes sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES]]];
		
		// Loop until none of the non-resizable subviews' constraints are violated
		CGFloat proportionTotal = 1;
		int i;
		for (i = 0; i < [nonresizableSubviewIndexes count]; i++)
		{
			NSNumber *key = [nonresizableSubviewIndexes objectAtIndex:i];
			CGFloat size = [[newSubviewSizes objectForKey:key] floatValue];
			CGFloat minSize = [self subviewMinimumSize:[key intValue]];
			CGFloat maxSize = [self subviewMaximumSize:[key intValue]];
			
			BOOL overMax = size > maxSize;
			BOOL underMin = size < minSize;
			
			// Check if current item in array violates constraints
			if (underMin || overMax)
			{
				CGFloat constrainedSize = underMin ? minSize : maxSize;
				
				if (RESIZE_DEBUG_LOGS) NSLog(@"nonresizable subview %@ was %@, set to %f", key, (underMin ? @"under min" : @"over max"), constrainedSize);
				
				// Give subview constrained size and remove from array
				[newSubviewSizes setObject:[NSNumber numberWithFloat:constrainedSize] forKey:key];
				[nonresizableSubviewIndexes removeObject:key];
				
				// Adjust total proportion and remaining available size
				proportionTotal -= [[nonresizableSubviewPreferredProportion objectForKey:key] floatValue];
				nonresizableSubviewsRemainingAvailableSize -= underMin ? minSize : maxSize;
				
				// Recalculate remaining subview sizes
				CGFloat nonresizableSubviewRemainingSizeUsed = 0;
				int j;
				for (j = 0; j < [nonresizableSubviewIndexes count]; j++)
				{
					NSNumber *jKey = [nonresizableSubviewIndexes objectAtIndex:j];
					
					CGFloat proportion = 0;
					if (proportionTotal > 0)
						proportion = [[nonresizableSubviewPreferredProportion objectForKey:jKey] floatValue] / proportionTotal;
					else
						proportion = 1.0 / [nonresizableSubviewIndexes count];
					
					CGFloat size = roundf(proportion * nonresizableSubviewsRemainingAvailableSize);
					nonresizableSubviewRemainingSizeUsed += size;
					
					if (j == [nonresizableSubviewIndexes count] - 1)
					{
						// Make adjustment if necessary
						size += (nonresizableSubviewsRemainingAvailableSize - nonresizableSubviewRemainingSizeUsed);
					}
					
					[newSubviewSizes setObject:[NSNumber numberWithFloat:size] forKey:jKey];
					
					// Reset outer loop to start from beginning
					i = -1;
				}
			}
		}
		if (RESIZE_DEBUG_LOGS) NSLog(@"newSubviewSizes after nonresizable constraint fulfilling: %@", newSubviewSizes);
		
		// If there is still overall violation, resize everything proportionally to make up the difference
		
		if ([resizableSubviewIndexes count] == 0 && nonresizableSubviewsRemainingAvailableSize != 0)
		{
			if (RESIZE_DEBUG_LOGS) NSLog(@"entering all subviews forced adjustment stage");
			
			// Calculate current proportions and use to calculate new size
			
			CGFloat allSubviewTotalCurrentSize = 0;
			for (NSNumber *size in [newSubviewSizes allValues])
				allSubviewTotalCurrentSize += [size floatValue];
			
			CGFloat allSubviewRemainingSizeUsed = 0;
			CGFloat allSubviewTotalSize = totalAvailableSize - dividerThicknessTotal;
			// TODO: What to do if even the dividers don't fit?				
			
			int k;
			for (k = 0; k < [newSubviewSizes count]; k++)
			{
				NSNumber *key = [NSNumber numberWithInt:k];
				
				CGFloat currentSize = [[newSubviewSizes objectForKey:key] floatValue];
				
				CGFloat proportion = currentSize / allSubviewTotalCurrentSize;
				CGFloat size = roundf(proportion * allSubviewTotalSize);
				allSubviewRemainingSizeUsed += size;
				
				if (k == [newSubviewSizes count] - 1)
				{
					// Make adjustment if necessary
					size += allSubviewTotalSize - allSubviewRemainingSizeUsed;
				}
				
				[newSubviewSizes setObject:[NSNumber numberWithFloat:size] forKey:key];	
			}
			if (RESIZE_DEBUG_LOGS) NSLog(@"newSubviewSizes after all subviews forced adjustment: %@", newSubviewSizes);
		}
		
		// Otherwise there is still flexibiliy in the non-resizable views, so we are done
	}
	
	// Otherwise there is still flexibility in the resizable views, so we are done
	
	// Set subview frames
	CGFloat position = 0;
	for (i = 0; i < [[self subviews] count]; i++)
	{
		NSView *subview = [[self subviews] objectAtIndex:i];
		CGFloat size = [[newSubviewSizes objectForKey:[NSNumber numberWithInt:i]] floatValue];
		
		NSRect subviewFrame = NSZeroRect;
		
		if ([self isVertical])
		{
			subviewFrame.size.height = [self frame].size.height;
			subviewFrame.size.width = size;
			subviewFrame.origin.y = [subview frame].origin.y;
			subviewFrame.origin.x = position;
		}
		else
		{
			subviewFrame.size.height = size;
			subviewFrame.size.width =  [self frame].size.width;
			subviewFrame.origin.y = position;
			subviewFrame.origin.x =  [subview frame].origin.x;
		}
		
		[subview setFrame:subviewFrame];
		
		position += size;
		
		if (dividerCanCollapse && [self subviewIsCollapsed:subview])
		{
			// Do nothing
		}
		else
		{
			position += [self dividerThickness];
		}
	}
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)splitView:(NSSplitView *)sender resizeSubviewsWithOldSize:(NSSize)oldSize
{	
/*	if ([secondaryDelegate isKindOfClass:[BWAnchoredButtonBar class]])
	{
		[self resizeAndAdjustSubviews];
	}
	else */if ([secondaryDelegate respondsToSelector:@selector(splitView:resizeSubviewsWithOldSize:)])
	{
		[secondaryDelegate splitView:sender resizeSubviewsWithOldSize:oldSize];
	}
	else if (sender == self)
	{
		[self resizeAndAdjustSubviews];
	}
	else
	{
		[sender adjustSubviews];
	}
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)setDividerStyle:(NSSplitViewDividerStyle)aStyle
{
	[super setDividerStyle:aStyle];
	
	// There can be sizing issues during design-time if we don't call this
	[self adjustSubviews];
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (CGFloat)dividerThickness {
  
  return [dividerThickness floatValue];
}

@end
