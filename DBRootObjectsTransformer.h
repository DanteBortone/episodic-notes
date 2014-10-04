//
//  DBRootObjectsTransformer.h
//  NoteTaker
//
//  Created by Dante on 6/28/13.
//
//

#import <Foundation/Foundation.h>

// this keeps us from need to set up an array controller to get parent == nil items or needing a fetch predicate to get parent == nil items that have the correct topic

@interface DBRootObjectsTransformer : NSValueTransformer


@end
