import UIKit

enum FetchError: Error {
    case notCorrectData, invalidURL
}

class NetworkService {
    
    static let shared = NetworkService()
    init(){}
   
    func fetchAlbums(completion: @escaping (Result<[UserImageElement], Error>) -> Void) {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/albums/1/photos") else {
            completion(.failure(FetchError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return }
            
            guard let data = data else {
                completion(.failure(FetchError.notCorrectData))
                return }
            
            do {
                let imagesAlbum = try JSONDecoder().decode([UserImageElement].self, from: data)
                completion(.success(imagesAlbum))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
