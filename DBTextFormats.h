//
//  DBTextFormats.h
//  NoteTaker
//
//  Created by Dante on 8/29/13.
//
//

#import <Foundation/Foundation.h>

@interface DBTextFormats : NSObject 


//@property (strong) NSDictionary * menuTextAttributes;
//@property (strong) NSDictionary * plainTextAttributes;
//@property (strong) NSDictionary * globalHyperlinkAttributes;
//@property (strong) NSDictionary * localHyperlinkAttributes;
//@property (strong) NSDictionary * modelHyperlinkAttributes;

- (NSDictionary *) menuTextAttributes;
- (NSDictionary *) plainTextAttributes;
- (NSDictionary *) globalHyperlinkAttributes;
- (NSDictionary *) localHyperlinkAttributes;
- (NSDictionary *) modelHyperlinkAttributes;

@end
