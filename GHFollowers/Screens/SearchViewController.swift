//
//  SearchViewController.swift
//  GHFollowers
//
//  Created by Pratyusha Joginipally on 8/24/23.
//

import UIKit

class SearchViewController: UIViewController {

  let logoImageView = UIImageView()
  let usernameTextfield = GFTextField()
  let callToActionButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers")

  var isUsernameEntered: Bool { return !usernameTextfield.text!.isEmpty }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground

    configureLogoImageView()
    configureTextField()
    configureCallToActionButton()
    createDismissKeyboardTapGesture()
  }


  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }


  func createDismissKeyboardTapGesture() {
    let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
    view.addGestureRecognizer(tap)
  }

  @objc func pushFollowerListVC() {
    guard isUsernameEntered else {
      presentGFAlertOnMainThread(title: "Empty username", message: "Please enter a username. We need to know who to look for. 🙂", buttonTitle: "Ok")
      return
    }

    let followerListVC = FollowerListViewController()
    followerListVC.title = usernameTextfield.text
    followerListVC.username = usernameTextfield.text

    navigationController?.pushViewController(followerListVC, animated: true)
  }

  func configureLogoImageView() {
    view.addSubview(logoImageView)

    logoImageView.translatesAutoresizingMaskIntoConstraints = false
    logoImageView.image = UIImage(named: "gh-logo")!

    NSLayoutConstraint.activate([
      logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
      logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      logoImageView.heightAnchor.constraint(equalToConstant: 200),
      logoImageView.widthAnchor.constraint(equalToConstant: 200)
    ])
  }

  func configureTextField() {
    view.addSubview(usernameTextfield)
    usernameTextfield.delegate = self

    NSLayoutConstraint.activate([
      usernameTextfield.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
      usernameTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      usernameTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
      usernameTextfield.heightAnchor.constraint(equalToConstant: 50)
    ])
  }

  func configureCallToActionButton() {
    view.addSubview(callToActionButton)
    callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)

    NSLayoutConstraint.activate([
      callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
      callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
      callToActionButton.heightAnchor.constraint(equalToConstant: 50)
    ])
  }
}

extension SearchViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    pushFollowerListVC()
    return true
  }
}
