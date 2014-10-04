//
//  NSButton.m
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 8/12/12.
//  Copyright 2012 UNC-Chapel Hill. All rights reserved.
//


//---------------------------------------------
#import "NSButton_Extensions.h"
//---------------------------------------------


@implementation NSButton (DBExtensions)



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSColor *)textColor
{
  NSAttributedString *attrTitle = [self attributedTitle];
  int len = (int)[attrTitle length];
  NSRange range = NSMakeRange(0, MIN(len, 1)); // take color from first char
  NSDictionary *attrs = [attrTitle fontAttributesInRange:range];
  NSColor *textColor = [NSColor controlTextColor];
  if (attrs) {
    textColor = [attrs objectForKey:NSForegroundColorAttributeName];
  }
  return textColor;
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)setTextColor:(NSColor *)textColor
{
  NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc]
                                          initWithAttributedString:[self attributedTitle]];

  //NSLog(@"attributedTitle: %@", [self attributedTitle]);
  int len = (int)[attrTitle length];
  NSRange range = NSMakeRange(0, len);
  [attrTitle addAttribute:NSForegroundColorAttributeName
                    value:textColor
                    range:range];
  [attrTitle fixAttributesInRange:range];
  [self setAttributedTitle:attrTitle];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)makeTextBold
{ 
  NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc]
                                          initWithAttributedString:[self attributedTitle]];
  int len = (int)[attrTitle length];
  NSRange range = NSMakeRange(0, len);
  [attrTitle addAttribute:NSFontAttributeName
                    value:[NSFont boldSystemFontOfSize:[[self font] pointSize]]
                    range:range];
  [attrTitle fixAttributesInRange:range];
  [self setAttributedTitle:attrTitle];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)unmakeTextBold
{
  //NSLog(@"unmake text bold");
  NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc]
                                          initWithAttributedString:[self attributedTitle]];
  int len = (int)[attrTitle length];
  NSRange range = NSMakeRange(0, len);
  [attrTitle addAttribute:NSFontAttributeName
                    value:[NSFont systemFontOfSize:[[self font] pointSize]]
                    range:range];
  [attrTitle fixAttributesInRange:range];
  [self setAttributedTitle:attrTitle];
}

@end
