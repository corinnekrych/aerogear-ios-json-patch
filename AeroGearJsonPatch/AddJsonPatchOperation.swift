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

public struct AddJsonPatchOperation: Printable {
    public let op: Operation
    public let path: JsonPointer<Unkown>
    public let value: JsonNode
    
    public init(path: JsonPointer<Unkown>, value: JsonNode) {
        self.op = Operation.Add
        self.path = path
        self.value = value
        //["op": Operation.Add.rawValue, "path": path]
    }
    /**
    Apply this operation to a JSON value
    
    :param: json node the value to patch
    :return: the patched value as json node
    */
    func apply(json:JsonNode) -> JsonNode {
        return [:]
    }
    
    public var description: String {
        return ""
    }
}

