//
//  NSTextView_Extensions.m
//  NoteTaker
//
//  Created by Dante on 10/8/13.
//
//


//---------------------------------------------
#import "NSMutableAttributedString_Extensions.h"
//---------------------------------------------

@implementation NSMutableAttributedString (DBExtensions)


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)changeFontSize:(CGFloat)size;
{
  NSFontManager * fontManager = [NSFontManager sharedFontManager];

  [self enumerateAttribute:NSFontAttributeName
                          inRange:NSMakeRange(0, [self length])
                          options:0
                       usingBlock:^(id value,
                                    NSRange range,
                                    BOOL * stop)
   {
     NSFont * font = value;
     font = [fontManager convertFont:font
                              toSize:size];
     if (font != nil) {
       [self removeAttribute:NSFontAttributeName
                              range:range];
       [self addAttribute:NSFontAttributeName
                           value:font
                           range:range];
     }
   }];

}


@end
