import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let APP_ID = "594edb25d4d027958bab5f006b34b074"
let WEATHER_URL = "https://api.openweathermap.org/data/2.5/weather"

struct JSONFeed: Codable {
    let weather: [weather]
    let main: main
    let id: String
    let name: String
}

struct weather: Codable {
    let main: String
    let description: String
}

struct main: Codable {
    let pressure: Int
    let humidity: Int
}

class URLSessionGetClient {

  func get(url urlString: String, queryItems: [URLQueryItem]? = nil) {
    var compnents = URLComponents(string: urlString)
    compnents?.queryItems = queryItems
    let url = compnents?.url
    let task = URLSession.shared.dataTask(with: url!) { data, response, error in
      if let data = data, let response = response {
        print(response)
        do {
          let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
          print(json)
        } catch {
          print("Serialize Error")
        }
      } else {
        print(error ?? "Error")
      }
    }

    task.resume()
  }

}

let urlSessionGetClient = URLSessionGetClient()
let queryItems = [URLQueryItem(name: "id", value: "2172797"),
                  URLQueryItem(name: "appid", value: APP_ID)]
urlSessionGetClient.get(url: WEATHER_URL, queryItems: queryItems)
