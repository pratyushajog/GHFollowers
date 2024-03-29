//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Pratyusha Joginipally on 10/17/23.
//

import UIKit

class NetworkManager {
  static let shared = NetworkManager()
  let cache = NSCache<NSString, UIImage>()

  private let baseUrl = "https://api.github.com/users/"

  private init() {}

  func getFollowers(for username: String, page: Int, completed: @escaping ([Follower]?, ErrorMessage?) -> Void) {
    let endpoint = baseUrl + "\(username)/followers?per_page=100&page=\(page)"

    guard let url = URL(string: endpoint) else {
      completed(nil, .invalidUsername)
      return
    }

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      if let _ = error {
        completed(nil, .unableToComplete)
        return
      }

      guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        completed(nil, .invalidResponse)
        return
      }

      guard let data = data else {
        completed(nil, .invalidData)
        return
      }

      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let followers = try decoder.decode([Follower].self, from: data)
        completed(followers, nil)
      } catch {
        completed(nil, .invalidData)
      }
    }

    task.resume()
  }

  func getUserInfo(for username: String, completed: @escaping (User?, ErrorMessage?) -> Void) {
    let endpoint = baseUrl + "\(username)"

    guard let url = URL(string: endpoint) else {
      completed(nil, .invalidUsername)
      return
    }

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      if let _ = error {
        completed(nil, .unableToComplete)
        return
      }

      guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        completed(nil, .invalidResponse)
        return
      }

      guard let data = data else {
        completed(nil, .invalidData)
        return
      }

      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let user = try decoder.decode(User.self, from: data)
        completed(user, nil)
      } catch {
        completed(nil, .invalidData)
      }
    }

    task.resume()
  }

}
