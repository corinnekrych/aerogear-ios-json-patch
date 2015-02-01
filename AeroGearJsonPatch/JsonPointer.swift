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
import SwiftyJSON

public typealias JsonNode = JSON //[String: AnyObject]

public enum ReferenceToken {
    case StringToken(String)
    case IntToken(Int)
}
public typealias JsonPath = String

public struct JsonPointer {
    public let parent: JsonNode?
    let key: ReferenceToken
    
    public func get() -> JsonNode? {
        if let parent = parent {
            switch key {
            case .StringToken(let value) where value == "":
                return parent
            case .IntToken(let index):
                let array: [AnyObject] = (parent.object as [String: AnyObject]).values.first as [AnyObject]
                return JsonNode(array[index])
            case .StringToken(let value) :
                return parent[value]
            }
        }
        return nil
    }
}

// TODO escape
func getJsonPathAsList(path: String) -> [String] {
    if path == "" {
        return [""]
    }
    return split(path) {$0 == "/"}
}

public func findJsonPath(path: String, target: JsonNode) -> JsonPointer? {
    let pathList = getJsonPathAsList(path)
    if pathList.count == 1 && pathList[0] == "" {
        return JsonPointer(parent: target, key: .StringToken(""))
    }
    return findSubset(pathList, target)
}

private func findSubset(pathList: [String], current: JsonNode) -> JsonPointer? {
    var copyPathList = pathList
    let pathToLook = copyPathList.removeAtIndex(0)
    let value = current[pathToLook]
    
    if value != JSON.nullJSON {
        // Array case
        if let valueArray = value.array {
            if !copyPathList.isEmpty {
                let nextPath = copyPathList.removeAtIndex(0)
                if let nextInt = nextPath.toInt() {
                    if nextInt >= valueArray.count { // array out of bound
                        return nil
                    }
                    if copyPathList.isEmpty { // array is a leaf
                        return JsonPointer(parent: current, key: .IntToken(nextInt))
                    } else { // array of object
                        return findSubset(copyPathList, valueArray[nextInt] as JsonNode)
                    }
                }
            }
        }
        // Dictionary
        if  value.dictionary != nil {
            if !copyPathList.isEmpty {
                return findSubset(copyPathList, value)
            }
        }
        // Leaf
        if (copyPathList.isEmpty) {
            return JsonPointer(parent: current, key: .StringToken(pathToLook))
        }
    } 
    return nil
}
