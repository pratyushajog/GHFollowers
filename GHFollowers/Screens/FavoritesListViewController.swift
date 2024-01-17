//
//  FavoritesListViewController.swift
//  GHFollowers
//
//  Created by Pratyusha Joginipally on 8/24/23.
//

import UIKit

class FavoritesListViewController: UIViewController {

  let tableview = UITableView()
  var favorites: [Follower] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    configureViewController()
    configureTableView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getFavorites()
  }

  func configureViewController() {
    view.backgroundColor = .systemBackground
    title = "Favorites"
    navigationController?.navigationBar.prefersLargeTitles = true
  }

  func configureTableView() {
    view.addSubview(tableview)

    tableview.frame = view.bounds
    tableview.rowHeight = 80
    tableview.delegate = self
    tableview.dataSource = self

    tableview.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.reuseID)
  }

  func getFavorites() {
    PersistenceManager.retrieveFavorites { [weak self] favorites, error in
      guard let self = self else { return }

      guard let favorites = favorites else {
        self.presentGFAlertOnMainThread(title: "Something went wrong", message: error!.rawValue, buttonTitle: "Ok")
        return
      }

      if favorites.isEmpty {
        self.showEmptyStateView(with: "No favorites\nAdd one in the follower screen", in: self.view)
      } else {
        self.favorites = favorites
        DispatchQueue.main.async {
          self.tableview.reloadData()
          self.view.bringSubviewToFront(self.tableview)
        }
      }
    }
  }
  
}

extension FavoritesListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favorites.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableview.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.reuseID, for: indexPath) as! FavoriteTableViewCell
    let favorite = favorites[indexPath.row]
    cell.set(favorite: favorite)
    
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let favorite = favorites[indexPath.row]
    let destVC = FollowerListViewController()
    destVC.username = favorite.login
    destVC.title = favorite.login

    navigationController?.pushViewController(destVC, animated: true)
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }

    let favorite = favorites[indexPath.row]
    favorites.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .left)

    PersistenceManager.updateWith(favorite: favorite, actionType: .remove) { [weak self] error in
      guard let self = self else { return }

      guard let error = error else { return }

      self.presentGFAlertOnMainThread(title: "Unable to remove the favorite", message: error.rawValue, buttonTitle: "Ok")
    }
  }
}
