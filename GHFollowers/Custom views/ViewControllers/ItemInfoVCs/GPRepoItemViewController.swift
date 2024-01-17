//
//  GPRepoItemViewController.swift
//  GHFollowers
//
//  Created by Pratyusha Joginipally on 11/8/23.
//

import UIKit

class GFRepoItemViewController: GFItemInfoViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    configureItems()
  }

  private func configureItems() {
    itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
    itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
    actionButton.set(backgroundColor: .systemPurple, title: "Github Profile")
  }

  override func actionButtonTapped() {
    delegate.didTapGitHubProfile(for: user)
  }
}
