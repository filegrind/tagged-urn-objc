//
//  CSTaggedUrn.h
//  Flat Tag-Based Cap Identifier System
//
//  This provides a flat, tag-based tagged URN system that replaces
//  hierarchical naming with key-value tags to handle cross-cutting concerns and
//  multi-dimensional cap classification.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * A tagged URN using flat, ordered tags
 *
 * Examples:
 * - cap:op=generate;ext=pdf;output=binary;target=thumbnail
 * - cap:op=extract;target=metadata
 * - cap:op=analysis;format=en;type=constrained
 */
@interface CSTaggedUrn : NSObject <NSCopying, NSSecureCoding>

/// The tags that define this cap
@property (nonatomic, readonly) NSDictionary<NSString *, NSString *> *tags;

/**
 * Create a tagged URN from a string
 * @param string The tagged URN string (e.g., "cap:op=generate")
 * @param error Error if the string format is invalid
 * @return A new CSTaggedUrn instance or nil if invalid
 */
+ (nullable instancetype)fromString:(NSString * _Nonnull)string error:(NSError * _Nullable * _Nullable)error;

/**
 * Create a tagged URN from tags
 * @param tags Dictionary of tag key-value pairs
 * @param error Error if tags are invalid
 * @return A new CSTaggedUrn instance or nil if invalid
 */
+ (nullable instancetype)fromTags:(NSDictionary<NSString *, NSString *> * _Nonnull)tags error:(NSError * _Nullable * _Nullable)error;

/**
 * Get the value of a specific tag
 * @param key The tag key
 * @return The tag value or nil if not found
 */
- (nullable NSString *)getTag:(NSString * _Nonnull)key;

/**
 * Check if this cap has a specific tag with a specific value
 * @param key The tag key
 * @param value The tag value to check
 * @return YES if the tag exists with the specified value
 */
- (BOOL)hasTag:(NSString * _Nonnull)key withValue:(NSString * _Nonnull)value;

/**
 * Create a new tagged URN with an added or updated tag
 * @param key The tag key
 * @param value The tag value
 * @return A new CSTaggedUrn instance with the tag added/updated
 */
- (CSTaggedUrn * _Nonnull)withTag:(NSString * _Nonnull)key value:(NSString * _Nonnull)value;

/**
 * Create a new tagged URN with a tag removed
 * @param key The tag key to remove
 * @return A new CSTaggedUrn instance with the tag removed
 */
- (CSTaggedUrn * _Nonnull)withoutTag:(NSString * _Nonnull)key;

/**
 * Check if this cap matches another based on tag compatibility
 * @param pattern The pattern cap to match against
 * @return YES if this cap matches the pattern
 */
- (BOOL)matches:(CSTaggedUrn * _Nonnull)pattern;

/**
 * Check if this cap can handle a request
 * @param request The requested cap
 * @return YES if this cap can handle the request
 */
- (BOOL)canHandle:(CSTaggedUrn * _Nonnull)request;

/**
 * Get the specificity score for cap matching
 * @return The number of non-wildcard tags
 */
- (NSUInteger)specificity;

/**
 * Check if this cap is more specific than another
 * @param other The other cap to compare specificity with
 * @return YES if this cap is more specific
 */
- (BOOL)isMoreSpecificThan:(CSTaggedUrn * _Nonnull)other;

/**
 * Check if this cap is compatible with another
 * @param other The other cap to check compatibility with
 * @return YES if the caps are compatible
 */
- (BOOL)isCompatibleWith:(CSTaggedUrn * _Nonnull)other;

/**
 * Create a new cap with a specific tag set to wildcard
 * @param key The tag key to set to wildcard
 * @return A new CSTaggedUrn instance with the tag set to wildcard
 */
- (CSTaggedUrn * _Nonnull)withWildcardTag:(NSString * _Nonnull)key;

/**
 * Create a new cap with only specified tags
 * @param keys Array of tag keys to include
 * @return A new CSTaggedUrn instance with only the specified tags
 */
- (CSTaggedUrn * _Nonnull)subset:(NSArray<NSString *> * _Nonnull)keys;

/**
 * Merge with another cap (other takes precedence for conflicts)
 * @param other The cap to merge with
 * @return A new CSTaggedUrn instance with merged tags
 */
- (CSTaggedUrn * _Nonnull)merge:(CSTaggedUrn * _Nonnull)other;

/**
 * Get the canonical string representation of this cap
 * @return The tagged URN as a string
 */
- (NSString *)toString;


@end

/// Error domain for tagged URN errors
FOUNDATION_EXPORT NSErrorDomain const CSTaggedUrnErrorDomain;

/// Error codes for tagged URN operations
typedef NS_ERROR_ENUM(CSTaggedUrnErrorDomain, CSTaggedUrnError) {
    CSTaggedUrnErrorInvalidFormat = 1,
    CSTaggedUrnErrorEmptyTag = 2,
    CSTaggedUrnErrorInvalidCharacter = 3,
    CSTaggedUrnErrorInvalidTagFormat = 4,
    CSTaggedUrnErrorMissingCapPrefix = 5,
    CSTaggedUrnErrorDuplicateKey = 6,
    CSTaggedUrnErrorNumericKey = 7,
    CSTaggedUrnErrorUnterminatedQuote = 8,
    CSTaggedUrnErrorInvalidEscapeSequence = 9
};

/**
 * Builder for creating tagged URNs fluently
 */
@interface CSTaggedUrnBuilder : NSObject

/**
 * Create a new builder
 * @return A new CSTaggedUrnBuilder instance
 */
+ (instancetype)builder;

/**
 * Add or update a tag
 * @param key The tag key
 * @param value The tag value
 * @return This builder instance for chaining
 */
- (CSTaggedUrnBuilder * _Nonnull)tag:(NSString * _Nonnull)key value:(NSString * _Nonnull)value;

/**
 * Build the final TaggedUrn
 * @param error Error if build fails
 * @return A new CSTaggedUrn instance or nil if error
 */
- (nullable CSTaggedUrn *)build:(NSError * _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END