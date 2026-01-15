//
//  CSTaggedUrnTests.m
//  Tests for CSTaggedUrn tag-based system
//
//  NOTE: The `action` tag has been replaced with `op` in the new format.
//

#import <XCTest/XCTest.h>
@import TaggedUrn;

@interface CSTaggedUrnTests : XCTestCase
@end

@implementation CSTaggedUrnTests

- (void)testTaggedUrnCreation {
    NSError *error;
    CSTaggedUrn *taggedUrn = [CSTaggedUrn fromString:@"cap:op=transform;format=json;type=data_processing" error:&error];

    XCTAssertNotNil(taggedUrn);
    XCTAssertNil(error);

    XCTAssertEqualObjects(taggedUrn.prefix, @"cap");
    XCTAssertEqualObjects([taggedUrn getTag:@"type"], @"data_processing");
    XCTAssertEqualObjects([taggedUrn getTag:@"op"], @"transform");
    XCTAssertEqualObjects([taggedUrn getTag:@"format"], @"json");
}

- (void)testCustomPrefix {
    NSError *error;
    CSTaggedUrn *urn = [CSTaggedUrn fromString:@"myapp:op=generate;ext=pdf" error:&error];
    XCTAssertNotNil(urn);
    XCTAssertNil(error);

    XCTAssertEqualObjects(urn.prefix, @"myapp");
    XCTAssertEqualObjects([urn getTag:@"op"], @"generate");
    XCTAssertEqualObjects([urn toString], @"myapp:ext=pdf;op=generate");
}

- (void)testPrefixCaseInsensitive {
    NSError *error;
    CSTaggedUrn *urn1 = [CSTaggedUrn fromString:@"CAP:op=test" error:&error];
    XCTAssertNotNil(urn1);
    CSTaggedUrn *urn2 = [CSTaggedUrn fromString:@"cap:op=test" error:&error];
    XCTAssertNotNil(urn2);
    CSTaggedUrn *urn3 = [CSTaggedUrn fromString:@"Cap:op=test" error:&error];
    XCTAssertNotNil(urn3);

    XCTAssertEqualObjects(urn1.prefix, @"cap");
    XCTAssertEqualObjects(urn2.prefix, @"cap");
    XCTAssertEqualObjects(urn3.prefix, @"cap");
    XCTAssertEqualObjects(urn1, urn2);
    XCTAssertEqualObjects(urn2, urn3);
}

- (void)testCanonicalStringFormat {
    NSError *error;
    CSTaggedUrn *taggedUrn = [CSTaggedUrn fromString:@"cap:op=generate;target=thumbnail;ext=pdf" error:&error];

    XCTAssertNotNil(taggedUrn);
    XCTAssertNil(error);

    // Should be sorted alphabetically: ext, op, target
    XCTAssertEqualObjects([taggedUrn toString], @"cap:ext=pdf;op=generate;target=thumbnail");
}

- (void)testPrefixRequired {
    NSError *error;
    // Missing prefix should fail
    CSTaggedUrn *taggedUrn = [CSTaggedUrn fromString:@"op=generate;ext=pdf" error:&error];
    XCTAssertNil(taggedUrn);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, CSTaggedUrnErrorMissingPrefix);

    // Empty prefix should fail
    error = nil;
    taggedUrn = [CSTaggedUrn fromString:@":op=generate" error:&error];
    XCTAssertNil(taggedUrn);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, CSTaggedUrnErrorEmptyPrefix);

    // Valid prefix should work
    error = nil;
    taggedUrn = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    XCTAssertNotNil(taggedUrn);
    XCTAssertNil(error);
    XCTAssertEqualObjects([taggedUrn getTag:@"op"], @"generate");
}

- (void)testTrailingSemicolonEquivalence {
    NSError *error;
    // Both with and without trailing semicolon should be equivalent
    CSTaggedUrn *urn1 = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    XCTAssertNotNil(urn1);

    CSTaggedUrn *urn2 = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf;" error:&error];
    XCTAssertNotNil(urn2);

    // They should be equal
    XCTAssertEqualObjects(urn1, urn2);

    // They should have same hash
    XCTAssertEqual([urn1 hash], [urn2 hash]);

    // They should have same string representation (canonical form)
    XCTAssertEqualObjects([urn1 toString], [urn2 toString]);

    // They should match each other
    BOOL matches1 = [urn1 matches:urn2 error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(matches1);

    BOOL matches2 = [urn2 matches:urn1 error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(matches2);
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
    CSTaggedUrn *urn = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf;target=thumbnail;" error:&error];

    // Exact match
    CSTaggedUrn *request1 = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf;target=thumbnail;" error:&error];
    BOOL matches = [urn matches:request1 error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(matches);

    // Subset match
    CSTaggedUrn *request2 = [CSTaggedUrn fromString:@"cap:op=generate" error:&error];
    matches = [urn matches:request2 error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(matches);

    // Wildcard request should match specific urn
    CSTaggedUrn *request3 = [CSTaggedUrn fromString:@"cap:ext=*" error:&error];
    matches = [urn matches:request3 error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(matches);

    // No match - conflicting value
    CSTaggedUrn *request4 = [CSTaggedUrn fromString:@"cap:op=extract" error:&error];
    matches = [urn matches:request4 error:&error];
    XCTAssertNil(error);
    XCTAssertFalse(matches);
}

- (void)testPrefixMismatchError {
    NSError *error;
    CSTaggedUrn *urn1 = [CSTaggedUrn fromString:@"cap:op=test" error:&error];
    XCTAssertNotNil(urn1);
    CSTaggedUrn *urn2 = [CSTaggedUrn fromString:@"myapp:op=test" error:&error];
    XCTAssertNotNil(urn2);

    error = nil;
    [urn1 matches:urn2 error:&error];
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, CSTaggedUrnErrorPrefixMismatch);
}

- (void)testMissingTagHandling {
    NSError *error;
    CSTaggedUrn *urn = [CSTaggedUrn fromString:@"cap:op=generate" error:&error];

    // Request with tag should match urn without tag (treated as wildcard)
    CSTaggedUrn *request1 = [CSTaggedUrn fromString:@"cap:ext=pdf" error:&error];
    BOOL matches = [urn matches:request1 error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(matches); // urn missing ext tag = wildcard, can handle any ext

    // But urn with extra tags can match subset requests
    CSTaggedUrn *urn2 = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    CSTaggedUrn *request2 = [CSTaggedUrn fromString:@"cap:op=generate" error:&error];
    matches = [urn2 matches:request2 error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(matches);
}

- (void)testSpecificity {
    NSError *error;
    CSTaggedUrn *urn1 = [CSTaggedUrn fromString:@"cap:op=*" error:&error];
    CSTaggedUrn *urn2 = [CSTaggedUrn fromString:@"cap:op=generate" error:&error];
    CSTaggedUrn *urn3 = [CSTaggedUrn fromString:@"cap:op=*;ext=pdf" error:&error];

    XCTAssertEqual([urn1 specificity], 0); // wildcard doesn't count
    XCTAssertEqual([urn2 specificity], 1);
    XCTAssertEqual([urn3 specificity], 1); // only ext=pdf counts, op=* doesn't count

    BOOL moreSpecific = [urn2 isMoreSpecificThan:urn1 error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(moreSpecific);
}

- (void)testCompatibility {
    NSError *error;
    CSTaggedUrn *urn1 = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    CSTaggedUrn *urn2 = [CSTaggedUrn fromString:@"cap:op=generate;format=*" error:&error];
    CSTaggedUrn *urn3 = [CSTaggedUrn fromString:@"cap:op=extract;ext=pdf" error:&error];

    BOOL compatible = [urn1 isCompatibleWith:urn2 error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(compatible);

    compatible = [urn2 isCompatibleWith:urn1 error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(compatible);

    compatible = [urn1 isCompatibleWith:urn3 error:&error];
    XCTAssertNil(error);
    XCTAssertFalse(compatible);

    // Missing tags are treated as wildcards for compatibility
    CSTaggedUrn *urn4 = [CSTaggedUrn fromString:@"cap:op=generate" error:&error];
    compatible = [urn1 isCompatibleWith:urn4 error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(compatible);

    compatible = [urn4 isCompatibleWith:urn1 error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(compatible);
}

- (void)testConvenienceMethods {
    NSError *error;
    CSTaggedUrn *urn = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf;output=binary;target=thumbnail" error:&error];

    XCTAssertEqualObjects([urn getTag:@"op"], @"generate");
    XCTAssertEqualObjects([urn getTag:@"target"], @"thumbnail");
    XCTAssertEqualObjects([urn getTag:@"ext"], @"pdf");
    XCTAssertEqualObjects([urn getTag:@"output"], @"binary");

    XCTAssertEqualObjects([urn getTag:@"output"], @"binary");
}

- (void)testBuilder {
    NSError *error;
    CSTaggedUrnBuilder *builder = [CSTaggedUrnBuilder builderWithPrefix:@"cap"];
    [builder tag:@"op" value:@"generate"];
    [builder tag:@"target" value:@"thumbnail"];
    [builder tag:@"ext" value:@"pdf"];
    [builder tag:@"output" value:@"binary"];
    CSTaggedUrn *urn = [builder build:&error];

    XCTAssertNotNil(urn);
    XCTAssertNil(error);

    XCTAssertEqualObjects([urn getTag:@"op"], @"generate");
    XCTAssertEqualObjects([urn getTag:@"output"], @"binary");
}

- (void)testBuilderWithCustomPrefix {
    NSError *error;
    CSTaggedUrnBuilder *builder = [CSTaggedUrnBuilder builderWithPrefix:@"custom"];
    [builder tag:@"key" value:@"value"];
    CSTaggedUrn *urn = [builder build:&error];

    XCTAssertNotNil(urn);
    XCTAssertNil(error);
    XCTAssertEqualObjects(urn.prefix, @"custom");
    XCTAssertEqualObjects([urn toString], @"custom:key=value");
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
    CSTaggedUrn *urn = [CSTaggedUrn fromString:@"cap:ext=pdf" error:&error];
    CSTaggedUrn *wildcarded = [urn withWildcardTag:@"ext"];

    XCTAssertEqualObjects([wildcarded toString], @"cap:ext=*");

    // Test that wildcarded urn can match more requests
    CSTaggedUrn *request = [CSTaggedUrn fromString:@"cap:ext=jpg" error:&error];
    BOOL matches = [urn matches:request error:&error];
    XCTAssertNil(error);
    XCTAssertFalse(matches);

    CSTaggedUrn *wildcardRequest = [CSTaggedUrn fromString:@"cap:ext=*" error:&error];
    matches = [wildcarded matches:wildcardRequest error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(matches);
}

- (void)testSubset {
    NSError *error;
    CSTaggedUrn *urn = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf;output=binary;target=thumbnail" error:&error];
    CSTaggedUrn *subset = [urn subset:@[@"type", @"ext"]];

    XCTAssertEqualObjects([subset toString], @"cap:ext=pdf");
}

- (void)testMerge {
    NSError *error;
    CSTaggedUrn *urn1 = [CSTaggedUrn fromString:@"cap:op=generate" error:&error];
    CSTaggedUrn *urn2 = [CSTaggedUrn fromString:@"cap:ext=pdf;output=binary" error:&error];
    CSTaggedUrn *merged = [urn1 merge:urn2 error:&error];

    XCTAssertNotNil(merged);
    XCTAssertNil(error);

    // Alphabetical order: ext, op, output
    XCTAssertEqualObjects([merged toString], @"cap:ext=pdf;op=generate;output=binary");
}

- (void)testMergePrefixMismatch {
    NSError *error;
    CSTaggedUrn *urn1 = [CSTaggedUrn fromString:@"cap:op=generate" error:&error];
    CSTaggedUrn *urn2 = [CSTaggedUrn fromString:@"myapp:ext=pdf" error:&error];

    error = nil;
    CSTaggedUrn *merged = [urn1 merge:urn2 error:&error];
    XCTAssertNil(merged);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, CSTaggedUrnErrorPrefixMismatch);
}

- (void)testEquality {
    NSError *error;
    CSTaggedUrn *urn1 = [CSTaggedUrn fromString:@"cap:op=generate" error:&error];
    CSTaggedUrn *urn2 = [CSTaggedUrn fromString:@"cap:op=generate" error:&error]; // different order
    CSTaggedUrn *urn3 = [CSTaggedUrn fromString:@"cap:op=generate;type=image" error:&error];

    XCTAssertEqualObjects(urn1, urn2); // order doesn't matter
    XCTAssertNotEqualObjects(urn1, urn3);
    XCTAssertEqual([urn1 hash], [urn2 hash]);
}

- (void)testEqualityDifferentPrefix {
    NSError *error;
    CSTaggedUrn *urn1 = [CSTaggedUrn fromString:@"cap:op=generate" error:&error];
    CSTaggedUrn *urn2 = [CSTaggedUrn fromString:@"myapp:op=generate" error:&error];

    XCTAssertNotEqualObjects(urn1, urn2);
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

- (void)testCodingWithCustomPrefix {
    NSError *error;
    CSTaggedUrn *original = [CSTaggedUrn fromString:@"myapp:key=value" error:&error];
    XCTAssertNotNil(original);
    XCTAssertNil(error);

    NSError *archiveError = nil;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:original requiringSecureCoding:YES error:&archiveError];
    XCTAssertNil(archiveError);
    XCTAssertNotNil(data);

    NSError *unarchiveError = nil;
    CSTaggedUrn *decoded = [NSKeyedUnarchiver unarchivedObjectOfClass:[CSTaggedUrn class] fromData:data error:&unarchiveError];
    XCTAssertNil(unarchiveError);
    XCTAssertNotNil(decoded);
    XCTAssertEqualObjects(original, decoded);
    XCTAssertEqualObjects(decoded.prefix, @"myapp");
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
    // Should match any other urn with same prefix
    CSTaggedUrn *specific = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    BOOL matches = [empty matches:specific error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(matches);

    matches = [empty matches:empty error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(matches);
}

- (void)testEmptyWithCustomPrefix {
    NSError *error = nil;
    CSTaggedUrn *empty = [CSTaggedUrn fromString:@"myapp:" error:&error];
    XCTAssertNotNil(empty);
    XCTAssertNil(error);
    XCTAssertEqualObjects(empty.prefix, @"myapp");
    XCTAssertEqualObjects([empty toString], @"myapp:");
}

- (void)testEmptyWithPrefixMethod {
    CSTaggedUrn *empty = [CSTaggedUrn emptyWithPrefix:@"custom"];
    XCTAssertNotNil(empty);
    XCTAssertEqualObjects(empty.prefix, @"custom");
    XCTAssertEqual(empty.tags.count, 0);
    XCTAssertEqualObjects([empty toString], @"custom:");
}

- (void)testExtendedCharacterSupport {
    NSError *error = nil;
    // Test forward slashes and colons in tag components
    CSTaggedUrn *urn = [CSTaggedUrn fromString:@"cap:url=https://example_org/api;path=/some/file" error:&error];
    XCTAssertNotNil(urn);
    XCTAssertNil(error);
    XCTAssertEqualObjects([urn getTag:@"url"], @"https://example_org/api");
    XCTAssertEqualObjects([urn getTag:@"path"], @"/some/file");
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
    CSTaggedUrn *urn = [CSTaggedUrn fromString:@"cap:OP=Generate;EXT=PDF;Target=Thumbnail;" error:&error];
    XCTAssertNotNil(urn);
    XCTAssertNil(error);

    // Keys are always lowercase
    XCTAssertEqualObjects([urn getTag:@"op"], @"generate");
    XCTAssertEqualObjects([urn getTag:@"ext"], @"pdf");
    XCTAssertEqualObjects([urn getTag:@"target"], @"thumbnail");

    // Key lookup is case-insensitive
    XCTAssertEqualObjects([urn getTag:@"OP"], @"generate");
    XCTAssertEqualObjects([urn getTag:@"Op"], @"generate");

    // Both URNs parse to same lowercase values
    CSTaggedUrn *urn2 = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf;target=thumbnail;" error:&error];
    XCTAssertEqualObjects([urn toString], [urn2 toString]);
    XCTAssertEqualObjects(urn, urn2);
}

- (void)testQuotedValuesPreserveCase {
    NSError *error = nil;
    // Quoted values preserve their case
    CSTaggedUrn *urn = [CSTaggedUrn fromString:@"cap:key=\"Value With Spaces\"" error:&error];
    XCTAssertNotNil(urn);
    XCTAssertNil(error);
    XCTAssertEqualObjects([urn getTag:@"key"], @"Value With Spaces");

    // Key is still lowercase
    error = nil;
    CSTaggedUrn *urn2 = [CSTaggedUrn fromString:@"cap:KEY=\"Value With Spaces\"" error:&error];
    XCTAssertNotNil(urn2);
    XCTAssertNil(error);
    XCTAssertEqualObjects([urn2 getTag:@"key"], @"Value With Spaces");

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
    CSTaggedUrn *urn = [CSTaggedUrn fromString:@"cap:key=\"value;with;semicolons\"" error:&error];
    XCTAssertNotNil(urn);
    XCTAssertNil(error);
    XCTAssertEqualObjects([urn getTag:@"key"], @"value;with;semicolons");

    // Equals in quoted values
    error = nil;
    CSTaggedUrn *urn2 = [CSTaggedUrn fromString:@"cap:key=\"value=with=equals\"" error:&error];
    XCTAssertNotNil(urn2);
    XCTAssertNil(error);
    XCTAssertEqualObjects([urn2 getTag:@"key"], @"value=with=equals");

    // Spaces in quoted values
    error = nil;
    CSTaggedUrn *urn3 = [CSTaggedUrn fromString:@"cap:key=\"hello world\"" error:&error];
    XCTAssertNotNil(urn3);
    XCTAssertNil(error);
    XCTAssertEqualObjects([urn3 getTag:@"key"], @"hello world");
}

- (void)testQuotedValueEscapeSequences {
    NSError *error = nil;
    // Escaped quotes
    CSTaggedUrn *urn = [CSTaggedUrn fromString:@"cap:key=\"value\\\"quoted\\\"\"" error:&error];
    XCTAssertNotNil(urn);
    XCTAssertNil(error);
    XCTAssertEqualObjects([urn getTag:@"key"], @"value\"quoted\"");

    // Escaped backslashes
    error = nil;
    CSTaggedUrn *urn2 = [CSTaggedUrn fromString:@"cap:key=\"path\\\\file\"" error:&error];
    XCTAssertNotNil(urn2);
    XCTAssertNil(error);
    XCTAssertEqualObjects([urn2 getTag:@"key"], @"path\\file");
}

- (void)testMixedQuotedUnquoted {
    NSError *error = nil;
    CSTaggedUrn *urn = [CSTaggedUrn fromString:@"cap:a=\"Quoted\";b=simple" error:&error];
    XCTAssertNotNil(urn);
    XCTAssertNil(error);
    XCTAssertEqualObjects([urn getTag:@"a"], @"Quoted");
    XCTAssertEqualObjects([urn getTag:@"b"], @"simple");
}

- (void)testUnterminatedQuoteError {
    NSError *error = nil;
    CSTaggedUrn *urn = [CSTaggedUrn fromString:@"cap:key=\"unterminated" error:&error];
    XCTAssertNil(urn);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, CSTaggedUrnErrorUnterminatedQuote);
}

- (void)testInvalidEscapeSequenceError {
    NSError *error = nil;
    CSTaggedUrn *urn = [CSTaggedUrn fromString:@"cap:key=\"bad\\n\"" error:&error];
    XCTAssertNil(urn);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, CSTaggedUrnErrorInvalidEscapeSequence);
}

- (void)testSerializationSmartQuoting {
    NSError *error = nil;
    // Simple lowercase value - no quoting needed
    CSTaggedUrnBuilder *builder = [CSTaggedUrnBuilder builderWithPrefix:@"cap"];
    [builder tag:@"key" value:@"simple"];
    CSTaggedUrn *urn = [builder build:&error];
    XCTAssertNotNil(urn);
    XCTAssertEqualObjects([urn toString], @"cap:key=simple");

    // Value with spaces - needs quoting
    builder = [CSTaggedUrnBuilder builderWithPrefix:@"cap"];
    [builder tag:@"key" value:@"has spaces"];
    CSTaggedUrn *urn2 = [builder build:&error];
    XCTAssertNotNil(urn2);
    XCTAssertEqualObjects([urn2 toString], @"cap:key=\"has spaces\"");

    // Value with uppercase - needs quoting to preserve
    builder = [CSTaggedUrnBuilder builderWithPrefix:@"cap"];
    [builder tag:@"key" value:@"HasUpper"];
    CSTaggedUrn *urn3 = [builder build:&error];
    XCTAssertNotNil(urn3);
    XCTAssertEqualObjects([urn3 toString], @"cap:key=\"HasUpper\"");

    // Value with quotes - needs quoting and escaping
    builder = [CSTaggedUrnBuilder builderWithPrefix:@"cap"];
    [builder tag:@"key" value:@"has\"quote"];
    CSTaggedUrn *urn4 = [builder build:&error];
    XCTAssertNotNil(urn4);
    XCTAssertEqualObjects([urn4 toString], @"cap:key=\"has\\\"quote\"");
}

- (void)testRoundTripSimple {
    NSError *error = nil;
    NSString *original = @"cap:op=generate;ext=pdf";
    CSTaggedUrn *urn = [CSTaggedUrn fromString:original error:&error];
    XCTAssertNotNil(urn);
    NSString *serialized = [urn toString];
    CSTaggedUrn *reparsed = [CSTaggedUrn fromString:serialized error:&error];
    XCTAssertNotNil(reparsed);
    XCTAssertEqualObjects(urn, reparsed);
}

- (void)testRoundTripQuoted {
    NSError *error = nil;
    NSString *original = @"cap:key=\"Value With Spaces\"";
    CSTaggedUrn *urn = [CSTaggedUrn fromString:original error:&error];
    XCTAssertNotNil(urn);
    NSString *serialized = [urn toString];
    CSTaggedUrn *reparsed = [CSTaggedUrn fromString:serialized error:&error];
    XCTAssertNotNil(reparsed);
    XCTAssertEqualObjects(urn, reparsed);
    XCTAssertEqualObjects([reparsed getTag:@"key"], @"Value With Spaces");
}

- (void)testHasTagCaseSensitive {
    NSError *error = nil;
    CSTaggedUrn *urn = [CSTaggedUrn fromString:@"cap:key=\"Value\"" error:&error];
    XCTAssertNotNil(urn);

    // Exact case match works
    XCTAssertTrue([urn hasTag:@"key" withValue:@"Value"]);

    // Different case does not match
    XCTAssertFalse([urn hasTag:@"key" withValue:@"value"]);
    XCTAssertFalse([urn hasTag:@"key" withValue:@"VALUE"]);

    // Key lookup is case-insensitive
    XCTAssertTrue([urn hasTag:@"KEY" withValue:@"Value"]);
    XCTAssertTrue([urn hasTag:@"Key" withValue:@"Value"]);
}

- (void)testBuilderPreservesCase {
    NSError *error = nil;
    CSTaggedUrnBuilder *builder = [CSTaggedUrnBuilder builderWithPrefix:@"cap"];
    [builder tag:@"KEY" value:@"ValueWithCase"];
    CSTaggedUrn *urn = [builder build:&error];
    XCTAssertNotNil(urn);

    // Key is lowercase
    XCTAssertEqualObjects([urn getTag:@"key"], @"ValueWithCase");

    // Value case preserved, so needs quoting
    XCTAssertEqualObjects([urn toString], @"cap:key=\"ValueWithCase\"");
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

- (void)testMatchingDifferentPrefixesError {
    NSError *error = nil;
    CSTaggedUrn *urn1 = [CSTaggedUrn fromString:@"cap:op=test" error:&error];
    XCTAssertNotNil(urn1);
    CSTaggedUrn *urn2 = [CSTaggedUrn fromString:@"other:op=test" error:&error];
    XCTAssertNotNil(urn2);

    error = nil;
    [urn1 matches:urn2 error:&error];
    XCTAssertNotNil(error);

    error = nil;
    [urn1 isCompatibleWith:urn2 error:&error];
    XCTAssertNotNil(error);

    error = nil;
    [urn1 isMoreSpecificThan:urn2 error:&error];
    XCTAssertNotNil(error);
}

#pragma mark - Matching Semantics Specification Tests

// ============================================================================
// These 9 tests verify the exact matching semantics from RULES.md Sections 12-17
// All implementations (Rust, Go, JS, ObjC) must pass these identically
// ============================================================================

- (void)testMatchingSemantics_Test1_ExactMatch {
    // Test 1: Exact match
    // URN:     cap:op=generate;ext=pdf
    // Request: cap:op=generate;ext=pdf
    // Result:  MATCH
    NSError *error = nil;
    CSTaggedUrn *urn = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    XCTAssertNotNil(urn);

    CSTaggedUrn *request = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    XCTAssertNotNil(request);

    BOOL matches = [urn matches:request error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(matches, @"Test 1: Exact match should succeed");
}

- (void)testMatchingSemantics_Test2_UrnMissingTag {
    // Test 2: URN missing tag (implicit wildcard)
    // URN:     cap:op=generate
    // Request: cap:op=generate;ext=pdf
    // Result:  MATCH (URN can handle any ext)
    NSError *error = nil;
    CSTaggedUrn *urn = [CSTaggedUrn fromString:@"cap:op=generate" error:&error];
    XCTAssertNotNil(urn);

    CSTaggedUrn *request = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    XCTAssertNotNil(request);

    BOOL matches = [urn matches:request error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(matches, @"Test 2: URN missing tag should match (implicit wildcard)");
}

- (void)testMatchingSemantics_Test3_UrnHasExtraTag {
    // Test 3: URN has extra tag
    // URN:     cap:op=generate;ext=pdf;version=2
    // Request: cap:op=generate;ext=pdf
    // Result:  MATCH (request doesn't constrain version)
    NSError *error = nil;
    CSTaggedUrn *urn = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf;version=2" error:&error];
    XCTAssertNotNil(urn);

    CSTaggedUrn *request = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    XCTAssertNotNil(request);

    BOOL matches = [urn matches:request error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(matches, @"Test 3: URN with extra tag should match");
}

- (void)testMatchingSemantics_Test4_RequestHasWildcard {
    // Test 4: Request has wildcard
    // URN:     cap:op=generate;ext=pdf
    // Request: cap:op=generate;ext=*
    // Result:  MATCH (request accepts any ext)
    NSError *error = nil;
    CSTaggedUrn *urn = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    XCTAssertNotNil(urn);

    CSTaggedUrn *request = [CSTaggedUrn fromString:@"cap:op=generate;ext=*" error:&error];
    XCTAssertNotNil(request);

    BOOL matches = [urn matches:request error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(matches, @"Test 4: Request wildcard should match");
}

- (void)testMatchingSemantics_Test5_UrnHasWildcard {
    // Test 5: URN has wildcard
    // URN:     cap:op=generate;ext=*
    // Request: cap:op=generate;ext=pdf
    // Result:  MATCH (URN handles any ext)
    NSError *error = nil;
    CSTaggedUrn *urn = [CSTaggedUrn fromString:@"cap:op=generate;ext=*" error:&error];
    XCTAssertNotNil(urn);

    CSTaggedUrn *request = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    XCTAssertNotNil(request);

    BOOL matches = [urn matches:request error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(matches, @"Test 5: URN wildcard should match");
}

- (void)testMatchingSemantics_Test6_ValueMismatch {
    // Test 6: Value mismatch
    // URN:     cap:op=generate;ext=pdf
    // Request: cap:op=generate;ext=docx
    // Result:  NO MATCH
    NSError *error = nil;
    CSTaggedUrn *urn = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    XCTAssertNotNil(urn);

    CSTaggedUrn *request = [CSTaggedUrn fromString:@"cap:op=generate;ext=docx" error:&error];
    XCTAssertNotNil(request);

    BOOL matches = [urn matches:request error:&error];
    XCTAssertNil(error);
    XCTAssertFalse(matches, @"Test 6: Value mismatch should not match");
}

- (void)testMatchingSemantics_Test7_FallbackPattern {
    // Test 7: Fallback pattern
    // URN:     cap:op=generate_thumbnail;out="media:type=binary;v=1"
    // Request: cap:ext=wav;op=generate_thumbnail;out="media:type=binary;v=1"
    // Result:  MATCH (URN has implicit ext=*)
    NSError *error = nil;
    CSTaggedUrn *urn = [CSTaggedUrn fromString:@"cap:op=generate_thumbnail;out=\"media:type=binary;v=1\"" error:&error];
    XCTAssertNotNil(urn);

    CSTaggedUrn *request = [CSTaggedUrn fromString:@"cap:ext=wav;op=generate_thumbnail;out=\"media:type=binary;v=1\"" error:&error];
    XCTAssertNotNil(request);

    BOOL matches = [urn matches:request error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(matches, @"Test 7: Fallback pattern should match (URN missing ext = implicit wildcard)");
}

- (void)testMatchingSemantics_Test8_EmptyUrnMatchesAnything {
    // Test 8: Empty URN matches anything
    // URN:     cap:
    // Request: cap:op=generate;ext=pdf
    // Result:  MATCH
    NSError *error = nil;
    CSTaggedUrn *urn = [CSTaggedUrn fromString:@"cap:" error:&error];
    XCTAssertNotNil(urn);

    CSTaggedUrn *request = [CSTaggedUrn fromString:@"cap:op=generate;ext=pdf" error:&error];
    XCTAssertNotNil(request);

    BOOL matches = [urn matches:request error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(matches, @"Test 8: Empty URN should match anything");
}

- (void)testMatchingSemantics_Test9_CrossDimensionIndependence {
    // Test 9: Cross-dimension independence
    // URN:     cap:op=generate
    // Request: cap:ext=pdf
    // Result:  MATCH (both have implicit wildcards for missing tags)
    NSError *error = nil;
    CSTaggedUrn *urn = [CSTaggedUrn fromString:@"cap:op=generate" error:&error];
    XCTAssertNotNil(urn);

    CSTaggedUrn *request = [CSTaggedUrn fromString:@"cap:ext=pdf" error:&error];
    XCTAssertNotNil(request);

    BOOL matches = [urn matches:request error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(matches, @"Test 9: Cross-dimension independence should match");
}

@end
