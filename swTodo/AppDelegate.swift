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
    let TODOAPI_BASEURL = "https://sample-api.codecamp.jp/api/v1"
    let KEY_UUID = "uuid"
    
    var window: UIWindow?

    let userDefaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.completi
        userDefaults.register(defaults: [KEY_UUID : ""])
        
        if let uuid = userDefaults.string(forKey: KEY_UUID) {
            // uuidが登録済み
            if !uuid.isEmpty {
                return true
            }
        }
        
        // uuidをサーバーから取得する
        let parameters: [String: String] = [:]
        // uuid取得
        let headers: [String: String] = ["Content-Type": "application/json", "X-REQUEST-UUID":""]
        callApi(url: TODOAPI_BASEURL + "/uuid/issue", method: "POST", parameters: parameters, headers: headers, completionHandler: {
            (data, response, error) -> Void in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let feed = try decoder.decode(JsonFeed.self, from: data)
                    
                    if let uuid = feed.results.uuid {
                        print(uuid)
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

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
extension AppDelegate {
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
    ///   - urlString: <#urlString description#>
    ///   - method: <#method description#>
    ///   - parameters: <#parameters description#>
    ///   - headers: <#headers description#>
    ///   - completionHandler:
    ///   - bodyParam: <#headers description#>

    func callApi(url urlString: String, method: String, parameters: [String: String], headers: [String: String], bodyParam: Data? = nil, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var compnents = URLComponents(string: urlString)
        
        // parameters
        var queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        compnents?.queryItems = queryItems
        
        var request = URLRequest(url: (compnents?.url)!)
        request.httpMethod = method
        
        // header
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
