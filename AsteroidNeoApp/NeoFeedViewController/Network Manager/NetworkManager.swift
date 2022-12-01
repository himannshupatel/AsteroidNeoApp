//
//  NetworkManager.swift
//  AsteroidNeoApp
//
//  Created by HimAnshu Patel on 28/11/22.
//

import Foundation

let BASE_URL = "https://api.nasa.gov/neo/rest/v1/feed?"
let API_KEY = "HjQfTWOtzquAiG3hOO968avAt5JxjaBd9cy3XT3x"

// MARK: - fetchNeoFeeds - API
//---------------------------------------------------------------------------------------------------------------------------------------------
func fetchNeoFeeds(startDate: String, endDate: String, completionHandler: @escaping (NeoFeeds?) -> Void) {
    let url = URL(string: BASE_URL + "start_date=\(startDate)&end_date=\(endDate)&api_key=\(API_KEY)")!

    let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
      if let error = error {
        print("Error with fetching feeds: \(error)")
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
          print("Error with the response, unexpected status code")
        return
      }
        
      if let data = data,
        let filmSummary = try? JSONDecoder().decode(NeoFeeds.self, from: data) {
        completionHandler(filmSummary)
      } else {
          completionHandler(nil)
      }
    })
    task.resume()
  }
