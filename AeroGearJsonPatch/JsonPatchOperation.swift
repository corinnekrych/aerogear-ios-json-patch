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
import Foundation

public enum Operation: String {
    case Add = "add"
    case Remove = "remove"
    case Replace = "replace"
    case Move = "move"
    case Copy = "copy"
    case Test = "test"
}

public protocol JsonPatchOperation {
    var op: Operation {get set}
    var path: JsonPath {get set}
    var value: JsonNode {get set}
    
    init(path: JsonPath, value: JsonNode)
    /**
    Apply this operation to a JSON value
    
    :param: node the value to patch
    :return: the patched value as json node
    */
    func apply(node:JsonNode) -> JsonNode
}

