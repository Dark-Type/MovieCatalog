//
//  NetworkManager.swift
//  MovieCatalog
//
//  Created by dark type on 29.10.2024.
//

import Alamofire
import UIKit

class ServiceManager {
    static let shared = ServiceManager()
    private init() {}

    let authService = AuthService.shared
    let movieService = MovieService.shared
    let reviewService = ReviewService.shared
    let kinopoiskService = KinopoiskService.shared
    let imageService = ImageService.shared
    let profileService = ProfileService.shared
    let hiddenFilmsService = HiddenFilmsService.shared
    let friendsService = FriendsService.shared
    let genresService = GenreManager.shared
    let shownMoviesService = ShownMoviesService.shared
    
    func setUserLogin(_ userLogin: String) {
          friendsService.userLogin = userLogin
        genresService.userLogin = userLogin
          hiddenFilmsService.userLogin = userLogin
        shownMoviesService.userLogin = userLogin
      }

      func resetAllServices() {
          friendsService.reset()
          genresService.reset()
          hiddenFilmsService.reset()
          shownMoviesService.reset()
      }
    
}
