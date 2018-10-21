//
//  CreateTodoViewController.swift
//  swTodo
//
//  Created by Masaaki Uno on 2018/10/19.
//  Copyright © 2018 Masaaki Uno. All rights reserved.
//

import UIKit

class CreateTodoViewController: UIViewController {
    
    @IBOutlet weak var todoTitle: UITextField!
    @IBOutlet weak var todoDeadline: UIDatePicker!
    @IBOutlet weak var todoDetail: UITextView!
    
    @IBAction func createButtonTapped(_ sender: UIButton) {
        print("作成ボタンがタップされた")
        // TODO作成
        if (!isValideTodo()) {
            return
        }
        let todo = Todo()
        todo.title = todoTitle.text!
        todo.detail = todoDetail.text!
        
        // [TODO]API通信
        // 閉じる
        // 一覧画面に遷移する
        let storyboard: UIStoryboard = self.storyboard!
        let second = storyboard.instantiateViewController(withIdentifier: "listTodo")
        self.present(second, animated: true, completion: nil)
    }
    
    func isValideTodo() -> Bool {
        // タイトル
        if let text = todoTitle.text {
            if text.isEmpty {
                // 警告メッセージ
                return false
            }
        } else {
            // 警告メッセージ
            return false
        }
        // 本文
        // 期日
        return true
    }
    func createTodo() -> Todo {
        let todo = Todo()
        if let title = todoTitle.text {
            todo.title = title
        }
        todo.detail = todoDetail.text
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        todo.deadline = formatter.string(from: todoDeadline.date)
        return todo
    }
    override func viewDidLoad() {
        // TODO本文入力エリアに枠線をつける
        todoDetail.layer.borderWidth = 1
        todoDetail.layer.borderColor = UIColor.lightGray.cgColor
        
        // Datepicker
        todoDeadline.layer.borderWidth = 1
        todoDeadline.layer.borderColor = UIColor.lightGray.cgColor
    }
}
