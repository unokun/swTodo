//
//  Todo.swift
//  swTodo
//
//  Created by Masaaki Uno on 2018/10/14.
//  Copyright © 2018 Masaaki Uno. All rights reserved.
//

import Foundation

class Todo {
    var title = ""
    var detail = ""
    var deadline = ""
    
    // TODO: enum
    // 新規： 0
    // 完了： 1
    var status = 0
    
    init() {
        
    }
    init(title: String, detail: String) {
        self.title = title
        self.detail = detail
    }
}
