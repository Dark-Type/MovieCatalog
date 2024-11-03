//
//  ImageService.swift
//  MovieCatalog
//
//  Created by dark type on 01.11.2024.
//

import SDWebImage

class ImageService {
    static let shared = ImageService()
    private init() {}

    func fetchImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let imageURL = URL(string: url) else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        SDWebImageManager.shared.loadImage(
            with: imageURL,
            options: .highPriority,
            progress: nil) { image, data, error, cacheType, finished, imageURL in
                if let error = error {
                    completion(.failure(error))
                } else if let image = image {
                    completion(.success(image))
                } else {
                    completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to load image"])))
                }
            }
    }
}
