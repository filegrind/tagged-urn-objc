//
//  CSCapMatcher.h
//  Cap Matching Logic
//
//  Provides utilities for finding the best cap match from a collection
//  based on specificity and compatibility rules.
//

#import <Foundation/Foundation.h>
#import "CSTaggedUrn.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Utility class for cap matching operations
 */
@interface CSCapMatcher : NSObject

/**
 * Find the most specific cap that can handle a request
 * @param caps Array of available caps
 * @param request The requested cap
 * @return The best matching cap or nil if none can handle the request
 */
+ (nullable CSTaggedUrn *)findBestMatchInCaps:(NSArray<CSTaggedUrn *> * _Nonnull)caps 
                                              forRequest:(CSTaggedUrn * _Nonnull)request;

/**
 * Find all caps that can handle a request
 * @param caps Array of available caps
 * @param request The requested cap
 * @return Array of caps that can handle the request, sorted by specificity (most specific first)
 */
+ (NSArray<CSTaggedUrn *> * _Nonnull)findAllMatchesInCaps:(NSArray<CSTaggedUrn *> * _Nonnull)caps 
                                                  forRequest:(CSTaggedUrn * _Nonnull)request;

/**
 * Sort caps by specificity
 * @param caps Array of caps to sort
 * @return Array sorted by specificity (most specific first)
 */
+ (NSArray<CSTaggedUrn *> * _Nonnull)sortCapsBySpecificity:(NSArray<CSTaggedUrn *> * _Nonnull)caps;

/**
 * Check if a cap can handle a request with additional context
 * @param cap The cap to check
 * @param request The requested cap
 * @param context Additional context for matching (optional)
 * @return YES if the cap can handle the request
 */
+ (BOOL)cap:(CSTaggedUrn * _Nonnull)cap 
    canHandleRequest:(CSTaggedUrn * _Nonnull)request 
         withContext:(nullable NSDictionary<NSString *, id> *)context;

@end

NS_ASSUME_NONNULL_END