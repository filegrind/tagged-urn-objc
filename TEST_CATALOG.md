# Swift/ObjC Test Catalog

**Total Tests:** 95

**Numbered Tests:** 11

**Unnumbered Tests:** 84

**Numbered Tests Missing Descriptions:** 0

**Numbering Mismatches:** 0

All numbered test numbers are unique.

This catalog lists all tests in the Swift/ObjC codebase.

| Test # | Function Name | Description | File |
|--------|---------------|-------------|------|
| test578 | `test578_equivalentIdenticalTags` | TEST578: Equivalent URNs with identical tag sets | Tests/TaggedUrnTests/CSTaggedUrnTests.m:1205 |
| test579 | `test579_notEquivalentWhenOneMoreSpecific` | TEST579: Non-equivalent URNs where one is more specific | Tests/TaggedUrnTests/CSTaggedUrnTests.m:1219 |
| test580 | `test580_comparableSpecializationChain` | TEST580: Comparable URNs on the same specialization chain | Tests/TaggedUrnTests/CSTaggedUrnTests.m:1233 |
| test581 | `test581_incomparableDifferentBranches` | TEST581: Incomparable URNs in different branches of the lattice | Tests/TaggedUrnTests/CSTaggedUrnTests.m:1250 |
| test582 | `test582_equivalentImpliesComparable` | TEST582: Equivalent implies comparable but not vice versa | Tests/TaggedUrnTests/CSTaggedUrnTests.m:1267 |
| test583 | `test583_prefixMismatchErrors` | TEST583: Prefix mismatch returns error for both relations | Tests/TaggedUrnTests/CSTaggedUrnTests.m:1293 |
| test584 | `test584_emptyTagsComparableToAll` | TEST584: Empty tag set is comparable to everything with same prefix | Tests/TaggedUrnTests/CSTaggedUrnTests.m:1310 |
| test586 | `test586_specialValues` | TEST586: Special values (*, !, ?) with isEquivalent and isComparable | Tests/TaggedUrnTests/CSTaggedUrnTests.m:1331 |
| test596 | `test596_builderWithPrefix` | TEST596: Builder with prefix verification | Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:255 |
| test597 | `test597_builderPreservesCase` | TEST597: Builder case preservation for quoted values | Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:267 |
| test598 | `test598_builderRejectsEmptyValue` | TEST598: Builder rejects empty tag values (matches Rust's Result error) | Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:281 |
| | | | |
| unnumbered | `testBuilder` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:273 |
| unnumbered | `testBuilderBasicConstruction` |  | Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:16 |
| unnumbered | `testBuilderBuildAllowEmpty` |  | Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:104 |
| unnumbered | `testBuilderComplex` |  | Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:128 |
| unnumbered | `testBuilderCustomPrefix` |  | Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:191 |
| unnumbered | `testBuilderCustomTags` |  | Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:64 |
| unnumbered | `testBuilderEmptyBuild` |  | Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:94 |
| unnumbered | `testBuilderFluentAPI` |  | Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:30 |
| unnumbered | `testBuilderJSONOutput` |  | Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:48 |
| unnumbered | `testBuilderMatchingWithBuiltUrn` |  | Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:203 |
| unnumbered | `testBuilderPreservesCase` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:747 |
| unnumbered | `testBuilderSingleTag` |  | Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:112 |
| unnumbered | `testBuilderStaticFactory` |  | Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:182 |
| unnumbered | `testBuilderTagOverrides` |  | Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:80 |
| unnumbered | `testBuilderWildcards` |  | Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:161 |
| unnumbered | `testBuilderWithCustomPrefix` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:289 |
| unnumbered | `testCanonicalStringFormat` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:57 |
| unnumbered | `testCoding` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:396 |
| unnumbered | `testCodingWithCustomPrefix` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:415 |
| unnumbered | `testConvenienceMethods` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:261 |
| unnumbered | `testCopying` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:434 |
| unnumbered | `testCustomPrefix` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:30 |
| unnumbered | `testDirectionalAccepts` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:232 |
| unnumbered | `testDuplicateKeyRejection` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:521 |
| unnumbered | `testEmptyTaggedUrn` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:445 |
| unnumbered | `testEmptyValueStillError` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:1146 |
| unnumbered | `testEmptyWithCustomPrefix` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:476 |
| unnumbered | `testEmptyWithPrefixMethod` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:485 |
| unnumbered | `testEquality` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:377 |
| unnumbered | `testEqualityDifferentPrefix` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:388 |
| unnumbered | `testExtendedCharacterSupport` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:493 |
| unnumbered | `testHasTagCaseSensitive` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:730 |
| unnumbered | `testInvalidCharacters` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:139 |
| unnumbered | `testInvalidEscapeSequenceError` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:668 |
| unnumbered | `testInvalidTaggedUrn` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:119 |
| unnumbered | `testMatchingDifferentPrefixesError` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:775 |
| unnumbered | `testMatchingSemantics_Test1_ExactMatch` | These 9 tests verify the exact matching semantics from RULES.md Sections 12-17 All implementations (Rust, Go, JS, ObjC) must pass these identically | Tests/TaggedUrnTests/CSTaggedUrnTests.m:802 |
| unnumbered | `testMatchingSemantics_Test2_InstanceMissingTag` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:819 |
| unnumbered | `testMatchingSemantics_Test3_UrnHasExtraTag` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:845 |
| unnumbered | `testMatchingSemantics_Test4_RequestHasWildcard` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:862 |
| unnumbered | `testMatchingSemantics_Test5_UrnHasWildcard` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:879 |
| unnumbered | `testMatchingSemantics_Test6_ValueMismatch` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:896 |
| unnumbered | `testMatchingSemantics_Test7_PatternHasExtraTag` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:913 |
| unnumbered | `testMatchingSemantics_Test8_EmptyPatternMatchesAnything` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:932 |
| unnumbered | `testMatchingSemantics_Test9_CrossDimensionConstraints` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:958 |
| unnumbered | `testMerge` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:352 |
| unnumbered | `testMergePrefixMismatch` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:365 |
| unnumbered | `testMissingTagHandling` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:190 |
| unnumbered | `testMixedQuotedUnquoted` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:651 |
| unnumbered | `testNumericKeyRestriction` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:530 |
| unnumbered | `testPrefixCaseInsensitive` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:41 |
| unnumbered | `testPrefixMismatchError` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:177 |
| unnumbered | `testPrefixRequired` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:68 |
| unnumbered | `testQuotedValueEscapeSequences` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:635 |
| unnumbered | `testQuotedValueSpecialChars` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:612 |
| unnumbered | `testQuotedValuesPreserveCase` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:584 |
| unnumbered | `testRoundTripQuoted` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:718 |
| unnumbered | `testRoundTripSimple` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:707 |
| unnumbered | `testSemanticEquivalence` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:761 |
| unnumbered | `testSerializationSmartQuoting` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:676 |
| unnumbered | `testSpecificity` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:210 |
| unnumbered | `testSubset` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:344 |
| unnumbered | `testTagMatching` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:148 |
| unnumbered | `testTaggedUrnCreation` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:16 |
| unnumbered | `testTrailingSemicolonEquivalence` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:91 |
| unnumbered | `testUnquotedValuesLowercased` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:562 |
| unnumbered | `testUnterminatedQuoteError` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:660 |
| unnumbered | `testValuelessNumericKeyStillRejected` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:1189 |
| unnumbered | `testValuelessTagAtEnd` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:1029 |
| unnumbered | `testValuelessTagCaseNormalization` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:1134 |
| unnumbered | `testValuelessTagDirectionalAccepts` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:1159 |
| unnumbered | `testValuelessTagEquivalenceToWildcard` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:1040 |
| unnumbered | `testValuelessTagInPattern` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:1077 |
| unnumbered | `testValuelessTagMatching` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:1053 |
| unnumbered | `testValuelessTagMixedWithValued` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:1015 |
| unnumbered | `testValuelessTagParsing` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:128 |
| unnumbered | `testValuelessTagParsingMultiple` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:1002 |
| unnumbered | `testValuelessTagParsingSingle` | VALUE-LESS TAG TESTS Value-less tags are equivalent to wildcard tags (key=*) | Tests/TaggedUrnTests/CSTaggedUrnTests.m:991 |
| unnumbered | `testValuelessTagRoundtrip` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:1121 |
| unnumbered | `testValuelessTagSpecificity` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:1109 |
| unnumbered | `testWildcardRestrictions` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:503 |
| unnumbered | `testWildcardTag` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:324 |
| unnumbered | `testWithTag` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:301 |
| unnumbered | `testWithoutTag` |  | Tests/TaggedUrnTests/CSTaggedUrnTests.m:313 |
---

## Unnumbered Tests

The following tests are cataloged but do not currently participate in numeric test indexing.

- `testBuilder` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:273
- `testBuilderBasicConstruction` — Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:16
- `testBuilderBuildAllowEmpty` — Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:104
- `testBuilderComplex` — Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:128
- `testBuilderCustomPrefix` — Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:191
- `testBuilderCustomTags` — Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:64
- `testBuilderEmptyBuild` — Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:94
- `testBuilderFluentAPI` — Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:30
- `testBuilderJSONOutput` — Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:48
- `testBuilderMatchingWithBuiltUrn` — Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:203
- `testBuilderPreservesCase` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:747
- `testBuilderSingleTag` — Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:112
- `testBuilderStaticFactory` — Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:182
- `testBuilderTagOverrides` — Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:80
- `testBuilderWildcards` — Tests/TaggedUrnTests/CSTaggedUrnBuilderTests.m:161
- `testBuilderWithCustomPrefix` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:289
- `testCanonicalStringFormat` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:57
- `testCoding` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:396
- `testCodingWithCustomPrefix` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:415
- `testConvenienceMethods` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:261
- `testCopying` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:434
- `testCustomPrefix` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:30
- `testDirectionalAccepts` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:232
- `testDuplicateKeyRejection` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:521
- `testEmptyTaggedUrn` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:445
- `testEmptyValueStillError` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:1146
- `testEmptyWithCustomPrefix` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:476
- `testEmptyWithPrefixMethod` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:485
- `testEquality` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:377
- `testEqualityDifferentPrefix` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:388
- `testExtendedCharacterSupport` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:493
- `testHasTagCaseSensitive` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:730
- `testInvalidCharacters` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:139
- `testInvalidEscapeSequenceError` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:668
- `testInvalidTaggedUrn` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:119
- `testMatchingDifferentPrefixesError` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:775
- `testMatchingSemantics_Test1_ExactMatch` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:802
- `testMatchingSemantics_Test2_InstanceMissingTag` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:819
- `testMatchingSemantics_Test3_UrnHasExtraTag` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:845
- `testMatchingSemantics_Test4_RequestHasWildcard` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:862
- `testMatchingSemantics_Test5_UrnHasWildcard` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:879
- `testMatchingSemantics_Test6_ValueMismatch` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:896
- `testMatchingSemantics_Test7_PatternHasExtraTag` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:913
- `testMatchingSemantics_Test8_EmptyPatternMatchesAnything` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:932
- `testMatchingSemantics_Test9_CrossDimensionConstraints` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:958
- `testMerge` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:352
- `testMergePrefixMismatch` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:365
- `testMissingTagHandling` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:190
- `testMixedQuotedUnquoted` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:651
- `testNumericKeyRestriction` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:530
- `testPrefixCaseInsensitive` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:41
- `testPrefixMismatchError` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:177
- `testPrefixRequired` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:68
- `testQuotedValueEscapeSequences` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:635
- `testQuotedValueSpecialChars` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:612
- `testQuotedValuesPreserveCase` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:584
- `testRoundTripQuoted` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:718
- `testRoundTripSimple` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:707
- `testSemanticEquivalence` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:761
- `testSerializationSmartQuoting` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:676
- `testSpecificity` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:210
- `testSubset` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:344
- `testTagMatching` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:148
- `testTaggedUrnCreation` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:16
- `testTrailingSemicolonEquivalence` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:91
- `testUnquotedValuesLowercased` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:562
- `testUnterminatedQuoteError` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:660
- `testValuelessNumericKeyStillRejected` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:1189
- `testValuelessTagAtEnd` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:1029
- `testValuelessTagCaseNormalization` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:1134
- `testValuelessTagDirectionalAccepts` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:1159
- `testValuelessTagEquivalenceToWildcard` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:1040
- `testValuelessTagInPattern` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:1077
- `testValuelessTagMatching` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:1053
- `testValuelessTagMixedWithValued` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:1015
- `testValuelessTagParsing` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:128
- `testValuelessTagParsingMultiple` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:1002
- `testValuelessTagParsingSingle` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:991
- `testValuelessTagRoundtrip` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:1121
- `testValuelessTagSpecificity` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:1109
- `testWildcardRestrictions` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:503
- `testWildcardTag` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:324
- `testWithTag` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:301
- `testWithoutTag` — Tests/TaggedUrnTests/CSTaggedUrnTests.m:313

---

*Generated from Swift/ObjC source tree*
*Total tests: 95*
*Total numbered tests: 11*
*Total unnumbered tests: 84*
*Total numbered tests missing descriptions: 0*
*Total numbering mismatches: 0*
