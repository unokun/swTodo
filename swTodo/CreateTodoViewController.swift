//
//  CreateTodoViewController.swift
//  swTodo
//
//  Created by Masaaki Uno on 2018/10/19.
//  Copyright © 2018 Masaaki Uno. All rights reserved.
//

import UIKit

class CreateTodoViewController: UIViewController {
    
    @IBAction func createButtonTapped(_ sender: UIButton) {
        print("作成ボタンがタップされた")
        // TODO作成
        // API通信
        // 閉じる
        // 一覧画面に遷移する
        let storyboard: UIStoryboard = self.storyboard!
        let second = storyboard.instantiateViewController(withIdentifier: "listTodo")
        self.present(second, animated: true, completion: nil)
    }
}
