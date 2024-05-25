import UIKit

protocol MainVCViewModelProtocol: AnyObject {
    var networkService: NetworkService? { get }
    func getImagesWithServer()
}

final class MainVCViewModel: MainVCViewModelProtocol {
    ///Network injection
    var networkService: NetworkService?
    var lastContentOffset: CGFloat = 0
    var menuViewHeight = UIApplication.topSafeArea + 70

    ///Dynamic arrays with data
    var images: [UserImageElement] = [] {
        didSet { self.images = self.privateImages }
    }
    
    ///Private property
    private var privateImages = [UserImageElement]()
    
    init() {
        self.networkService = NetworkService()
        getImagesWithServer()
    }

    internal func getImagesWithServer() {
        images = []
        do { networkService?.fetchAlbums { [unowned self] result in
                switch result {
                case .success(let album):
                    DispatchQueue.main.async {
                        self.privateImages = album
                        self.images = self.privateImages
                        print("images MainVCViewModel: \(self.privateImages.count)")
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)") }
            }
        }
    }
}
