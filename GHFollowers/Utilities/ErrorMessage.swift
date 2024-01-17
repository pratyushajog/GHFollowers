//
//  ErrorMessage.swift
//  GHFollowers
//
//  Created by Pratyusha Joginipally on 10/17/23.
//

import Foundation

enum ErrorMessage: String {
  case invalidUsername = "This username created an invalid request. Please try again."
  case unableToComplete = "Unable to complete your request. Please check your internet connection"
  case invalidResponse = "Invalid response from the server. Please try again."
  case invalidData = "The data received from the server was invalid. Please try again."
  case unableToFavorite = "There was an error adding to favorites. Please try again."
  case alreadyInFavorites = "Already in the favorites."
}
