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

public typealias JsonNode = [String: AnyObject]

public enum ReferenceToken {
    case StringToken(String)
    case IntToken(Int)
}
public typealias JsonPath = String

/**
Json Pointer as described in https://tools.ietf.org/html/rfc6901:
a string syntax for identifying a specific value within a JSON document.
*/
public struct JsonPointer<T: Json> {
    public var parent: JsonNode?
    let key: ReferenceToken
    
    public func get() -> T? {
        if let parent = parent {
            switch key {
            case .StringToken(let value) where value == "":
                return parent as? T
            case .IntToken(let index):
                let array: [AnyObject] = parent.values.first as [AnyObject]
                return array[index] as? T
            case .StringToken(let value) :
                return parent[value] as? T
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

public func findJsonPath<T: Json>(path: String, target: JsonNode) -> JsonPointer<T>? {
    let pathList = getJsonPathAsList(path)
    if pathList.count == 1 && pathList[0] == "" {
        return JsonPointer(parent: target, key: .StringToken(""))
    }
    return findSubset(pathList, target)
}

private func findSubset<T: Json>(pathList: [String], current: JsonNode) -> JsonPointer<T>? {
    var copyPathList = pathList
    let pathToLook = copyPathList.removeAtIndex(0)
    let value: AnyObject? = current[pathToLook]
    
    if value != nil {
        // Array case
        if let valueArray = value as? [AnyObject] {
            if !copyPathList.isEmpty {
                let nextPath = copyPathList.removeAtIndex(0)
                if let nextInt = nextPath.toInt() {
                    if nextInt >= valueArray.count { // array out of bound
                        return nil
                    }
                    if copyPathList.isEmpty { // array is a leaf
                        return JsonPointer<T>(parent: current, key: .IntToken(nextInt))
                    } else { // array of object
                        return findSubset(copyPathList, valueArray[nextInt] as JsonNode)
                    }
                }
            }
        }
        // Dictionary
        if (value is [String: AnyObject] && !copyPathList.isEmpty) {
            return findSubset(copyPathList, value! as JsonNode)
        }
        // Leaf
        if (copyPathList.isEmpty) {
            return JsonPointer<T>(parent: current, key: .StringToken(pathToLook))
        }
    } 
    return nil
}
