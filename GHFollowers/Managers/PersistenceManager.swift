//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by Pratyusha Joginipally on 11/15/23.
//

import Foundation

enum PersistenceActionType {
  case add, remove
}

enum PersistenceManager {
  static private let defaults = UserDefaults.standard

  enum Keys {
    static let favorites = "favorites"
  }

  static func updateWith(favorite: Follower, actionType: PersistenceActionType, completed: @escaping (ErrorMessage?) -> Void) {
    retrieveFavorites { favorites, errorMessage in
      guard let favorites = favorites else {
        completed(.unableToFavorite)
        return
      }

      var retrievedFavorites = favorites

      switch actionType {
      case .add:
        guard !retrievedFavorites.contains(favorite) else {
          completed(.alreadyInFavorites)
          return
        }

        retrievedFavorites.append(favorite)

      case .remove:
        retrievedFavorites.removeAll { $0.login == favorite.login }
      }

      completed(save(favorites: retrievedFavorites))
    }
  }

  static func retrieveFavorites(completed: @escaping ([Follower]?, ErrorMessage?) -> Void) {
    guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
      completed([], nil)
      return
    }

    do {
      let decoder = JSONDecoder()
      let favorites = try decoder.decode([Follower].self, from: favoritesData)
      completed(favorites, nil)
    } catch {
      completed(nil, .unableToFavorite)
    }
  }

  static func save(favorites: [Follower]) -> ErrorMessage? {
    do {
      let encoder = JSONEncoder()
      let encodedFavorites = try encoder.encode(favorites)
      defaults.set(encodedFavorites, forKey: Keys.favorites)
      return nil
    } catch {
      return .unableToFavorite
    }
  }
}
