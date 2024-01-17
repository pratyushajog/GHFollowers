//
//  UserInfoViewController.swift
//  GHFollowers
//
//  Created by Pratyusha Joginipally on 11/1/23.
//

import UIKit

protocol UserInfoViewControllerDelegate: AnyObject {
  func didTapGitHubProfile(for user: User)
  func didTapGetFollowers(for user: User)
}

class UserInfoViewController: UIViewController {

  let headerView = UIView()
  let itemViewOne = UIView()
  let itemViewTwo = UIView()
  let dateLabel = GFBodyLabel(textAlignment: .center)
  var itemViews: [UIView] = []
  weak var delegate: FollowerListViewControllerDelegate!

  var username: String!

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    layoutUI()
    getUserInfo()
  }

  func configureViewController() {
    view.backgroundColor = .systemBackground
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
    navigationItem.rightBarButtonItem = doneButton
  }

  func getUserInfo() {
    NetworkManager.shared.getUserInfo(for: username) { [weak self] user, error in
      guard let self = self else { return }

      guard let user = user else {
        self.presentGFAlertOnMainThread(title: "User not found", message: "Unable to find the selected user", buttonTitle: "Ok")
        return
      }

      DispatchQueue.main.async { self.configureUIElements(with: user) }
    }
  }

  func configureUIElements(with user: User) {
    self.add(childVC: GFUserInfoHeaderViewController(user: user), to: self.headerView)

    let repoItemVC = GFRepoItemViewController(user: user)
    repoItemVC.delegate = self
    self.add(childVC: repoItemVC, to: self.itemViewOne)

    let followerItemVC = GFFollowerItemViewController(user: user)
    followerItemVC.delegate = self
    self.add(childVC: followerItemVC, to: self.itemViewTwo)
    
    self.dateLabel.text = "Github since \(user.createdAt.convertToDisplayFormat())"
  }

  func layoutUI() {
    itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
    let padding: CGFloat = 20
    let itemHeight: CGFloat = 140

    for itemView in itemViews {
      view.addSubview(itemView)
      itemView.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([
        itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
        itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
      ])
    }

    NSLayoutConstraint.activate([
      headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      headerView.heightAnchor.constraint(equalToConstant: 180),

      itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
      itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),

      itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
      itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),

      dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
      dateLabel.heightAnchor.constraint(equalToConstant: 18)
    ])
  }

  func add(childVC: UIViewController, to containerView: UIView) {
    addChild(childVC)
    containerView.addSubview(childVC.view)
    childVC.view.frame = containerView.bounds
    childVC.didMove(toParent: self)
  }

  @objc func dismissVC() {
    dismiss(animated: true)
  }
}


extension UserInfoViewController: UserInfoViewControllerDelegate {
  func didTapGitHubProfile(for user: User) {
    guard let url = URL(string: user.htmlUrl) else {
      presentGFAlertOnMainThread(title: "Invalid URL", message: "The URL attached to this user is invalid", buttonTitle: "Ok")
      return
    }

    presentSafariVC(with: url)
  }

  func didTapGetFollowers(for user: User) {
    guard user.followers != 0 else {
      presentGFAlertOnMainThread(title: "No followers", message: "This user has no followers", buttonTitle: "Ok")
      return
    }

    delegate.didRequestFollowers(for: user.login)
    dismissVC()
  }

}
