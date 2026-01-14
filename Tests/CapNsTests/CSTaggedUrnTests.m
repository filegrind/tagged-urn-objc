//
//  CSTaggedUrnTests.m
//  Tests for CSTaggedUrn tag-based system
//
//  NOTE: The `action` tag has been replaced with `op` in the new format.
//

#import <XCTest/XCTest.h>
#import "CapNs.h"

@interface CSTaggedUrnTests : XCTestCase
@end

@implementation CSTaggedUrnTests

- (void)testTaggedUrnCreation {
    NSError *error;
    CSTaggedUrn *taggedUrn = [CSTaggedUrn fromString:@"cap:op=transform;format=json;type=data_processing" error:&error];

    XCTAssertNotNil(taggedUrn);
    XCTAssertNil(error);

    XCTAssertEqualObjects([taggedUrn getTag:@"type"], @"data_processing");
    XCTAssertEqualObjects([taggedUrn getTag:@"op"], @"transform");
    XCTAssertEqualObjects([taggedUrn getTag:@"format"], @"json");
}

- (void)testCanonicalStringFormat {
    NSError *error;
    CSTaggedUrn *taggedUrn = [CSTaggedUrn fromString:@"cap:op=generate;target=thumbnail;ext=pdf" error:&error];

    XCTAssertNotNil(taggedUrn);
    XCTAssertNil(error);

    // Should be sorted alphabetically: ext, op, target
    XCTAssertEqualObjects([taggedUrn toString], @"cap:ext=pdf;op=generate;target=thumbnail");
}

- (void)testCapPrefixRequired {
    NSError *error;
    // Missing cap: prefix should fail
    CSTaggedUrn *taggedUrn = [CSTaggedUrn fromString:@"op=generate;ext=pdf" error:&error];
    XCTAssertNil(taggedUrn);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, CSTaggedUrnErrorMissingCapPrefix);

    // Valid cap: prefix should work
    error = nil;
    taggedUrn = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    XCTAssertNotNil(taggedUrn);
    XCTAssertNil(error);
    XCTAssertEqualObjects([taggedUrn getTag:@"op"], @"generate");
}

- (void)testTrailingSemicolonEquivalence {
    NSError *error;
    // Both with and without trailing semicolon should be equivalent
    CSTaggedUrn *cap1 = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    XCTAssertNotNil(cap1);

    CSTaggedUrn *cap2 = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf;" error:&error];
    XCTAssertNotNil(cap2);

    // They should be equal
    XCTAssertEqualObjects(cap1, cap2);

    // They should have same hash
    XCTAssertEqual([cap1 hash], [cap2 hash]);

    // They should have same string representation (canonical form)
    XCTAssertEqualObjects([cap1 toString], [cap2 toString]);

    // They should match each other
    XCTAssertTrue([cap1 matches:cap2]);
    XCTAssertTrue([cap2 matches:cap1]);
}

- (void)testInvalidTaggedUrn {
    NSError *error;
    CSTaggedUrn *taggedUrn = [CSTaggedUrn fromString:@"" error:&error];

    XCTAssertNil(taggedUrn);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, CSTaggedUrnErrorInvalidFormat);
}

- (void)testInvalidTagFormat {
    NSError *error;
    CSTaggedUrn *taggedUrn = [CSTaggedUrn fromString:@"cap:invalid_tag" error:&error];

    XCTAssertNil(taggedUrn);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, CSTaggedUrnErrorInvalidTagFormat);
}

- (void)testInvalidCharacters {
    NSError *error;
    CSTaggedUrn *taggedUrn = [CSTaggedUrn fromString:@"cap:type@invalid=value" error:&error];

    XCTAssertNil(taggedUrn);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, CSTaggedUrnErrorInvalidCharacter);
}

- (void)testTagMatching {
    NSError *error;
    CSTaggedUrn *cap = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf;target=thumbnail;" error:&error];

    // Exact match
    CSTaggedUrn *request1 = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf;target=thumbnail;" error:&error];
    XCTAssertTrue([cap matches:request1]);

    // Subset match
    CSTaggedUrn *request2 = [CSTaggedUrn fromString:@"cap:op=generate" error:&error];
    XCTAssertTrue([cap matches:request2]);

    // Wildcard request should match specific cap
    CSTaggedUrn *request3 = [CSTaggedUrn fromString:@"cap:ext=*" error:&error];
    XCTAssertTrue([cap matches:request3]);

    // No match - conflicting value
    CSTaggedUrn *request4 = [CSTaggedUrn fromString:@"cap:op=extract" error:&error];
    XCTAssertFalse([cap matches:request4]);
}

- (void)testMissingTagHandling {
    NSError *error;
    CSTaggedUrn *cap = [CSTaggedUrn fromString:@"cap:op=generate" error:&error];

    // Request with tag should match cap without tag (treated as wildcard)
    CSTaggedUrn *request1 = [CSTaggedUrn fromString:@"cap:ext=pdf" error:&error];
    XCTAssertTrue([cap matches:request1]); // cap missing ext tag = wildcard, can handle any ext

    // But cap with extra tags can match subset requests
    CSTaggedUrn *cap2 = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    CSTaggedUrn *request2 = [CSTaggedUrn fromString:@"cap:op=generate" error:&error];
    XCTAssertTrue([cap2 matches:request2]);
}

- (void)testSpecificity {
    NSError *error;
    CSTaggedUrn *cap1 = [CSTaggedUrn fromString:@"cap:op=*" error:&error];
    CSTaggedUrn *cap2 = [CSTaggedUrn fromString:@"cap:op=generate" error:&error];
    CSTaggedUrn *cap3 = [CSTaggedUrn fromString:@"cap:op=*;ext=pdf" error:&error];

    XCTAssertEqual([cap1 specificity], 0); // wildcard doesn't count
    XCTAssertEqual([cap2 specificity], 1);
    XCTAssertEqual([cap3 specificity], 1); // only ext=pdf counts, op=* doesn't count

    XCTAssertTrue([cap2 isMoreSpecificThan:cap1]);
}

- (void)testCompatibility {
    NSError *error;
    CSTaggedUrn *cap1 = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    CSTaggedUrn *cap2 = [CSTaggedUrn fromString:@"cap:op=generate;format=*" error:&error];
    CSTaggedUrn *cap3 = [CSTaggedUrn fromString:@"cap:op=extract;ext=pdf" error:&error];

    XCTAssertTrue([cap1 isCompatibleWith:cap2]);
    XCTAssertTrue([cap2 isCompatibleWith:cap1]);
    XCTAssertFalse([cap1 isCompatibleWith:cap3]);

    // Missing tags are treated as wildcards for compatibility
    CSTaggedUrn *cap4 = [CSTaggedUrn fromString:@"cap:op=generate" error:&error];
    XCTAssertTrue([cap1 isCompatibleWith:cap4]);
    XCTAssertTrue([cap4 isCompatibleWith:cap1]);
}

- (void)testConvenienceMethods {
    NSError *error;
    CSTaggedUrn *cap = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf;output=binary;target=thumbnail" error:&error];

    XCTAssertEqualObjects([cap getTag:@"op"], @"generate");
    XCTAssertEqualObjects([cap getTag:@"target"], @"thumbnail");
    XCTAssertEqualObjects([cap getTag:@"ext"], @"pdf");
    XCTAssertEqualObjects([cap getTag:@"output"], @"binary");

    XCTAssertEqualObjects([cap getTag:@"output"], @"binary");
}

- (void)testBuilder {
    NSError *error;
    CSTaggedUrnBuilder *builder = [CSTaggedUrnBuilder builder];
    [builder tag:@"op" value:@"generate"];
    [builder tag:@"target" value:@"thumbnail"];
    [builder tag:@"ext" value:@"pdf"];
    [builder tag:@"output" value:@"binary"];
    CSTaggedUrn *cap = [builder build:&error];

    XCTAssertNotNil(cap);
    XCTAssertNil(error);

    XCTAssertEqualObjects([cap getTag:@"op"], @"generate");
    XCTAssertEqualObjects([cap getTag:@"output"], @"binary");
}

- (void)testWithTag {
    NSError *error;
    CSTaggedUrn *original = [CSTaggedUrn fromString:@"cap:op=generate" error:&error];
    CSTaggedUrn *modified = [original withTag:@"ext" value:@"pdf"];

    // Alphabetical order: ext, op
    XCTAssertEqualObjects([modified toString], @"cap:ext=pdf;op=generate");

    // Original should be unchanged
    XCTAssertEqualObjects([original toString], @"cap:op=generate");
}

- (void)testWithoutTag {
    NSError *error;
    CSTaggedUrn *original = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    CSTaggedUrn *modified = [original withoutTag:@"ext"];

    XCTAssertEqualObjects([modified toString], @"cap:op=generate");

    // Original should be unchanged - alphabetical order: ext, op
    XCTAssertEqualObjects([original toString], @"cap:ext=pdf;op=generate");
}

- (void)testWildcardTag {
    NSError *error;
    CSTaggedUrn *cap = [CSTaggedUrn fromString:@"cap:ext=pdf" error:&error];
    CSTaggedUrn *wildcarded = [cap withWildcardTag:@"ext"];

    XCTAssertEqualObjects([wildcarded toString], @"cap:ext=*");

    // Test that wildcarded cap can match more requests
    CSTaggedUrn *request = [CSTaggedUrn fromString:@"cap:ext=jpg" error:&error];
    XCTAssertFalse([cap matches:request]);

    CSTaggedUrn *wildcardRequest = [CSTaggedUrn fromString:@"cap:ext=*" error:&error];
    XCTAssertTrue([wildcarded matches:wildcardRequest]);
}

- (void)testSubset {
    NSError *error;
    CSTaggedUrn *cap = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf;output=binary;target=thumbnail" error:&error];
    CSTaggedUrn *subset = [cap subset:@[@"type", @"ext"]];

    XCTAssertEqualObjects([subset toString], @"cap:ext=pdf");
}

- (void)testMerge {
    NSError *error;
    CSTaggedUrn *cap1 = [CSTaggedUrn fromString:@"cap:op=generate" error:&error];
    CSTaggedUrn *cap2 = [CSTaggedUrn fromString:@"cap:ext=pdf;output=binary" error:&error];
    CSTaggedUrn *merged = [cap1 merge:cap2];

    // Alphabetical order: ext, op, output
    XCTAssertEqualObjects([merged toString], @"cap:ext=pdf;op=generate;output=binary");
}

- (void)testEquality {
    NSError *error;
    CSTaggedUrn *cap1 = [CSTaggedUrn fromString:@"cap:op=generate" error:&error];
    CSTaggedUrn *cap2 = [CSTaggedUrn fromString:@"cap:op=generate" error:&error]; // different order
    CSTaggedUrn *cap3 = [CSTaggedUrn fromString:@"cap:op=generate;type=image" error:&error];

    XCTAssertEqualObjects(cap1, cap2); // order doesn't matter
    XCTAssertNotEqualObjects(cap1, cap3);
    XCTAssertEqual([cap1 hash], [cap2 hash]);
}

- (void)testCoding {
    NSError *error;
    CSTaggedUrn *original = [CSTaggedUrn fromString:@"cap:op=generate" error:&error];
    XCTAssertNotNil(original);
    XCTAssertNil(error);

    // Test NSCoding
    NSError *archiveError = nil;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:original requiringSecureCoding:YES error:&archiveError];
    XCTAssertNil(archiveError, @"Archive should succeed");
    XCTAssertNotNil(data);

    NSError *unarchiveError = nil;
    CSTaggedUrn *decoded = [NSKeyedUnarchiver unarchivedObjectOfClass:[CSTaggedUrn class] fromData:data error:&unarchiveError];
    XCTAssertNil(unarchiveError, @"Unarchive should succeed");
    XCTAssertNotNil(decoded);
    XCTAssertEqualObjects(original, decoded);
}

- (void)testCopying {
    NSError *error;
    CSTaggedUrn *original = [CSTaggedUrn fromString:@"cap:op=generate" error:&error];
    CSTaggedUrn *copy = [original copy];

    XCTAssertEqualObjects(original, copy);
    XCTAssertNotEqual(original, copy); // Different objects
}

#pragma mark - New Rule Tests

- (void)testEmptyTaggedUrn {
    NSError *error = nil;
    // Empty tagged URN should be valid and match everything
    CSTaggedUrn *empty = [CSTaggedUrn fromString:@"cap:" error:&error];
    XCTAssertNotNil(empty);
    XCTAssertNil(error);
    XCTAssertEqual(empty.tags.count, 0);
    XCTAssertEqualObjects([empty toString], @"cap:");

    error = nil;
    // Should match any other cap
    CSTaggedUrn *specific = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    XCTAssertTrue([empty matches:specific]);
    XCTAssertTrue([empty matches:empty]);
}

- (void)testExtendedCharacterSupport {
    NSError *error = nil;
    // Test forward slashes and colons in tag components
    CSTaggedUrn *cap = [CSTaggedUrn fromString:@"cap:url=https://example_org/api;path=/some/file" error:&error];
    XCTAssertNotNil(cap);
    XCTAssertNil(error);
    XCTAssertEqualObjects([cap getTag:@"url"], @"https://example_org/api");
    XCTAssertEqualObjects([cap getTag:@"path"], @"/some/file");
}

- (void)testWildcardRestrictions {
    NSError *error = nil;
    // Wildcard should be rejected in keys
    CSTaggedUrn *invalidKey = [CSTaggedUrn fromString:@"cap:*=value" error:&error];
    XCTAssertNil(invalidKey);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, CSTaggedUrnErrorInvalidCharacter);

    // Reset error for next test
    error = nil;

    // Wildcard should be accepted in values
    CSTaggedUrn *validValue = [CSTaggedUrn fromString:@"cap:key=*" error:&error];
    XCTAssertNotNil(validValue);
    XCTAssertNil(error);
    XCTAssertEqualObjects([validValue getTag:@"key"], @"*");
}

- (void)testDuplicateKeyRejection {
    NSError *error = nil;
    // Duplicate keys should be rejected
    CSTaggedUrn *duplicate = [CSTaggedUrn fromString:@"cap:key=value1;key=value2" error:&error];
    XCTAssertNil(duplicate);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, CSTaggedUrnErrorDuplicateKey);
}

- (void)testNumericKeyRestriction {
    NSError *error = nil;

    // Pure numeric keys should be rejected
    CSTaggedUrn *numericKey = [CSTaggedUrn fromString:@"cap:123=value" error:&error];
    XCTAssertNil(numericKey);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, CSTaggedUrnErrorNumericKey);

    // Reset error for next test
    error = nil;

    // Mixed alphanumeric keys should be allowed
    CSTaggedUrn *mixedKey1 = [CSTaggedUrn fromString:@"cap:key123=value" error:&error];
    XCTAssertNotNil(mixedKey1);
    XCTAssertNil(error);

    error = nil;
    CSTaggedUrn *mixedKey2 = [CSTaggedUrn fromString:@"cap:123key=value" error:&error];
    XCTAssertNotNil(mixedKey2);
    XCTAssertNil(error);

    error = nil;
    // Pure numeric values should be allowed
    CSTaggedUrn *numericValue = [CSTaggedUrn fromString:@"cap:key=123" error:&error];
    XCTAssertNotNil(numericValue);
    XCTAssertNil(error);
    XCTAssertEqualObjects([numericValue getTag:@"key"], @"123");
}

#pragma mark - Quoted Value Tests

- (void)testUnquotedValuesLowercased {
    NSError *error = nil;
    // Unquoted values are normalized to lowercase
    CSTaggedUrn *cap = [CSTaggedUrn fromString:@"cap:OP=Generate;EXT=PDF;Target=Thumbnail;" error:&error];
    XCTAssertNotNil(cap);
    XCTAssertNil(error);

    // Keys are always lowercase
    XCTAssertEqualObjects([cap getTag:@"op"], @"generate");
    XCTAssertEqualObjects([cap getTag:@"ext"], @"pdf");
    XCTAssertEqualObjects([cap getTag:@"target"], @"thumbnail");

    // Key lookup is case-insensitive
    XCTAssertEqualObjects([cap getTag:@"OP"], @"generate");
    XCTAssertEqualObjects([cap getTag:@"Op"], @"generate");

    // Both URNs parse to same lowercase values
    CSTaggedUrn *cap2 = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf;target=thumbnail;" error:&error];
    XCTAssertEqualObjects([cap toString], [cap2 toString]);
    XCTAssertEqualObjects(cap, cap2);
}

- (void)testQuotedValuesPreserveCase {
    NSError *error = nil;
    // Quoted values preserve their case
    CSTaggedUrn *cap = [CSTaggedUrn fromString:@"cap:key=\"Value With Spaces\"" error:&error];
    XCTAssertNotNil(cap);
    XCTAssertNil(error);
    XCTAssertEqualObjects([cap getTag:@"key"], @"Value With Spaces");

    // Key is still lowercase
    error = nil;
    CSTaggedUrn *cap2 = [CSTaggedUrn fromString:@"cap:KEY=\"Value With Spaces\"" error:&error];
    XCTAssertNotNil(cap2);
    XCTAssertNil(error);
    XCTAssertEqualObjects([cap2 getTag:@"key"], @"Value With Spaces");

    // Unquoted vs quoted case difference
    error = nil;
    CSTaggedUrn *unquoted = [CSTaggedUrn fromString:@"cap:key=UPPERCASE" error:&error];
    XCTAssertNotNil(unquoted);
    error = nil;
    CSTaggedUrn *quoted = [CSTaggedUrn fromString:@"cap:key=\"UPPERCASE\"" error:&error];
    XCTAssertNotNil(quoted);

    XCTAssertEqualObjects([unquoted getTag:@"key"], @"uppercase"); // lowercase
    XCTAssertEqualObjects([quoted getTag:@"key"], @"UPPERCASE"); // preserved
    XCTAssertNotEqualObjects(unquoted, quoted); // NOT equal
}

- (void)testQuotedValueSpecialChars {
    NSError *error = nil;
    // Semicolons in quoted values
    CSTaggedUrn *cap = [CSTaggedUrn fromString:@"cap:key=\"value;with;semicolons\"" error:&error];
    XCTAssertNotNil(cap);
    XCTAssertNil(error);
    XCTAssertEqualObjects([cap getTag:@"key"], @"value;with;semicolons");

    // Equals in quoted values
    error = nil;
    CSTaggedUrn *cap2 = [CSTaggedUrn fromString:@"cap:key=\"value=with=equals\"" error:&error];
    XCTAssertNotNil(cap2);
    XCTAssertNil(error);
    XCTAssertEqualObjects([cap2 getTag:@"key"], @"value=with=equals");

    // Spaces in quoted values
    error = nil;
    CSTaggedUrn *cap3 = [CSTaggedUrn fromString:@"cap:key=\"hello world\"" error:&error];
    XCTAssertNotNil(cap3);
    XCTAssertNil(error);
    XCTAssertEqualObjects([cap3 getTag:@"key"], @"hello world");
}

- (void)testQuotedValueEscapeSequences {
    NSError *error = nil;
    // Escaped quotes
    CSTaggedUrn *cap = [CSTaggedUrn fromString:@"cap:key=\"value\\\"quoted\\\"\"" error:&error];
    XCTAssertNotNil(cap);
    XCTAssertNil(error);
    XCTAssertEqualObjects([cap getTag:@"key"], @"value\"quoted\"");

    // Escaped backslashes
    error = nil;
    CSTaggedUrn *cap2 = [CSTaggedUrn fromString:@"cap:key=\"path\\\\file\"" error:&error];
    XCTAssertNotNil(cap2);
    XCTAssertNil(error);
    XCTAssertEqualObjects([cap2 getTag:@"key"], @"path\\file");
}

- (void)testMixedQuotedUnquoted {
    NSError *error = nil;
    CSTaggedUrn *cap = [CSTaggedUrn fromString:@"cap:a=\"Quoted\";b=simple" error:&error];
    XCTAssertNotNil(cap);
    XCTAssertNil(error);
    XCTAssertEqualObjects([cap getTag:@"a"], @"Quoted");
    XCTAssertEqualObjects([cap getTag:@"b"], @"simple");
}

- (void)testUnterminatedQuoteError {
    NSError *error = nil;
    CSTaggedUrn *cap = [CSTaggedUrn fromString:@"cap:key=\"unterminated" error:&error];
    XCTAssertNil(cap);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, CSTaggedUrnErrorUnterminatedQuote);
}

- (void)testInvalidEscapeSequenceError {
    NSError *error = nil;
    CSTaggedUrn *cap = [CSTaggedUrn fromString:@"cap:key=\"bad\\n\"" error:&error];
    XCTAssertNil(cap);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, CSTaggedUrnErrorInvalidEscapeSequence);
}

- (void)testSerializationSmartQuoting {
    NSError *error = nil;
    // Simple lowercase value - no quoting needed
    CSTaggedUrnBuilder *builder = [CSTaggedUrnBuilder builder];
    [builder tag:@"key" value:@"simple"];
    CSTaggedUrn *cap = [builder build:&error];
    XCTAssertNotNil(cap);
    XCTAssertEqualObjects([cap toString], @"cap:key=simple");

    // Value with spaces - needs quoting
    builder = [CSTaggedUrnBuilder builder];
    [builder tag:@"key" value:@"has spaces"];
    CSTaggedUrn *cap2 = [builder build:&error];
    XCTAssertNotNil(cap2);
    XCTAssertEqualObjects([cap2 toString], @"cap:key=\"has spaces\"");

    // Value with uppercase - needs quoting to preserve
    builder = [CSTaggedUrnBuilder builder];
    [builder tag:@"key" value:@"HasUpper"];
    CSTaggedUrn *cap3 = [builder build:&error];
    XCTAssertNotNil(cap3);
    XCTAssertEqualObjects([cap3 toString], @"cap:key=\"HasUpper\"");

    // Value with quotes - needs quoting and escaping
    builder = [CSTaggedUrnBuilder builder];
    [builder tag:@"key" value:@"has\"quote"];
    CSTaggedUrn *cap4 = [builder build:&error];
    XCTAssertNotNil(cap4);
    XCTAssertEqualObjects([cap4 toString], @"cap:key=\"has\\\"quote\"");
}

- (void)testRoundTripSimple {
    NSError *error = nil;
    NSString *original = @"cap:op=generate;ext=pdf";
    CSTaggedUrn *cap = [CSTaggedUrn fromString:original error:&error];
    XCTAssertNotNil(cap);
    NSString *serialized = [cap toString];
    CSTaggedUrn *reparsed = [CSTaggedUrn fromString:serialized error:&error];
    XCTAssertNotNil(reparsed);
    XCTAssertEqualObjects(cap, reparsed);
}

- (void)testRoundTripQuoted {
    NSError *error = nil;
    NSString *original = @"cap:key=\"Value With Spaces\"";
    CSTaggedUrn *cap = [CSTaggedUrn fromString:original error:&error];
    XCTAssertNotNil(cap);
    NSString *serialized = [cap toString];
    CSTaggedUrn *reparsed = [CSTaggedUrn fromString:serialized error:&error];
    XCTAssertNotNil(reparsed);
    XCTAssertEqualObjects(cap, reparsed);
    XCTAssertEqualObjects([reparsed getTag:@"key"], @"Value With Spaces");
}

- (void)testHasTagCaseSensitive {
    NSError *error = nil;
    CSTaggedUrn *cap = [CSTaggedUrn fromString:@"cap:key=\"Value\"" error:&error];
    XCTAssertNotNil(cap);

    // Exact case match works
    XCTAssertTrue([cap hasTag:@"key" withValue:@"Value"]);

    // Different case does not match
    XCTAssertFalse([cap hasTag:@"key" withValue:@"value"]);
    XCTAssertFalse([cap hasTag:@"key" withValue:@"VALUE"]);

    // Key lookup is case-insensitive
    XCTAssertTrue([cap hasTag:@"KEY" withValue:@"Value"]);
    XCTAssertTrue([cap hasTag:@"Key" withValue:@"Value"]);
}

- (void)testBuilderPreservesCase {
    NSError *error = nil;
    CSTaggedUrnBuilder *builder = [CSTaggedUrnBuilder builder];
    [builder tag:@"KEY" value:@"ValueWithCase"];
    CSTaggedUrn *cap = [builder build:&error];
    XCTAssertNotNil(cap);

    // Key is lowercase
    XCTAssertEqualObjects([cap getTag:@"key"], @"ValueWithCase");

    // Value case preserved, so needs quoting
    XCTAssertEqualObjects([cap toString], @"cap:key=\"ValueWithCase\"");
}

- (void)testSemanticEquivalence {
    NSError *error = nil;
    // Unquoted and quoted simple lowercase values are equivalent
    CSTaggedUrn *unquoted = [CSTaggedUrn fromString:@"cap:key=simple" error:&error];
    XCTAssertNotNil(unquoted);
    CSTaggedUrn *quoted = [CSTaggedUrn fromString:@"cap:key=\"simple\"" error:&error];
    XCTAssertNotNil(quoted);
    XCTAssertEqualObjects(unquoted, quoted);

    // Both serialize the same way (unquoted)
    XCTAssertEqualObjects([unquoted toString], @"cap:key=simple");
    XCTAssertEqualObjects([quoted toString], @"cap:key=simple");
}

#pragma mark - Matching Semantics Specification Tests

// ============================================================================
// These 9 tests verify the exact matching semantics from RULES.md Sections 12-17
// All implementations (Rust, Go, JS, ObjC) must pass these identically
// ============================================================================

- (void)testMatchingSemantics_Test1_ExactMatch {
    // Test 1: Exact match
    // Cap:     cap:op=generate;ext=pdf
    // Request: cap:op=generate;ext=pdf
    // Result:  MATCH
    NSError *error = nil;
    CSTaggedUrn *cap = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    XCTAssertNotNil(cap);

    CSTaggedUrn *request = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    XCTAssertNotNil(request);

    XCTAssertTrue([cap matches:request], @"Test 1: Exact match should succeed");
}

- (void)testMatchingSemantics_Test2_CapMissingTag {
    // Test 2: Cap missing tag (implicit wildcard)
    // Cap:     cap:op=generate
    // Request: cap:op=generate;ext=pdf
    // Result:  MATCH (cap can handle any ext)
    NSError *error = nil;
    CSTaggedUrn *cap = [CSTaggedUrn fromString:@"cap:op=generate" error:&error];
    XCTAssertNotNil(cap);

    CSTaggedUrn *request = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    XCTAssertNotNil(request);

    XCTAssertTrue([cap matches:request], @"Test 2: Cap missing tag should match (implicit wildcard)");
}

- (void)testMatchingSemantics_Test3_CapHasExtraTag {
    // Test 3: Cap has extra tag
    // Cap:     cap:op=generate;ext=pdf;version=2
    // Request: cap:op=generate;ext=pdf
    // Result:  MATCH (request doesn't constrain version)
    NSError *error = nil;
    CSTaggedUrn *cap = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf;version=2" error:&error];
    XCTAssertNotNil(cap);

    CSTaggedUrn *request = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    XCTAssertNotNil(request);

    XCTAssertTrue([cap matches:request], @"Test 3: Cap with extra tag should match");
}

- (void)testMatchingSemantics_Test4_RequestHasWildcard {
    // Test 4: Request has wildcard
    // Cap:     cap:op=generate;ext=pdf
    // Request: cap:op=generate;ext=*
    // Result:  MATCH (request accepts any ext)
    NSError *error = nil;
    CSTaggedUrn *cap = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    XCTAssertNotNil(cap);

    CSTaggedUrn *request = [CSTaggedUrn fromString:@"cap:op=generate;ext=*" error:&error];
    XCTAssertNotNil(request);

    XCTAssertTrue([cap matches:request], @"Test 4: Request wildcard should match");
}

- (void)testMatchingSemantics_Test5_CapHasWildcard {
    // Test 5: Cap has wildcard
    // Cap:     cap:op=generate;ext=*
    // Request: cap:op=generate;ext=pdf
    // Result:  MATCH (cap handles any ext)
    NSError *error = nil;
    CSTaggedUrn *cap = [CSTaggedUrn fromString:@"cap:op=generate;ext=*" error:&error];
    XCTAssertNotNil(cap);

    CSTaggedUrn *request = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    XCTAssertNotNil(request);

    XCTAssertTrue([cap matches:request], @"Test 5: Cap wildcard should match");
}

- (void)testMatchingSemantics_Test6_ValueMismatch {
    // Test 6: Value mismatch
    // Cap:     cap:op=generate;ext=pdf
    // Request: cap:op=generate;ext=docx
    // Result:  NO MATCH
    NSError *error = nil;
    CSTaggedUrn *cap = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    XCTAssertNotNil(cap);

    CSTaggedUrn *request = [CSTaggedUrn fromString:@"cap:op=generate;ext=docx" error:&error];
    XCTAssertNotNil(request);

    XCTAssertFalse([cap matches:request], @"Test 6: Value mismatch should not match");
}

- (void)testMatchingSemantics_Test7_FallbackPattern {
    // Test 7: Fallback pattern
    // Cap:     cap:op=generate_thumbnail;out=std:binary.v1
    // Request: cap:op=generate_thumbnail;out=std:binary.v1;ext=wav
    // Result:  MATCH (cap has implicit ext=*)
    NSError *error = nil;
    CSTaggedUrn *cap = [CSTaggedUrn fromString:@"cap:op=generate_thumbnail;out=std:binary.v1" error:&error];
    XCTAssertNotNil(cap);

    CSTaggedUrn *request = [CSTaggedUrn fromString:@"cap:op=generate_thumbnail;out=std:binary.v1;ext=wav" error:&error];
    XCTAssertNotNil(request);

    XCTAssertTrue([cap matches:request], @"Test 7: Fallback pattern should match (cap missing ext = implicit wildcard)");
}

- (void)testMatchingSemantics_Test8_EmptyCapMatchesAnything {
    // Test 8: Empty cap matches anything
    // Cap:     cap:
    // Request: cap:op=generate;ext=pdf
    // Result:  MATCH
    NSError *error = nil;
    CSTaggedUrn *cap = [CSTaggedUrn fromString:@"cap:" error:&error];
    XCTAssertNotNil(cap);

    CSTaggedUrn *request = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    XCTAssertNotNil(request);

    XCTAssertTrue([cap matches:request], @"Test 8: Empty cap should match anything");
}

- (void)testMatchingSemantics_Test9_CrossDimensionIndependence {
    // Test 9: Cross-dimension independence
    // Cap:     cap:op=generate
    // Request: cap:ext=pdf
    // Result:  MATCH (both have implicit wildcards for missing tags)
    NSError *error = nil;
    CSTaggedUrn *cap = [CSTaggedUrn fromString:@"cap:op=generate" error:&error];
    XCTAssertNotNil(cap);

    CSTaggedUrn *request = [CSTaggedUrn fromString:@"cap:ext=pdf" error:&error];
    XCTAssertNotNil(request);

    XCTAssertTrue([cap matches:request], @"Test 9: Cross-dimension independence should match");
}

@end
