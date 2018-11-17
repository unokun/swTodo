//
//  CreateTodoViewController.swift
//  swTodo
//
//  Created by Masaaki Uno on 2018/10/19.
//  Copyright © 2018 Masaaki Uno. All rights reserved.
//
// datepicker
// https://qiita.com/iritec/items/f05c79590640e6ebbd85
// https://www.egao-inc.co.jp/programming/swift_uidatepicker/
//
// 日付操作(Date, Calendar, DateComponents)
// https://qiita.com/isom0242/items/e83ab77a3f56f66edd2f
//
import UIKit

class CreateTodoViewController: UIViewController {
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var todoTitle: UITextField!
//    @IBOutlet weak var todoDeadline: UIDatePicker!
    @IBOutlet weak var todoDetail: UITextView!
    
    @IBOutlet weak var todoLimitDate: UITextField!
    var toolBar: UIToolbar!
    
    override func viewDidLoad() {
        // 本文入力エリアに枠線をつける
        todoDetail.layer.borderWidth = 1
        todoDetail.layer.borderColor = UIColor.lightGray.cgColor
        
        // 日付picker用ツールバー
        toolBar = UIToolbar()
        toolBar.sizeToFit()
        // 右寄せ
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let toolBarButton  = UIBarButtonItem(title: "閉じる", style: .plain, target: self, action: #selector(closeButtonTapped))
        toolBar.items = [spacelItem, toolBarButton]
        todoLimitDate.inputAccessoryView = toolBar
        
    }

    // datepicker関連処理
    // 「閉じる」ボタンタップ
    @objc func closeButtonTapped() {
        todoLimitDate.resignFirstResponder()
    }
    
    @IBAction func todoLimitEdittingEnd(_ sender: UITextField) {

    }
    
    
    /// Todo期限入力フィールドのイベント：編集開始（フォーカスイン）
    /// datepickerを表示する
    /// - Parameter sender: <#sender description#>
    @IBAction func todoLimitEdittingBegin(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControl.Event.valueChanged)
        
        // Todo期限入力フィールドの値で日付を初期化する
        if let text = todoLimitDate.text {
            var date = Date()
            if !text.isEmpty {
                let formatter = ISO8601DateFormatter()
                formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")!
                date = formatter.date(from: text)!
            }
            datePickerView.date = date
        }
    }
    
    /// Datepickerのイベント：値が変更された
    /// textFieldに選択された日付をセットする
    /// - Parameter sender: <#sender description#>
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        todoLimitDate.text = convertISO8601DateFormatString(date: sender.date)
    }
    
    /// 日付をISO08601フォーマット文字列に変換する(時分秒は0にする)
    ///
    /// - Parameter date: <#date description#>
    /// - Returns: <#return value description#>
    func convertISO8601DateFormatString(date: Date) -> String {
        let tzId  = "Asia/Tokyo"
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: tzId)!
        let compornets = calendar.dateComponents([.year, .month, .day], from: date)
        
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(identifier: tzId)!
        return formatter.string(from: calendar.date(from: compornets)!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // キーボードをしまう(フォーカスアウト)
        if todoTitle.isFirstResponder {
            todoTitle.resignFirstResponder()
        }
        if todoDetail.isFirstResponder {
            todoDetail.resignFirstResponder()
        }
    }
    @IBAction func createButtonTapped(_ sender: UIButton) {
        print("作成ボタンがタップされた")
        // 入力値チェック
        if (!isValideTodo()) {
            return
        }
        let subject = todoTitle.text!
        let body = todoDetail.text!
        let limit = todoLimitDate.text!
        
        var success = false
        do {
            let uuid: String = appDelegate.getUuid()
            let todo = PostTodo(subject: subject, body: body, limit: limit)
            let bodyParam = try JSONEncoder().encode(todo)
            appDelegate.callApi(url: "/todo/create", uuid: uuid, bodyParam: bodyParam, completionHandler: {
                (data, response, error) -> Void in
                success = (data != nil)
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
        if let text = todoLimitDate.text {
            if text.isEmpty {
                showMessage(title: "TODO期限", message: "期限を入力してください", completionHandler: nil)
                return false
            }
            let formatter = ISO8601DateFormatter()
            formatter.timeZone = TimeZone.current
            let now = formatter.string(from: Date())
            if text.compare(now) != ComparisonResult.orderedDescending {
                showMessage(title: "期限", message: "未来を設定してください", completionHandler: nil)
                return false
            }
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
}
