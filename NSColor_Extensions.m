/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "NSColor_Extensions.h"
//---------------------------------------------


@implementation NSColor (DBExtensions)


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// gets stored color data from user preferences
+ (NSColor *)colorForKey:(NSString *)key
{
  NSData  *data;
  NSColor *color;
  
  data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
  color= [NSUnarchiver unarchiveObjectWithData:data];
  
  if( ! [color isKindOfClass:[NSColor class]] ) {
    
    color = nil;
    
  }
  
  return color;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// stores color data as user preference
- (void)setColor:(NSColor *)color forKey:(NSString *)key
{
  
  NSData *data = [NSArchiver archivedDataWithRootObject:color];
  [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//  Use this method to draw 1 px wide lines independent of scale factor. Handy for resolution independent drawing. Still needs some work - there are issues with drawing at the edges of views.
- (void)bwDrawPixelThickLineAtPosition:(int)posInPixels withInset:(int)insetInPixels inRect:(NSRect)aRect inView:(NSView *)view horizontal:(BOOL)isHorizontal flip:(BOOL)shouldFlip
{
	// Convert the given rectangle from points to pixels
	aRect = [view convertRectToBacking:aRect];
	
	// Round up the rect's values to integers
	aRect = NSIntegralRect(aRect);
	
	// Add or subtract 0.5 so the lines are drawn within pixel bounds
	if (isHorizontal)
	{
		if ([view isFlipped])
			aRect.origin.y -= 0.5;
		else
			aRect.origin.y += 0.5;
	}
	else
	{
		aRect.origin.x += 0.5;
	}
	
	NSSize sizeInPixels = aRect.size;
	
	// Convert the rect back to points for drawing
	aRect = [view convertRectFromBacking:aRect];
	
	// Flip the position so it's at the other side of the rect
	if (shouldFlip)
	{
		if (isHorizontal)
			posInPixels = sizeInPixels.height - posInPixels - 1;
		else
			posInPixels = sizeInPixels.width - posInPixels - 1;
	}
	
	float posInPoints = posInPixels / [[NSScreen mainScreen] backingScaleFactor];
	float insetInPoints = insetInPixels / [[NSScreen mainScreen] backingScaleFactor];
	
	// Calculate line start and end points
	float startX, startY, endX, endY;
	
	if (isHorizontal)
	{
		startX = aRect.origin.x + insetInPoints;
		startY = aRect.origin.y + posInPoints;
		endX   = aRect.origin.x + aRect.size.width - insetInPoints;
		endY   = aRect.origin.y + posInPoints;
	}
	else
	{
		startX = aRect.origin.x + posInPoints;
		startY = aRect.origin.y + insetInPoints;
		endX   = aRect.origin.x + posInPoints;
		endY   = aRect.origin.y + aRect.size.height - insetInPoints;
	}
	
	// Draw line
	NSBezierPath *path = [NSBezierPath bezierPath];
	[path setLineWidth:0.0f];
	[path moveToPoint:NSMakePoint(startX,startY)];
	[path lineToPoint:NSMakePoint(endX,endY)];
	[self set];
	[path stroke];
}

@end
