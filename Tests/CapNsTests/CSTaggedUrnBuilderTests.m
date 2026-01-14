//
//  CSTaggedUrnBuilderTests.m
//  Tests for CSTaggedUrnBuilder tag-based system
//
//  NOTE: The `action` tag has been replaced with `op` in the new format.
//

#import <XCTest/XCTest.h>
#import "CapNs.h"

@interface CSTaggedUrnBuilderTests : XCTestCase
@end

@implementation CSTaggedUrnBuilderTests

- (void)testBuilderBasicConstruction {
    NSError *error;
    CSTaggedUrnBuilder *builder = [CSTaggedUrnBuilder builder];
    [builder tag:@"type" value:@"data_processing"];
    [builder tag:@"op" value:@"transform"];
    [builder tag:@"format" value:@"json"];
    CSTaggedUrn *taggedUrn = [builder build:&error];

    XCTAssertNotNil(taggedUrn);
    XCTAssertNil(error);
    // Alphabetical order: format, op, type
    XCTAssertEqualObjects([taggedUrn toString], @"cap:format=json;op=transform;type=data_processing");
}

- (void)testBuilderFluentAPI {
    NSError *error;
    CSTaggedUrnBuilder *builder = [CSTaggedUrnBuilder builder];
    [builder tag:@"op" value:@"generate"];
    [builder tag:@"target" value:@"thumbnail"];
    [builder tag:@"format" value:@"pdf"];
    [builder tag:@"output" value:@"binary"];
    CSTaggedUrn *cap = [builder build:&error];

    XCTAssertNotNil(cap);
    XCTAssertNil(error);

    XCTAssertEqualObjects([cap getTag:@"op"], @"generate");
    XCTAssertEqualObjects([cap getTag:@"target"], @"thumbnail");
    XCTAssertEqualObjects([cap getTag:@"format"], @"pdf");
    XCTAssertEqualObjects([cap getTag:@"output"], @"binary");
    XCTAssertEqualObjects([cap getTag:@"output"], @"binary");
}

- (void)testBuilderJSONOutput {
    NSError *error;
    CSTaggedUrnBuilder *builder = [CSTaggedUrnBuilder builder];
    [builder tag:@"type" value:@"api"];
    [builder tag:@"op" value:@"process"];
    [builder tag:@"target" value:@"data"];
    [builder tag:@"output" value:@"json"];
    CSTaggedUrn *cap = [builder build:&error];

    XCTAssertNotNil(cap);
    XCTAssertNil(error);

    XCTAssertEqualObjects([cap getTag:@"output"], @"json");
    XCTAssertEqualObjects([cap getTag:@"output"], @"json");
}

- (void)testBuilderCustomTags {
    NSError *error;
    CSTaggedUrnBuilder *builder = [CSTaggedUrnBuilder builder];
    [builder tag:@"engine" value:@"v2"];
    [builder tag:@"quality" value:@"high"];
    [builder tag:@"op" value:@"compress"];
    CSTaggedUrn *cap = [builder build:&error];

    XCTAssertNotNil(cap);
    XCTAssertNil(error);

    XCTAssertEqualObjects([cap getTag:@"engine"], @"v2");
    XCTAssertEqualObjects([cap getTag:@"quality"], @"high");
    XCTAssertEqualObjects([cap getTag:@"op"], @"compress");
}

- (void)testBuilderTagOverrides {
    NSError *error;
    CSTaggedUrnBuilder *builder = [CSTaggedUrnBuilder builder];
    [builder tag:@"op" value:@"convert"];
    [builder tag:@"format" value:@"jpg"];
    CSTaggedUrn *cap = [builder build:&error];

    XCTAssertNotNil(cap);
    XCTAssertNil(error);

    XCTAssertEqualObjects([cap getTag:@"op"], @"convert");
    XCTAssertEqualObjects([cap getTag:@"format"], @"jpg");
}

- (void)testBuilderEmptyBuild {
    NSError *error;
    CSTaggedUrn *cap = [[CSTaggedUrnBuilder builder] build:&error];

    XCTAssertNil(cap);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, CSTaggedUrnErrorInvalidFormat);
    XCTAssertTrue([error.localizedDescription containsString:@"cannot be empty"]);
}

- (void)testBuilderSingleTag {
    NSError *error;
    CSTaggedUrnBuilder *builder = [CSTaggedUrnBuilder builder];
    [builder tag:@"type" value:@"utility"];
    CSTaggedUrn *cap = [builder build:&error];

    XCTAssertNotNil(cap);
    XCTAssertNil(error);

    XCTAssertEqualObjects([cap toString], @"cap:type=utility");
    XCTAssertEqualObjects([cap getTag:@"type"], @"utility");
    XCTAssertEqual([cap specificity], 1);
}

- (void)testBuilderComplex {
    NSError *error;
    CSTaggedUrnBuilder *builder = [CSTaggedUrnBuilder builder];
    [builder tag:@"type" value:@"media"];
    [builder tag:@"op" value:@"transcode"];
    [builder tag:@"target" value:@"video"];
    [builder tag:@"format" value:@"mp4"];
    [builder tag:@"codec" value:@"h264"];
    [builder tag:@"quality" value:@"1080p"];
    [builder tag:@"framerate" value:@"30fps"];
    [builder tag:@"output" value:@"binary"];
    CSTaggedUrn *cap = [builder build:&error];

    XCTAssertNotNil(cap);
    XCTAssertNil(error);

    // Alphabetical order: codec, format, framerate, op, output, quality, target, type
    NSString *expected = @"cap:codec=h264;format=mp4;framerate=30fps;op=transcode;output=binary;quality=1080p;target=video;type=media";
    XCTAssertEqualObjects([cap toString], expected);

    XCTAssertEqualObjects([cap getTag:@"type"], @"media");
    XCTAssertEqualObjects([cap getTag:@"op"], @"transcode");
    XCTAssertEqualObjects([cap getTag:@"target"], @"video");
    XCTAssertEqualObjects([cap getTag:@"format"], @"mp4");
    XCTAssertEqualObjects([cap getTag:@"codec"], @"h264");
    XCTAssertEqualObjects([cap getTag:@"quality"], @"1080p");
    XCTAssertEqualObjects([cap getTag:@"framerate"], @"30fps");
    XCTAssertEqualObjects([cap getTag:@"output"], @"binary");

    XCTAssertEqual([cap specificity], 8); // All 8 tags are non-wildcard
}

- (void)testBuilderWildcards {
    NSError *error;
    CSTaggedUrnBuilder *builder = [CSTaggedUrnBuilder builder];
    [builder tag:@"op" value:@"convert"];
    [builder tag:@"ext" value:@"*"]; // Wildcard format
    [builder tag:@"quality" value:@"*"]; // Wildcard quality
    CSTaggedUrn *cap = [builder build:&error];

    XCTAssertNotNil(cap);
    XCTAssertNil(error);

    // Alphabetical order: ext, op, quality
    XCTAssertEqualObjects([cap toString], @"cap:ext=*;op=convert;quality=*");
    XCTAssertEqual([cap specificity], 1); // Only op is specific

    XCTAssertEqualObjects([cap getTag:@"ext"], @"*");
    XCTAssertEqualObjects([cap getTag:@"quality"], @"*");
}

- (void)testBuilderStaticFactory {
    CSTaggedUrnBuilder *builder1 = [CSTaggedUrnBuilder builder];
    CSTaggedUrnBuilder *builder2 = [CSTaggedUrnBuilder builder];

    XCTAssertNotEqual(builder1, builder2); // Should be different instances
    XCTAssertNotNil(builder1);
    XCTAssertNotNil(builder2);
}

- (void)testBuilderMatchingWithBuiltCap {
    NSError *error;

    // Create a specific cap
    CSTaggedUrnBuilder *builder1 = [CSTaggedUrnBuilder builder];
    [builder1 tag:@"op" value:@"generate"];
    [builder1 tag:@"target" value:@"thumbnail"];
    [builder1 tag:@"format" value:@"pdf"];
    CSTaggedUrn *specificCap = [builder1 build:&error];

    // Create a more general request
    CSTaggedUrnBuilder *builder2 = [CSTaggedUrnBuilder builder];
    [builder2 tag:@"op" value:@"generate"];
    CSTaggedUrn *generalRequest = [builder2 build:&error];

    // Create a wildcard request
    CSTaggedUrnBuilder *builder3 = [CSTaggedUrnBuilder builder];
    [builder3 tag:@"op" value:@"generate"];
    [builder3 tag:@"target" value:@"thumbnail"];
    [builder3 tag:@"ext" value:@"*"];
    CSTaggedUrn *wildcardRequest = [builder3 build:&error];

    XCTAssertNotNil(specificCap);
    XCTAssertNotNil(generalRequest);
    XCTAssertNotNil(wildcardRequest);

    // Specific cap should handle general request
    XCTAssertTrue([specificCap matches:generalRequest]);

    // Specific cap should handle wildcard request
    XCTAssertTrue([specificCap matches:wildcardRequest]);

    // Check specificity
    XCTAssertTrue([specificCap isMoreSpecificThan:generalRequest]);
    XCTAssertEqual([specificCap specificity], 3); // op, target, format
    XCTAssertEqual([generalRequest specificity], 1); // op
    XCTAssertEqual([wildcardRequest specificity], 2); // op, target (ext=* doesn't count)
}

@end
