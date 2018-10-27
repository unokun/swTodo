//
//  TodoListViewController.swift
//  swTodo
//
//  Created by Masaaki Uno on 2018/10/20.
//  Copyright © 2018 Masaaki Uno. All rights reserved.
//

import UIKit

class TodoListViewController: UIViewController {
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var todoListTableView: UITableView!
    var todos: [Todo] = []
    var activityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        todoListTableView.dataSource = self
        todoListTableView.delegate = self
        
        activityIndicatorView.center = view.center
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.color = .purple
        
        view.addSubview(activityIndicatorView)
        
        // 未完了TODO一覧取得
        getTodoList()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        // 長押しイベント
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.cellLongPressed(_:)))
        self.todoListTableView.addGestureRecognizer(longPressRecognizer)
        
    }
    
    @objc func cellLongPressed(_ recognizer: UILongPressGestureRecognizer) {
        // 押された位置でcellのPathを取得
        let point = recognizer.location(in: todoListTableView)
        
        if let indexPath = todoListTableView.indexPathForRow(at: point) {
            
            if recognizer.state == UIGestureRecognizer.State.began  {
                // 長押しされた場合の処理
                let index = indexPath.row
                let todo = self.todos[index]
                print("長押しされたcellのindexPath:\(index)")
                
                let alert: UIAlertController = UIAlertController(title: todos[index].subject, message: "操作を選択してください", preferredStyle:  UIAlertController.Style.actionSheet)
                alert.addAction(
                    UIAlertAction(title: "完了", style: UIAlertAction.Style.default, handler: {
                        (action: UIAlertAction) -> Void in
//                        let params : [String : String] = ["id": String(todo.id), "title": todo.Title, "detail": todo.Detail, "deadline": todo.Deadline, "status": "1"]
                        
//                        Alamofire.request(self.URL_TODO, method: .put, parameters: params).validate().responseJSON { response in
//                            print("完了")
//                            // 再描画
//                            self.todoListTableView.reloadData()
//
//                        }

                    })
                )
                // 削除
                alert.addAction(
                    UIAlertAction(title: "削除", style: UIAlertAction.Style.default, handler: {
                        (action: UIAlertAction) -> Void in
                        let params : [String : String] = ["id": String(todo.id)]
                        
//                        Alamofire.request(self.URL_TODO, method: .delete, parameters: params).validate().responseJSON { response in
//                            print("削除")
//                            // 再描画
//                            self.todoListTableView.reloadData()
//
//                        }
                    })
                )
                // キャンセル
                alert.addAction(
                    UIAlertAction(title: "　キャンセル", style: UIAlertAction.Style.cancel, handler: {
                        (action: UIAlertAction) -> Void in
                        print("キャンセル")
                    })
                )
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func getTodoList() {
        activityIndicatorView.startAnimating()
        let parameters: [String: String] = [:]
        let uuid = appDelegate.getUuid()
        let headers: [String: String] = ["Content-Type": "application/json", "X-REQUEST-UUID": uuid]
        appDelegate.callApi(url: appDelegate.getBaseUrl() + "/todo/list/1", method: "GET", parameters: parameters, headers: headers, completionHandler: {
            (data, response, error) -> Void in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let feed = try decoder.decode(JsonFeed.self, from: data)
                    if let todos = feed.results.todo {
                        self.todos = todos
                    }
                } catch {
                    print("Serialize Error")
                }
            } else {
                // [TODO]エラーメッセージ表示
                print(error ?? "Error")
            }
            DispatchQueue.main.async {
                // アニメーション終了
                self.activityIndicatorView.stopAnimating()
                // 再描画
                self.todoListTableView.reloadData()
            }
        })
//        DispatchQueue.global(qos: .default).async {
//            // 非同期処理などを実行
//            Thread.sleep(forTimeInterval: 5)
//
//            // 非同期処理などが終了したらメインスレッドでアニメーション終了
//            DispatchQueue.main.async {
//                // アニメーション終了
//                self.activityIndicatorView.stopAnimating()
//            }
//        }
//        let params : [String : String] = [:]
        
//        Alamofire.request(URL_TODOLIST).validate().responseJSON { response in
//            guard let data = response.data else {
//                return
//            }
//            let decoder = JSONDecoder()
//            do {
//                let response: TodoResponse = try decoder.decode(TodoResponse.self, from: data)
//                print(response)
//
//                self.todos = response.result
//                // 再描画
//                self.todoListTableView.reloadData()
//
//            } catch {
//                print(error)
//            }
//        }

//        todos.append(Todo(title: "Todo1", detail: "最初のTodo"))
//        todos.append(Todo(title: "Todo2", detail: "2番目の最初のTodo"))
//        todos.append(Todo(title: "Todo3", detail: "3番目の最初のTodo"))
    }

}
extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = todos[indexPath.item].subject
        // 複数行表示
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = todos[indexPath.item].body
        return cell
    }
//    func tableView(_ tableView: UITableView, _ didSelectRowAt: indexPath: IndexPath) {
//
//    }
    
}
extension TodoListViewController: UITableViewDelegate {
    
}
