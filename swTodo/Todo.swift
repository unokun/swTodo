//
//  Todo.swift
//  swTodo
//
//  Created by Masaaki Uno on 2018/10/14.
//  Copyright © 2018 Masaaki Uno. All rights reserved.
//

import Foundation

struct JsonFeed: Codable {
    let results: Results
}
struct Results: Codable {
    let uuid: String?
    let todo: [Todo]?
}

struct Todo: Codable {
    let id: String
    let subject: String
    let body: String
    let limit: String
    let status: Int
}

struct PostTodo: Codable {
    let subject: String
    let body: String
    let limit: String
}

struct TodoStatus: Codable {
    let status: Int
}
