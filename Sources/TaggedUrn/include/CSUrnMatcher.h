//
//  CSUrnMatcher.h
//  URN Matching Logic
//
//  Provides utilities for finding the best URN match from a collection
//  based on specificity and compatibility rules.
//

#import <Foundation/Foundation.h>
#import "CSTaggedUrn.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Utility class for URN matching operations
 */
@interface CSUrnMatcher : NSObject

/**
 * Find the most specific URN that can handle a request
 *
 * IMPORTANT: All URNs must have the same prefix as the request.
 *
 * @param urns Array of available URNs
 * @param request The requested URN
 * @param error Error if prefixes don't match
 * @return The best matching URN or nil if none can handle the request
 */
+ (nullable CSTaggedUrn *)findBestMatchInUrns:(NSArray<CSTaggedUrn *> * _Nonnull)urns
                                   forRequest:(CSTaggedUrn * _Nonnull)request
                                        error:(NSError * _Nullable * _Nullable)error;

/**
 * Find all URNs that can handle a request
 *
 * IMPORTANT: All URNs must have the same prefix as the request.
 *
 * @param urns Array of available URNs
 * @param request The requested URN
 * @param error Error if prefixes don't match
 * @return Array of URNs that can handle the request, sorted by specificity (most specific first)
 */
+ (nullable NSArray<CSTaggedUrn *> *)findAllMatchesInUrns:(NSArray<CSTaggedUrn *> * _Nonnull)urns
                                               forRequest:(CSTaggedUrn * _Nonnull)request
                                                    error:(NSError * _Nullable * _Nullable)error;

/**
 * Sort URNs by specificity
 * @param urns Array of URNs to sort
 * @return Array sorted by specificity (most specific first)
 */
+ (NSArray<CSTaggedUrn *> * _Nonnull)sortUrnsBySpecificity:(NSArray<CSTaggedUrn *> * _Nonnull)urns;

/**
 * Check if a URN conforms to a request with additional context
 *
 * IMPORTANT: Both URNs must have the same prefix.
 *
 * @param urn The URN to check (instance)
 * @param request The requested URN (pattern)
 * @param context Additional context for matching (optional)
 * @param error Error if prefixes don't match
 * @return YES if the URN conforms to the request
 */
+ (BOOL)urn:(CSTaggedUrn * _Nonnull)urn
    conformsToRequest:(CSTaggedUrn * _Nonnull)request
          withContext:(nullable NSDictionary<NSString *, id> *)context
                error:(NSError * _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
