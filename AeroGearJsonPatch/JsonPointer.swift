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

public typealias JsonNode = JSON

public enum ReferenceToken {
    case StringToken(String)
    case IntToken(Int)
}
public typealias JsonPath = String

public struct JsonPointer {
    public let parent: JsonNode
    let key: ReferenceToken
    
    public func keyAsString() -> String {
        switch key {
        case .StringToken(let value):
            return value
        case .IntToken(let index):
            return String(index)
        }
    }
    
    public func get() -> JsonNode {
        switch key {
        case .StringToken(let value) where value == "":
            return parent
        case .IntToken(let index):
            let array: [AnyObject] = (parent.object as! [String: AnyObject]).values.first as! [AnyObject]
            return JsonNode(array[index])
        case .StringToken(let value) :
            return parent[value]
        }
    }
    
    public func isEmpty() -> Bool {
        return parent == nil
    }
    
    public var isArray: Bool {
        get {
            switch key {
            case .IntToken:
                return true
            case .StringToken:
                return false
            }
        }
    }
}

// TODO escape
public func jsonPathAsList(path: String) -> [String] {
    if path == "" {
        return [""]
    }
    return path.characters.split {$0 == "/"}.map{String($0)}
}

public func findJsonPath(path: String, target: JsonNode) -> JsonPointer? {
    let pathList = jsonPathAsList(path)
    return findJsonPath(pathList, target: target)
}

public func findJsonPath(path: [String], target: JsonNode) -> JsonPointer? {
    if path.count == 1 && path[0] == "" {
        return JsonPointer(parent: target, key: .StringToken(""))
    }
    return findSubset(path, current: target)
}

private func findSubset(pathList: [String], current: JsonNode) -> JsonPointer? {
    var copyPathList = pathList
    let pathToLook = copyPathList.removeAtIndex(0)
    let value = current[pathToLook]
    
    if value != JSON.null {
        if !copyPathList.isEmpty {
            // Array case
            if let valueArray = value.array {
                let nextPath = copyPathList.removeAtIndex(0)
                if let nextInt = Int(nextPath) {
                    if nextInt >= valueArray.count { // array out of bound
                        return nil
                    }
                    if copyPathList.isEmpty { // array is a leaf
                        return JsonPointer(parent: current, key: .IntToken(nextInt))
                    } else { // array of object
                        return findSubset(copyPathList, current: valueArray[nextInt] as JsonNode)
                    }
                }
            }
            // Dictionary
            if  value.dictionary != nil {
                return findSubset(copyPathList, current: value)
                
            }
        } else {// copyPathList.isEmpty == true
            // Last search element
            return JsonPointer(parent: current, key: .StringToken(pathToLook))
        }
    } 
    return nil
}
/*
private func remove(path: [String], target: JsonNode) -> JsonNode {
    var newNode = target
    let toBeRemoved = findJsonPath(path, target: target)
    newNode.reduce(JsonNode(), combine: { (acc: JsonNode, elt: JsonNode) -> JsonNode in
        acc.append(elt)
    })
    return newNode
}
*/
