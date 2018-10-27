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
                        self.activityIndicatorView.startAnimating()
                        // API呼び出し
                        self.callUpdateTodoStatus(todo: todo, status: 2)
                    })
                )
                // 削除
                alert.addAction(
                    UIAlertAction(title: "削除", style: UIAlertAction.Style.default, handler: {
                        (action: UIAlertAction) -> Void in
                        self.activityIndicatorView.startAnimating()

                        // API呼び出し
                        self.callUpdateTodoStatus(todo: todo, status:3)
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
    
    /// API呼び出しを実施してTODOのステータスを更新する
    ///
    /// - Parameters:
    ///   - todo: Todo
    ///   - status: ステータス(1: 完了、2:削除)
    func callUpdateTodoStatus(todo: Todo, status: Int) {
        do {
            let todoStatus = TodoStatus(status: status)
            let bodyParam = try JSONEncoder().encode(todoStatus)
            // TODOのステータス更新
            let uuid = self.appDelegate.getUuid()
            self.appDelegate.callApi(url: "/todo/update/" + todo.id
                , uuid: uuid, bodyParam: bodyParam, completionHandler: {
                    (data, response, error) -> Void in
                    //
                    self.didTodoStatusUpdated(data: data, response: response, error: error);
            })
        } catch {
            print("encode error")
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - data: <#data description#>
    ///   - response: <#response description#>
    ///   - error: <#error description#>
    func didTodoStatusUpdated(data: Data?, response: URLResponse?, error: Error?) {
        //                                if let data = data {
        //                                    do {
        //                                        let decoder = JSONDecoder()
        //                                        let feed = try decoder.decode(JsonFeed.self, from: data)
        //                                        if let todos = feed.results.todo {
        //                                            self.todos = todos
        //                                        }
        //                                    } catch {
        //                                        print("Serialize Error")
        //                                    }
        //                                } else {
        //                                    // [TODO]エラーメッセージ表示
        //                                    print(error ?? "Error")
        //                                }
        // メインスレッドでの処理
        DispatchQueue.main.async {
            // アニメーション終了
            self.activityIndicatorView.stopAnimating()
            //
            self.getTodoList()
        }
    }
    
    /// TODO一覧を取得
    func getTodoList() {
        activityIndicatorView.startAnimating()
        let uuid = appDelegate.getUuid()
        appDelegate.callApi(url: "/todo/list/1", method: "GET", uuid: uuid, completionHandler: {
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
            // メインスレッドでの処理
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
//              todos.append(Todo(title: "Todo1", detail: "最初のTodo"))
//              todos.append(Todo(title: "Todo2", detail: "2番目の最初のTodo"))
//              todos.append(Todo(title: "Todo3", detail: "3番目の最初のTodo"))
        
//            // 非同期処理などが終了したらメインスレッドでアニメーション終了
//            DispatchQueue.main.async {
//                // アニメーション終了
//                self.activityIndicatorView.stopAnimating()
//            }
//        }
    }
}
//
// ListView
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
