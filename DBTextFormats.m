//
//  DBTextFormats.m
//  NoteTaker
//
//  Created by Dante on 8/29/13.
//
//


//---------------------------------------------
#import "DBTextFormats.h"
//---------------------------------------------


@implementation DBTextFormats

// -------------------------------------------------------------------------------

// init

// -------------------------------------------------------------------------------

// initialized by appDelegate as textFormatter
- (id)init
{
  self = [super init];
  if (self) {
    
  }
  
  return self;
}


// -------------------------------------------------------------------------------

// menuTextAttributes

// -------------------------------------------------------------------------------

- (NSDictionary *)menuTextAttributes
{
  
  return [[NSDictionary alloc]initWithObjectsAndKeys:
          [NSFont systemFontOfSize:14.0], NSFontAttributeName,
          nil];
  
}

// -------------------------------------------------------------------------------

// plainTextAttributes

// -------------------------------------------------------------------------------

- (NSDictionary *)   plainTextAttributes{
  
  NSMutableParagraphStyle * myStyle = [[NSMutableParagraphStyle alloc] init];
  [myStyle setLineSpacing:-1.0];
  
  return [[NSDictionary alloc]initWithObjectsAndKeys:
            [NSFont systemFontOfSize:11.0], NSFontAttributeName,
            myStyle, NSParagraphStyleAttributeName,
            nil];
  
}

// -------------------------------------------------------------------------------

// localHyperlinkAttributes

// -------------------------------------------------------------------------------

- (NSDictionary *) localHyperlinkAttributes{
  
  NSColor *  localHyperlinkColor = [NSColor colorWithCalibratedRed:(float)210/255 green:(float)69/255 blue:(float)0/255 alpha:1.0];
  
  return [[NSDictionary alloc]initWithObjectsAndKeys:
          self.textShadow, NSShadowAttributeName,
          localHyperlinkColor,NSForegroundColorAttributeName,
          [NSCursor pointingHandCursor], NSCursorAttributeName,
          [NSNumber numberWithInt:NSSingleUnderlineStyle], NSUnderlineStyleAttributeName,
          nil];
  
}

// -------------------------------------------------------------------------------

// globalHyperlinkAttributes

// -------------------------------------------------------------------------------

-(NSDictionary *)   globalHyperlinkAttributes{
  
  return [[NSDictionary alloc]initWithObjectsAndKeys:
          self.textShadow, NSShadowAttributeName,
          [NSCursor pointingHandCursor], NSCursorAttributeName,
          [NSColor blueColor],NSForegroundColorAttributeName,
          [NSNumber numberWithInt:NSSingleUnderlineStyle], NSUnderlineStyleAttributeName,
          nil];
  
}


// -------------------------------------------------------------------------------

// modelHyperlinkAttributes

// -------------------------------------------------------------------------------

-(NSDictionary *)   modelHyperlinkAttributes{
  
  return [[NSDictionary alloc]initWithObjectsAndKeys:
          self.textShadow, NSShadowAttributeName,
          [NSCursor pointingHandCursor], NSCursorAttributeName,
          [NSColor blueColor],NSForegroundColorAttributeName,
          [NSNumber numberWithInt:NSSingleUnderlineStyle], NSUnderlineStyleAttributeName,
          @"model", @"wikiWordURL",
          nil];

}

// -------------------------------------------------------------------------------

// textShadow

// -------------------------------------------------------------------------------


-(NSShadow *) textShadow{
  
  NSShadow *shadow = [[NSShadow alloc] init];
  [shadow setShadowColor:[NSColor whiteColor]];
  [shadow setShadowBlurRadius:3];
  [shadow setShadowOffset:NSMakeSize(2, -1)];
  
  return shadow;
  
}


@end
