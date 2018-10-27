//
//  CreateTodoViewController.swift
//  swTodo
//
//  Created by Masaaki Uno on 2018/10/19.
//  Copyright © 2018 Masaaki Uno. All rights reserved.
//

import UIKit

class CreateTodoViewController: UIViewController {
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var todoTitle: UITextField!
    @IBOutlet weak var todoDeadline: UIDatePicker!
    @IBOutlet weak var todoDetail: UITextView!
    
    @IBAction func createButtonTapped(_ sender: UIButton) {
        print("作成ボタンがタップされた")
        // TODO作成
        if (!isValideTodo()) {
            return
        }
        guard let subject = todoTitle.text else {
            return
        }
        guard let body = todoDetail.text else {
            return
        }
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        let limit = formatter.string(from: todoDeadline.date)
        
        do {
            let uuid: String = appDelegate.getUuid()
            let todo = PostTodo(subject: subject, body: body, limit: limit)
            let bodyParam = try JSONEncoder().encode(todo)
            appDelegate.callApi(url: "/todo/create", uuid: uuid, bodyParam: bodyParam, completionHandler: {
                (data, response, error) -> Void in
//                if let data = data {
//                    do {
//                        let decoder = JSONDecoder()
//                        let feed = try decoder.decode(JsonFeed.self, from: data)
//                        if let todos = feed.results.todo {
//                            self.todos = todos
//                        }
//                    } catch {
//                        print("Serialize Error")
//                    }
//                } else {
//                    // [TODO]エラーメッセージ表示
//                    print(error ?? "Error")
//                }
//                DispatchQueue.main.async {
//                    // アニメーション終了
//                    self.activityIndicatorView.stopAnimating()
//                }
            })
        } catch {
            print("encode error")
        }
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
    override func viewDidLoad() {
        // TODO本文入力エリアに枠線をつける
        todoDetail.layer.borderWidth = 1
        todoDetail.layer.borderColor = UIColor.lightGray.cgColor
        
        // Datepicker
        todoDeadline.layer.borderWidth = 1
        todoDeadline.layer.borderColor = UIColor.lightGray.cgColor
    }
}
