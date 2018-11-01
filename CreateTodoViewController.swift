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
        // 入力値チェック
        if (!isValideTodo()) {
            return
        }
        let subject = todoTitle.text!
        let body = todoDetail.text!
//        guard let subject = todoTitle.text else {
//            return
//        }
//        guard let body = todoDetail.text else {
//            return
//        }
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        let limit = formatter.string(from: todoDeadline.date)
        
        var success = false
        do {
            let uuid: String = appDelegate.getUuid()
            let todo = PostTodo(subject: subject, body: body, limit: limit)
            let bodyParam = try JSONEncoder().encode(todo)
            appDelegate.callApi(url: "/todo/create", uuid: uuid, bodyParam: bodyParam, completionHandler: {
                (data, response, error) -> Void in
                success = (data != nil)
//                if let data = data {
//                    success = true
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
                DispatchQueue.main.async {
                    self.showCreateTodoResult(success:  success)
                    // アニメーション終了
//                    self.activityIndicatorView.stopAnimating()
                }
            })
        } catch {
            print("encode error")
        }
    }
    
    func isValideTodo() -> Bool {
        // タイトル
        if let text = todoTitle.text {
            if text.isEmpty {
                showMessage(title: "タイトル", message: "TODOタイトルを入力してください", completionHandler: nil)
                return false
            }
            if text.count > 20 {
                showMessage(title: "タイトル", message: "TODOタイトルは20文字以内で入力してください", completionHandler: nil)
                return false
            }
        }
        // 本文
        if let text = todoDetail.text {
            if text.isEmpty {
                showMessage(title: "TODO内容", message: "TODO内容を入力してください", completionHandler: nil)
                return false
            }
            if text.count > 140 {
                showMessage(title: "TODO内容", message: "TODO内容は140文字以内で入力してください", completionHandler: nil)
                return false
            }
        }
        
        // 期日
        let now = Date()
        let limit = todoDeadline.date
        if limit.compare(now) != ComparisonResult.orderedDescending {
            showMessage(title: "期限", message: "未来を設定してください", completionHandler: nil)
            return false

        }

        return true
    }
    
    /// TODO作成結果をメッセージ表示する
    ///
    /// - Parameter success: TODO作成が成功したかどうか
    func showCreateTodoResult(success: Bool) {
        let message = success ? "TODO作成しました" : "TODO作成できませんでした"
        showMessage(title: "TODO", message: message, completionHandler: {
            () -> Void in
            DispatchQueue.main.async {
                // 一覧画面に遷移する
                if success {
                    let storyboard: UIStoryboard = self.storyboard!
                    let second = storyboard.instantiateViewController(withIdentifier: "listTodo")
                    self.present(second, animated: true, completion: nil)
                }
            }
        })
    }
    /// メッセージを表示する
    ///
    /// - Parameters:
    ///   - title: ダイアログのタイトル
    ///   - message: ダイアログのメッセージ
    ///   - completionHandler: OKボタン押下後の処理(nil可能)
    func showMessage(title: String, message: String, completionHandler: (() -> Void)?) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle:  UIAlertController.Style.actionSheet)
        alert.addAction(
            UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                (action: UIAlertAction) -> Void in
                completionHandler?()
            })
        )
        self.present(alert, animated: true, completion: nil)
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
