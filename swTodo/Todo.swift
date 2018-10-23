//
//  Todo.swift
//  swTodo
//
//  Created by Masaaki Uno on 2018/10/14.
//  Copyright © 2018 Masaaki Uno. All rights reserved.
//

import Foundation

struct TodoResponse: Codable {
    var count = 0
    let result: [Todo]
}
    
class Todo: Codable {
    var Id = 0
    var Title = ""
    var Detail = ""
    var Deadline = ""
    
    // TODO: enum
    // 新規： 0
    // 完了： 1
    var Status = "0"
    
    init() {
        
    }
    init(title: String, detail: String) {
        self.Title = title
        self.Detail = detail
    }
    init(title: String, detail: String, deadline: String) {
        self.Title = title
        self.Detail = detail
        self.Deadline = deadline
    }
}
