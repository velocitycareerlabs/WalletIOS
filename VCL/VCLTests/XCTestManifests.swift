// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(VCLTests.allTests),
    ]
}
#endif
