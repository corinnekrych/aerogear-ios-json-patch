/**
* JBoss, Home of Professional Open Source
* Copyright Red Hat, Inc., and individual contributors.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* 	http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/


import UIKit
import XCTest
import AeroGearJsonPatch

class JsonPointerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    var jsonRFC6901: JsonNode =  [
        "foo": ["bar", "baz"],
        "": 0,
        "a/b": 1,
        "c%d": 2,
        "e^f": 3,
        "g|h": 4,
        "i\\j": 5,
        "k\"l": 6,
        " ": 7,
        "m~n": 8
    ]
    
    func testGetFooElement() {
        let path = "/foo"
        let node:JsonPointer<[String]>? = findJsonPath(path, jsonRFC6901)
        if let node = node {
            if let value = node.get() {
                XCTAssertTrue(value[0] == "bar")
            }
        }
    }
   
    func testFootElement() {
        let path = ""
        let node:JsonPointer<JsonNode>? = findJsonPath(path, jsonRFC6901)
        if let node = node {
            let value:JsonNode = node.get()!
            let count = (value["foo"] as [String]).count
            XCTAssertTrue(count == 2)
        }
    }
    
    func testFindLastElement() {
        let path = "/foo/bar"
        let json: [String: AnyObject] = ["foo": ["bar": "yo"], "boo": 2]
        let node: JsonPointer<String>? = findJsonPath(path, json)
        if let node = node {
            let value = node.get()
            XCTAssertTrue(value == "yo")
        }
    }
    
    func testFindIntElement() {
        let path = "/foo/boo"
        let json: [String: AnyObject] = ["foo": ["bar": "yo"], "boo": 2]
        let node: JsonPointer<Int>? = findJsonPath(path, json)
        if let node = node {
            let value = node.get()
            XCTAssertTrue(value == 2)
        }
    }

    
    func testNoElementFound() {
        let path = "/foor/bar"
        let json: [String: AnyObject] = ["foo": ["bar": "yo"], "boo": 2]
        let node: JsonPointer<String>? = findJsonPath(path, json)
        XCTAssertTrue(node == nil)
    }
    
    func testElementAsDictionary() {
        let path = "/foo/bar"
        let json: [String: AnyObject] = ["foo": ["bar": ["elt1": "elt2"]], "boo": 2]
        let node: JsonPointer<[String: AnyObject]>? = findJsonPath(path, json)
        if let node = node {
            let value = node.get()
            if let value = value {
                XCTAssertTrue(value["elt1"] as String == "elt2")
            }
        }
    }
    
    func testFindArrayElement() {
        let path = "/foo/bar/1/s7"
        let json: [String: AnyObject] = ["foo": ["bar": [["s1":"s2", "s3": "s4"], ["s5":"s6", "s7": "s8"]]], "boo": 2]
        let node:JsonPointer<String>? = findJsonPath(path, json)
        if let node = node {
            let value = node.get()
            if let value = value {
                XCTAssertTrue(value == "s8")
            }
        } else {
            XCTFail("node /foo/bar/1/s7 should not be nil")
        }
    }
    
    func testFindArrayElementAsInt() {
        let path = "/foo/bar/1"
        let json: [String: AnyObject] = ["foo": ["bar": [Int(1), 2]], "boo": 2]
        let node:JsonPointer<Int>? = findJsonPath(path, json)
        if let node = node {
            let value = node.get()
            if let value = value {
                XCTAssertTrue(value == 2)
            }
        } else {
            XCTFail("node /foo/bar/1 should not be nil")
        }
    }
    
    func testFindArrayElementOutOfBound() {
        let path = "/foo/bar/50"
        let json: [String: AnyObject] = ["foo": ["bar": [1, 2]], "boo": 2]
        let node:JsonPointer<Int>? = findJsonPath(path, json)
        XCTAssertTrue(node == nil)
    }
    
    func testFindArrayElementFinal() {
        let path = "/foo/bar/1"
        let json: [String: AnyObject] = ["foo": ["bar": ["elt1", "elt2"]], "boo": 2]
        let node:JsonPointer<String>? = findJsonPath(path, json)
        
        if let value = node?.get() {
            XCTAssertTrue(value == "elt2")
        }        
    }
    
}
