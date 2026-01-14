//
//  CSCapMatcher.m
//  Cap Matching Implementation
//

#import "CSCapMatcher.h"

@implementation CSCapMatcher

+ (nullable CSTaggedUrn *)findBestMatchInCaps:(NSArray<CSTaggedUrn *> *)caps 
                                              forRequest:(CSTaggedUrn *)request {
    NSArray<CSTaggedUrn *> *matches = [self findAllMatchesInCaps:caps forRequest:request];
    return matches.firstObject;
}

+ (NSArray<CSTaggedUrn *> *)findAllMatchesInCaps:(NSArray<CSTaggedUrn *> *)caps 
                                                  forRequest:(CSTaggedUrn *)request {
    NSMutableArray<CSTaggedUrn *> *matches = [NSMutableArray array];
    
    for (CSTaggedUrn *cap in caps) {
        if ([cap canHandle:request]) {
            [matches addObject:cap];
        }
    }
    
    return [self sortCapsBySpecificity:matches];
}

+ (NSArray<CSTaggedUrn *> *)sortCapsBySpecificity:(NSArray<CSTaggedUrn *> *)caps {
    return [caps sortedArrayUsingComparator:^NSComparisonResult(CSTaggedUrn *cap1, CSTaggedUrn *cap2) {
        // Sort by specificity first (higher specificity first)
        NSUInteger spec1 = [cap1 specificity];
        NSUInteger spec2 = [cap2 specificity];
        
        if (spec1 != spec2) {
            return spec1 > spec2 ? NSOrderedAscending : NSOrderedDescending;
        }
        
        // If same specificity, sort by tag count (more tags first)
        NSUInteger count1 = cap1.tags.count;
        NSUInteger count2 = cap2.tags.count;
        
        if (count1 != count2) {
            return count1 > count2 ? NSOrderedAscending : NSOrderedDescending;
        }
        
        // If same tag count, sort alphabetically for deterministic ordering
        return [[cap1 toString] compare:[cap2 toString]];
    }];
}

+ (BOOL)cap:(CSTaggedUrn *)cap 
    canHandleRequest:(CSTaggedUrn *)request 
         withContext:(nullable NSDictionary<NSString *, id> *)context {
    // Basic cap matching
    if (![cap canHandle:request]) {
        return NO;
    }
    
    // If no context provided, basic matching is sufficient
    if (!context) {
        return YES;
    }
    
    // Context-based filtering could be implemented here
    // For example, checking file type compatibility, version requirements, etc.
    // This is extensible for future use cases
    
    return YES;
}

@end