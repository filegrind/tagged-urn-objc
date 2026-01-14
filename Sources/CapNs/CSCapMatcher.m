//
//  CSCapMatcher.m
//  URN Matching Implementation
//

#import "CSCapMatcher.h"

@implementation CSCapMatcher

+ (nullable CSTaggedUrn *)findBestMatchInUrns:(NSArray<CSTaggedUrn *> *)urns
                                   forRequest:(CSTaggedUrn *)request
                                        error:(NSError **)error {
    NSArray<CSTaggedUrn *> *matches = [self findAllMatchesInUrns:urns forRequest:request error:error];
    if (!matches) {
        return nil;
    }
    return matches.firstObject;
}

+ (nullable NSArray<CSTaggedUrn *> *)findAllMatchesInUrns:(NSArray<CSTaggedUrn *> *)urns
                                               forRequest:(CSTaggedUrn *)request
                                                    error:(NSError **)error {
    NSMutableArray<CSTaggedUrn *> *matches = [NSMutableArray array];

    for (CSTaggedUrn *urn in urns) {
        NSError *matchError = nil;
        if ([urn canHandle:request error:&matchError]) {
            [matches addObject:urn];
        } else if (matchError) {
            // Prefix mismatch error - propagate it
            if (error) {
                *error = matchError;
            }
            return nil;
        }
    }

    return [self sortUrnsBySpecificity:matches];
}

+ (NSArray<CSTaggedUrn *> *)sortUrnsBySpecificity:(NSArray<CSTaggedUrn *> *)urns {
    return [urns sortedArrayUsingComparator:^NSComparisonResult(CSTaggedUrn *urn1, CSTaggedUrn *urn2) {
        // Sort by specificity first (higher specificity first)
        NSUInteger spec1 = [urn1 specificity];
        NSUInteger spec2 = [urn2 specificity];

        if (spec1 != spec2) {
            return spec1 > spec2 ? NSOrderedAscending : NSOrderedDescending;
        }

        // If same specificity, sort by tag count (more tags first)
        NSUInteger count1 = urn1.tags.count;
        NSUInteger count2 = urn2.tags.count;

        if (count1 != count2) {
            return count1 > count2 ? NSOrderedAscending : NSOrderedDescending;
        }

        // If same tag count, sort alphabetically for deterministic ordering
        return [[urn1 toString] compare:[urn2 toString]];
    }];
}

+ (BOOL)urn:(CSTaggedUrn *)urn
    canHandleRequest:(CSTaggedUrn *)request
         withContext:(nullable NSDictionary<NSString *, id> *)context
               error:(NSError **)error {
    // Basic URN matching
    if (![urn canHandle:request error:error]) {
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
