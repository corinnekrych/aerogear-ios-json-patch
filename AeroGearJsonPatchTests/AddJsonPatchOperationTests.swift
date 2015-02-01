/**
*0 JBoss, Home of Professional Open Source
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
import SwiftyJSON
import AeroGearJsonPatch

class AddJsonPatchOperationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddObjectAlreadyExist() {
        let path = "/foo/bar"
        var node = JsonNode(["foo": ["bar": "yo"], "boo": 2])
        let valueToAdd = JsonNode(["winter": ["tempMin": 12]])
        
        let addOperation = AddJsonPatchOperation(path: path, value: valueToAdd)        
        let newObject = addOperation.apply(node)
        
        //XCTAssertTrue(newObject["foo"]["winter"]["tempMin"].intValue == 12)

    }
    
}