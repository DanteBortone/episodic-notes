/*
     File: DBFileSystemNode.m
 Abstract: An abstract wrapper node around the file system.
  Version: 1.2
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2012 Apple Inc. All Rights Reserved.
 
 */

//---------------------------------------------
#import "DBFileSystemNode.h"
//---------------------------------------------
#import "NSURL_Extensions.h"


@implementation DBFileSystemNode

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (id)initWithURL:(NSURL *)url {
    if (self = [super init]) {
      
      //NSLog(@"initWithURL: %@",[url path]);
      _originalURL = url;  // to keep shortcut arrow and title of shortcut
      _url = url;

      
      //if([url isAlias]) {
        
        //_url = [url getAliasTargetURL]; //path will route to the original file path
        
      //} else {
        
        //_url = url;

      //}
      
    }
    return self;
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - %@", super.description, _url];
}

@synthesize URL = _url;
@synthesize originalURL = _originalURL;

@dynamic displayName, children, isDirectory, icon, labelColor;

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSString *)displayName {
    id value = nil;
    NSError *error;
    if ([_originalURL getResourceValue:&value forKey:NSURLLocalizedNameKey error:&error]) {
        return value; // hack work around the crash
    } else {
        return [error localizedDescription];
    }
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSImage *)icon {
    return [[NSWorkspace sharedWorkspace] iconForFile:[_originalURL path]];
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)isDirectory {
    id value = nil;
    [_url getResourceValue:&value forKey:NSURLIsDirectoryKey error:nil];
    return [value boolValue];
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)isPackage {
  id value = nil;
  [_url getResourceValue:&value forKey:NSURLIsPackageKey error:nil];
  return [value boolValue];
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSColor *)labelColor {
    id value = nil;
    [_url getResourceValue:&value forKey:NSURLLabelColorKey error:nil];
    return value;
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// We are equal if we represent the same URL. This allows children to reuse the same instances.

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[DBFileSystemNode class]]) {
        DBFileSystemNode *other = (DBFileSystemNode *)object;
        return [other.URL isEqual:self.URL];
    } else {
        return NO;
    }
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSUInteger)hash {
    return self.URL.hash;
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSArray *)children {
  if (_children == nil || _childrenDirty) {      
    
    NSMutableDictionary *newChildren = [NSMutableDictionary new];
    
    // if a package then return null for children
    
    //NSString *parentPath = [_url path];
    
    NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
    

    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSDirectoryEnumerator *fileEnumerator = [fileManager
                                         enumeratorAtURL:_url
                                         includingPropertiesForKeys:keys
                                         options:NSDirectoryEnumerationSkipsSubdirectoryDescendants|NSDirectoryEnumerationSkipsPackageDescendants| NSDirectoryEnumerationSkipsHiddenFiles
                                         errorHandler:^(NSURL *url, NSError *error) {
                                           // Handle the error.
                                           // Return YES if the enumeration should continue after the error.
                                           return YES;
                                         }];

    if (fileEnumerator) {

      NSString * filename;

        for (NSURL *fileURL in fileEnumerator) {
          //NSLog(@"fileURL: %@", [fileURL path]);
          //if([fileURL isAlias]) {
            
            //filename = [[fileURL getAliasTargetURL] path];

          //} else {
          filename = [fileURL path];
          //}

          if (fileURL != nil) {
            // minor bug: won't allow two nodes with same path (eg 'file' and 'file alias' in browser, even though they are both enumerated.
            DBFileSystemNode *node = [[DBFileSystemNode alloc] initWithURL:fileURL];
            [newChildren setObject:node forKey:filename];

          }
        }
    }
    
    _childrenDirty = NO;
    
    _children = [[newChildren allValues] sortedArrayUsingComparator:^(id obj1, id obj2) {
      NSString *objName = [obj1 displayName];
      NSString *obj2Name = [obj2 displayName];
      NSComparisonResult result = [objName compare:obj2Name options:NSNumericSearch | NSCaseInsensitiveSearch | NSWidthInsensitiveSearch | NSForcedOrderingSearch range:NSMakeRange(0, [objName length]) locale:[NSLocale currentLocale]];
      return result;
    }];

  }

  return _children;
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)invalidateChildren {
    _childrenDirty = YES;
    for (DBFileSystemNode *child in _children) {
        [child invalidateChildren];
    }
}

@end
