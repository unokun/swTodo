//
//  CreateMenuController.swift
//  swTodo
//
//  Created by Masaaki Uno on 2018/10/20.
//  Copyright © 2018 Masaaki Uno. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    let menuTitleStrings = ["一覧を表示", "ToDoを作成", "このアプリについて"]
    
    @IBOutlet weak var menuTitles: UITableView!
    
    @IBOutlet weak var menuView: UIView!
    
    @IBAction func itemTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTitles.dataSource = self
        menuTitles.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // クリックイベント
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.cellTapped(_:)))
        self.menuTitles.addGestureRecognizer(tapRecognizer)
        
        let menuPos = self.menuView.layer.position
        self.menuView.layer.position.x = -self.menuView.frame.width
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.menuView.layer.position.x = menuPos.x
        },
            completion: { bool in
        })
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            if touch.view?.tag == 1 {
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0,
                    options: .curveEaseIn,
                    animations: {
                        self.menuView.layer.position.x = -self.menuView.frame.width
                    },
                    completion: { bool in
                        self.dismiss(animated: true, completion: nil)
                    }
                )
            }
        }
    }
    @objc func cellTapped(_ recognizer: UITapGestureRecognizer) {
        // 押された位置でcellのPathを取得
        let point = recognizer.location(in: menuTitles)
        
        if let indexPath = menuTitles.indexPathForRow(at: point) {
            
            if recognizer.state == UIGestureRecognizer.State.ended  {
                // 長押しされた場合の処理
                let index = indexPath.row
                print("タップcellのindexPath:\(index)")

                if (index == 2) {
                    let alert: UIAlertController = UIAlertController(title: "通常は利用しているライブラリなどを表示します。ライブラリによってはライセンス上、アプリで利用していることを明記する必要がある場合が多いです。", message: "", preferredStyle:  UIAlertController.Style.actionSheet)
                    alert.addAction(
                        UIAlertAction(title: "閉じる", style: UIAlertAction.Style.default, handler: {
                            (action: UIAlertAction) -> Void in
                            // TODO
                            print("完了")
                        })
                    )
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                // 画面遷移
                var target: String = ""
                switch (index) {
                case 0:
                    target = "listTodo"
                case 1:
                    target = "createTodo"
                default:
                    target = "listTodo"
                }
                
                let storyboard: UIStoryboard = self.storyboard!
                let second = storyboard.instantiateViewController(withIdentifier: target)
                self.present(second, animated: true, completion: nil)
            }
        }
    }
    
}
extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitleStrings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = menuTitleStrings[indexPath.item]
        return cell
    }
    
    
}
extension MenuViewController: UITableViewDelegate {
    
}
