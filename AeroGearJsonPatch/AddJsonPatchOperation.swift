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

public class AddJsonPatchOperation: JsonPatchOperation {
    public var op: Operation
    public var path: JsonPath
    public var value: JsonNode
    
    public required init(path: JsonPath, value: JsonNode) {
        self.op = Operation.Add
        self.path = path
        self.value = value
    }
    
    /**
    Apply the ADD operation to a JSON node as described in:
    https://tools.ietf.org/html/rfc6902#section-4.1
    
    :param: json node the value to patch
    :return: the patched value as json node
    */
    public func apply(node:JsonNode) -> JsonNode {
        var pointer: JsonPointer? = findJsonPath(path, node)
        if pointer != nil { // element already exist, will be replaced
            //assert(pointer.isEmpty(), "ADD patch could not be applied")
            return pointer!.isArray ? addToArray(pointer!, node: node) : addToObject(pointer!, value: value)
        } else { // element not does already exist
            var paths = jsonPathAsList(path)
            var element = paths.removeLast()
            if let parentPointer = findJsonPath(path, node) {
                return parentPointer.isArray ? addToArray(parentPointer, node: node) : addToObject(parentPointer, value: node)
            } else {
                assert(true, "ADD patch could not be applied")
                return node
            }
        }
    }
    
    func addToArray(pointer: JsonPointer, node: JsonNode) -> JsonNode {
        
        return JsonNode(NSNull)
    }
    
    func addToObject(pointer: JsonPointer, value: JsonNode) -> JsonNode {
        println("Node::\(value)")
        var parent = pointer.parent
        println("Pointer.parent::\(parent)")
        parent = value
        println("NewNOde::\(parent)")
        return parent
        
    }
    
}

