//
//  CSTaggedUrnBuilderTests.m
//  Tests for CSTaggedUrnBuilder tag-based system
//
//  NOTE: The `action` tag has been replaced with `op` in the new format.
//

#import <XCTest/XCTest.h>
@import TaggedUrn;

@interface CSTaggedUrnBuilderTests : XCTestCase
@end

@implementation CSTaggedUrnBuilderTests

- (void)testBuilderBasicConstruction {
    NSError *error;
    CSTaggedUrnBuilder *builder = [CSTaggedUrnBuilder builderWithPrefix:@"cap"];
    [builder tag:@"type" value:@"data_processing"];
    [builder tag:@"op" value:@"transform"];
    [builder tag:@"format" value:@"json"];
    CSTaggedUrn *taggedUrn = [builder build:&error];

    XCTAssertNotNil(taggedUrn);
    XCTAssertNil(error);
    // Alphabetical order: format, op, type
    XCTAssertEqualObjects([taggedUrn toString], @"cap:format=json;op=transform;data_processing");
}

- (void)testBuilderFluentAPI {
    NSError *error;
    CSTaggedUrnBuilder *builder = [CSTaggedUrnBuilder builderWithPrefix:@"cap"];
    [builder tag:@"op" value:@"generate"];
    [builder tag:@"target" value:@"thumbnail"];
    [builder tag:@"format" value:@"pdf"];
    [builder tag:@"output" value:@"binary"];
    CSTaggedUrn *urn = [builder build:&error];

    XCTAssertNotNil(urn);
    XCTAssertNil(error);

    XCTAssertEqualObjects([urn getTag:@"op"], @"generate");
    XCTAssertEqualObjects([urn getTag:@"target"], @"thumbnail");
    XCTAssertEqualObjects([urn getTag:@"format"], @"pdf");
    XCTAssertEqualObjects([urn getTag:@"output"], @"binary");
    XCTAssertEqualObjects([urn getTag:@"output"], @"binary");
}

- (void)testBuilderJSONOutput {
    NSError *error;
    CSTaggedUrnBuilder *builder = [CSTaggedUrnBuilder builderWithPrefix:@"cap"];
    [builder tag:@"type" value:@"api"];
    [builder tag:@"op" value:@"process"];
    [builder tag:@"target" value:@"data"];
    [builder tag:@"output" value:@"json"];
    CSTaggedUrn *urn = [builder build:&error];

    XCTAssertNotNil(urn);
    XCTAssertNil(error);

    XCTAssertEqualObjects([urn getTag:@"output"], @"json");
    XCTAssertEqualObjects([urn getTag:@"output"], @"json");
}

- (void)testBuilderCustomTags {
    NSError *error;
    CSTaggedUrnBuilder *builder = [CSTaggedUrnBuilder builderWithPrefix:@"cap"];
    [builder tag:@"engine" value:@"v2"];
    [builder tag:@"quality" value:@"high"];
    [builder tag:@"op" value:@"compress"];
    CSTaggedUrn *urn = [builder build:&error];

    XCTAssertNotNil(urn);
    XCTAssertNil(error);

    XCTAssertEqualObjects([urn getTag:@"engine"], @"v2");
    XCTAssertEqualObjects([urn getTag:@"quality"], @"high");
    XCTAssertEqualObjects([urn getTag:@"op"], @"compress");
}

- (void)testBuilderTagOverrides {
    NSError *error;
    CSTaggedUrnBuilder *builder = [CSTaggedUrnBuilder builderWithPrefix:@"cap"];
    [builder tag:@"op" value:@"convert"];
    [builder tag:@"format" value:@"jpg"];
    CSTaggedUrn *urn = [builder build:&error];

    XCTAssertNotNil(urn);
    XCTAssertNil(error);

    XCTAssertEqualObjects([urn getTag:@"op"], @"convert");
    XCTAssertEqualObjects([urn getTag:@"format"], @"jpg");
}

- (void)testBuilderEmptyBuild {
    NSError *error;
    CSTaggedUrn *urn = [[CSTaggedUrnBuilder builderWithPrefix:@"cap"] build:&error];

    XCTAssertNil(urn);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, CSTaggedUrnErrorInvalidFormat);
    XCTAssertTrue([error.localizedDescription containsString:@"cannot be empty"]);
}

- (void)testBuilderBuildAllowEmpty {
    CSTaggedUrn *urn = [[CSTaggedUrnBuilder builderWithPrefix:@"cap"] buildAllowEmpty];

    XCTAssertNotNil(urn);
    XCTAssertEqual(urn.tags.count, 0);
    XCTAssertEqualObjects([urn toString], @"cap:");
}

- (void)testBuilderSingleTag {
    NSError *error;
    CSTaggedUrnBuilder *builder = [CSTaggedUrnBuilder builderWithPrefix:@"cap"];
    [builder tag:@"type" value:@"utility"];
    CSTaggedUrn *urn = [builder build:&error];

    XCTAssertNotNil(urn);
    XCTAssertNil(error);

    XCTAssertEqualObjects([urn toString], @"cap:utility");
    XCTAssertEqualObjects([urn getTag:@"type"], @"utility");
    XCTAssertEqual([urn specificity], 1);
}

- (void)testBuilderComplex {
    NSError *error;
    CSTaggedUrnBuilder *builder = [CSTaggedUrnBuilder builderWithPrefix:@"cap"];
    [builder tag:@"type" value:@"media"];
    [builder tag:@"op" value:@"transcode"];
    [builder tag:@"target" value:@"video"];
    [builder tag:@"format" value:@"mp4"];
    [builder tag:@"codec" value:@"h264"];
    [builder tag:@"quality" value:@"1080p"];
    [builder tag:@"framerate" value:@"30fps"];
    [builder tag:@"output" value:@"binary"];
    CSTaggedUrn *urn = [builder build:&error];

    XCTAssertNotNil(urn);
    XCTAssertNil(error);

    // Alphabetical order: codec, format, framerate, op, output, quality, target, type
    NSString *expected = @"cap:codec=h264;format=mp4;framerate=30fps;op=transcode;output=binary;quality=1080p;target=video;media";
    XCTAssertEqualObjects([urn toString], expected);

    XCTAssertEqualObjects([urn getTag:@"type"], @"media");
    XCTAssertEqualObjects([urn getTag:@"op"], @"transcode");
    XCTAssertEqualObjects([urn getTag:@"target"], @"video");
    XCTAssertEqualObjects([urn getTag:@"format"], @"mp4");
    XCTAssertEqualObjects([urn getTag:@"codec"], @"h264");
    XCTAssertEqualObjects([urn getTag:@"quality"], @"1080p");
    XCTAssertEqualObjects([urn getTag:@"framerate"], @"30fps");
    XCTAssertEqualObjects([urn getTag:@"output"], @"binary");

    XCTAssertEqual([urn specificity], 8); // All 8 tags are non-wildcard
}

- (void)testBuilderWildcards {
    NSError *error;
    CSTaggedUrnBuilder *builder = [CSTaggedUrnBuilder builderWithPrefix:@"cap"];
    [builder tag:@"op" value:@"convert"];
    [builder tag:@"ext" value:@"*"]; // Wildcard format
    [builder tag:@"quality" value:@"*"]; // Wildcard quality
    CSTaggedUrn *urn = [builder build:&error];

    XCTAssertNotNil(urn);
    XCTAssertNil(error);

    // Alphabetical order: ext, op, quality (wildcards serialize as value-less)
    XCTAssertEqualObjects([urn toString], @"cap:ext;op=convert;quality");
    XCTAssertEqual([urn specificity], 1); // Only op is specific

    XCTAssertEqualObjects([urn getTag:@"ext"], @"*");
    XCTAssertEqualObjects([urn getTag:@"quality"], @"*");
}

- (void)testBuilderStaticFactory {
    CSTaggedUrnBuilder *builder1 = [CSTaggedUrnBuilder builderWithPrefix:@"cap"];
    CSTaggedUrnBuilder *builder2 = [CSTaggedUrnBuilder builderWithPrefix:@"cap"];

    XCTAssertNotEqual(builder1, builder2); // Should be different instances
    XCTAssertNotNil(builder1);
    XCTAssertNotNil(builder2);
}

- (void)testBuilderCustomPrefix {
    NSError *error;
    CSTaggedUrnBuilder *builder = [CSTaggedUrnBuilder builderWithPrefix:@"myapp"];
    [builder tag:@"key" value:@"value"];
    CSTaggedUrn *urn = [builder build:&error];

    XCTAssertNotNil(urn);
    XCTAssertNil(error);
    XCTAssertEqualObjects(urn.prefix, @"myapp");
    XCTAssertEqualObjects([urn toString], @"myapp:key=value");
}

- (void)testBuilderMatchingWithBuiltUrn {
    NSError *error;

    // Create a specific urn
    CSTaggedUrnBuilder *builder1 = [CSTaggedUrnBuilder builderWithPrefix:@"cap"];
    [builder1 tag:@"op" value:@"generate"];
    [builder1 tag:@"target" value:@"thumbnail"];
    [builder1 tag:@"format" value:@"pdf"];
    CSTaggedUrn *specificUrn = [builder1 build:&error];

    // Create a more general request
    CSTaggedUrnBuilder *builder2 = [CSTaggedUrnBuilder builderWithPrefix:@"cap"];
    [builder2 tag:@"op" value:@"generate"];
    CSTaggedUrn *generalRequest = [builder2 build:&error];

    // Create a wildcard request
    CSTaggedUrnBuilder *builder3 = [CSTaggedUrnBuilder builderWithPrefix:@"cap"];
    [builder3 tag:@"op" value:@"generate"];
    [builder3 tag:@"target" value:@"thumbnail"];
    [builder3 tag:@"ext" value:@"*"];
    CSTaggedUrn *wildcardRequest = [builder3 build:&error];

    XCTAssertNotNil(specificUrn);
    XCTAssertNotNil(generalRequest);
    XCTAssertNotNil(wildcardRequest);

    // Specific urn should handle general request
    BOOL matches = [specificUrn matches:generalRequest error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(matches);

    // Specific urn should handle wildcard request
    matches = [specificUrn matches:wildcardRequest error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(matches);

    // Check specificity
    BOOL moreSpecific = [specificUrn isMoreSpecificThan:generalRequest error:&error];
    XCTAssertNil(error);
    XCTAssertTrue(moreSpecific);

    XCTAssertEqual([specificUrn specificity], 3); // op, target, format
    XCTAssertEqual([generalRequest specificity], 1); // op
    XCTAssertEqual([wildcardRequest specificity], 2); // op, target (ext=* doesn't count)
}

@end
