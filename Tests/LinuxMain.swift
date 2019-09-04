import XCTest

import CatalogueTests
import CatalogueKitTests

var tests = [XCTestCaseEntry]()
tests += CatalogueTests.allTests()
tests += CatalogueKitTests.allTests()
XCTMain(tests)
