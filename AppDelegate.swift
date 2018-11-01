//
//  AppDelegate.swift
//  swTodo
//
//  Created by Masaaki Uno on 2018/10/14.
//  Copyright © 2018 Masaaki Uno. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    // API基底URL
    let TODOAPI_BASEURL = "https://sample-api.codecamp.jp/api/v1"
    // userDeafultsに登録したUUIDのキー
    let KEY_UUID = "uuid"
    
    let userDefaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // uuid(userDefaults)の初期値を設定する
        // 値が入っている場合は何もしない
        userDefaults.register(defaults: [KEY_UUID : ""])
        
        // uuid(userDefaults)を取得する
        if let uuid = userDefaults.string(forKey: KEY_UUID) {
            // uuidが登録済みの場合：サーバーからの取得はしない
            if !uuid.isEmpty {
                return true
            }
        }
        
        // uuidをサーバーから取得する
        callApi(url: "/uuid/issue", completionHandler: {
            (data, response, error) -> Void in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let feed = try decoder.decode(JsonFeed.self, from: data)
                    
                    if let uuid = feed.results.uuid {
                        print(uuid)

                        // uuid(userDefaults)を保存する
                        self.userDefaults.set(uuid, forKey: self.KEY_UUID)
                        self.userDefaults.synchronize()
                    }
                    
                } catch {
                    print("Serialize Error")
                }
            } else {
                // [TODO]エラーメッセージ表示
                print(error ?? "Error")
            }
        })
        return true
    }
    
    // 使わないメソッドは削除する
//    func applicationWillResignActive(_ application: UIApplication) {
//    }
//
//    func applicationDidEnterBackground(_ application: UIApplication) {
//    }
//
//    func applicationWillEnterForeground(_ application: UIApplication) {
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//    }
//
//    func applicationWillTerminate(_ application: UIApplication) {
//    }

}
extension AppDelegate {
    /// API基底URLを取得する
    ///
    /// - Returns: API基底URL
    func getBaseUrl() -> String {
        return TODOAPI_BASEURL
    }
    
    /// UUID取得
    ///
    /// - Returns: UUID
    func getUuid() -> String {
        return self.userDefaults.string(forKey: KEY_UUID)!
    }
    
    /// TodoAPI呼び出し
    ///
    /// - Parameters:
    ///   - path: API基底からの相対パス
    ///   - method: HTTPメソッド(デフォルト：POST)
    ///   - uuid: X-REQUEST-UUIDに設定する値(デフォルト=空文字)
    ///   - bodyParam: bodyに登録するデータ
    ///   - completionHandler: データ取得時の処理ハンドラ

    func callApi(url path: String, method: String = "POST", uuid: String = "", bodyParam: Data? = nil, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {

        let urlString = TODOAPI_BASEURL + path
        let compnents = URLComponents(string: urlString)
        
        // parameters
        //        let parameters: [String: String] = [:]
//        var queryItems = [URLQueryItem]()
//        for (key, value) in parameters {
//            queryItems.append(URLQueryItem(name: key, value: value))
//        }
//        compnents?.queryItems = queryItems
        
        var request = URLRequest(url: (compnents?.url)!)
        request.httpMethod = method
        
        // header
        let headers: [String: String] = ["Content-Type": "application/json", "X-REQUEST-UUID": uuid]
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // body
        if let body = bodyParam {
            request.httpBody = body
        }

        let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
}
