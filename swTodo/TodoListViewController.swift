//
//  TodoListViewController.swift
//  swTodo
//
//  Created by Masaaki Uno on 2018/10/20.
//  Copyright © 2018 Masaaki Uno. All rights reserved.
//

import UIKit

class TodoListViewController: UIViewController {
    @IBOutlet weak var todoListTableView: UITableView!
    var todos: [Todo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoListTableView.dataSource = self
        todoListTableView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        // 長押しイベント
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.cellLongPressed(_:)))
        self.todoListTableView.addGestureRecognizer(longPressRecognizer)
        
        // 未完了TODO一覧取得
        todos = getUncompletedTodos()
        
        // 再描画
        self.todoListTableView.reloadData()
    }
    
    @objc func cellLongPressed(_ recognizer: UILongPressGestureRecognizer) {
        // 押された位置でcellのPathを取得
        let point = recognizer.location(in: todoListTableView)
        
        if let indexPath = todoListTableView.indexPathForRow(at: point) {
            
            if recognizer.state == UIGestureRecognizer.State.began  {
                // 長押しされた場合の処理
                let index = indexPath.row
                print("長押しされたcellのindexPath:\(index)")
                
                let alert: UIAlertController = UIAlertController(title: todos[index].title, message: "操作を選択してください", preferredStyle:  UIAlertController.Style.actionSheet)
                alert.addAction(
                    UIAlertAction(title: "完了", style: UIAlertAction.Style.default, handler: {
                        (action: UIAlertAction) -> Void in
                        // TODO
                        print("完了")
                    })
                )
                // 削除
                alert.addAction(
                    UIAlertAction(title: "削除", style: UIAlertAction.Style.default, handler: {
                        (action: UIAlertAction) -> Void in
                        print("削除")
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
    
    func getUncompletedTodos() ->  [Todo] {
        var todos: [Todo] = []
        todos.append(Todo(title: "Todo1", detail: "最初のTodo"))
        todos.append(Todo(title: "Todo2", detail: "2番目の最初のTodo"))
        todos.append(Todo(title: "Todo3", detail: "3番目の最初のTodo"))
        return todos
    }

}
extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = todos[indexPath.item].title
        // 複数行表示
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = todos[indexPath.item].detail
        return cell
    }
//    func tableView(_ tableView: UITableView, _ didSelectRowAt: indexPath: IndexPath) {
//        
//    }
    
}
extension TodoListViewController: UITableViewDelegate {
    
}
