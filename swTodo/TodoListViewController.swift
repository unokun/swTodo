//
//  TodoListViewController.swift
//  swTodo
//
//  Created by Masaaki Uno on 2018/10/20.
//  Copyright © 2018 Masaaki Uno. All rights reserved.
//

import UIKit
import Alamofire

class TodoListViewController: UIViewController {
    let BASE_URL = "http://localhost:3000"
    let URL_TODOLIST = "http://localhost:3000/todos"
    let URL_TODO = "http://localhost:3000/todo"

    @IBOutlet weak var todoListTableView: UITableView!
    var todos: [Todo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        todoListTableView.dataSource = self
        todoListTableView.delegate = self
        
        // 未完了TODO一覧取得
        getUncompletedTodos()
        
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
                
                let alert: UIAlertController = UIAlertController(title: todos[index].Title, message: "操作を選択してください", preferredStyle:  UIAlertController.Style.actionSheet)
                alert.addAction(
                    UIAlertAction(title: "完了", style: UIAlertAction.Style.default, handler: {
                        (action: UIAlertAction) -> Void in
                        let params : [String : String] = ["id": String(todo.Id), "title": todo.Title, "detail": todo.Detail, "deadline": todo.Deadline, "status": "1"]
                        
                        Alamofire.request(self.URL_TODO, method: .put, parameters: params).validate().responseJSON { response in
                            print("完了")
                            // 再描画
                            self.todoListTableView.reloadData()

                        }

                    })
                )
                // 削除
                alert.addAction(
                    UIAlertAction(title: "削除", style: UIAlertAction.Style.default, handler: {
                        (action: UIAlertAction) -> Void in
                        let params : [String : String] = ["id": String(todo.Id)]
                        
                        Alamofire.request(self.URL_TODO, method: .delete, parameters: params).validate().responseJSON { response in
                            print("削除")
                            // 再描画
                            self.todoListTableView.reloadData()

                        }
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
    
    func getUncompletedTodos() {
//        let params : [String : String] = [:]
        
        Alamofire.request(URL_TODOLIST).validate().responseJSON { response in
            guard let data = response.data else {
                return
            }
            let decoder = JSONDecoder()
            do {
                let response: TodoResponse = try decoder.decode(TodoResponse.self, from: data)
                print(response)
                
                self.todos = response.result
                // 再描画
                self.todoListTableView.reloadData()

            } catch {
                print(error)
            }
        }

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
        cell.textLabel?.text = todos[indexPath.item].Title
        // 複数行表示
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = todos[indexPath.item].Detail
        return cell
    }
//    func tableView(_ tableView: UITableView, _ didSelectRowAt: indexPath: IndexPath) {
//
//    }
    
}
extension TodoListViewController: UITableViewDelegate {
    
}
