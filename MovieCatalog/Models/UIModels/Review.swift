//
//  Review.swift
//  MovieCatalog
//
//  Created by dark type on 01.11.2024.
//


import UIKit

struct Review: Identifiable {
    var id: String
    var reviewText: String
    var isAnonymous: Bool
    var createDateTime: String
    var author: Author
    var rating: Int
    var isUserReview: Bool = false
}
extension Review {
    static func create(from details: ReviewDetails, imageService: ImageService, completion: @escaping (Review) -> Void) {
        let defaultAuthor = AuthorDetails(userId: "Anonymous", nickName: "Anonymous", avatar: "")
        var review = Review(
            id: details.id,
            reviewText: details.reviewText,
            isAnonymous: details.isAnonymous,
            createDateTime: details.createDateTime,
            author: Author(from: details.author ?? defaultAuthor),
            rating: details.rating
        )
        
        imageService.fetchImage(from: review.author.avatarURL) { result in
            switch result {
            case .success(let image):
                review.author.avatar = image
            case .failure:
                review.author.avatar = UIImage(systemName: "person.crop.circle")
            }
            completion(review)
        }
    }
}
