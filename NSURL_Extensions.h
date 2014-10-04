//
//  NSURL_Extensions.h
//  NoteTaker
//
//  Created by Dante on 7/21/13.
//
//

#import <Foundation/Foundation.h>

@interface NSURL (DBExtensions)


- (NSURL *) getAliasTargetURL; //can't do outside of sandbox with entitlements
- (BOOL) isAlias;

@end
