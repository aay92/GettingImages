import UIKit

protocol BuilderProtocol {
    static func createMainViewController() -> UIViewController
    static func createDetailViewController(info: UserImageElement, cellIndex: Int) -> UIViewController
}

class Builder: BuilderProtocol {
    
    static func createMainViewController() -> UIViewController {
        let mainVCViewModel = MainVCViewModel()
        let mainView = MainView(mainVCViewModel: mainVCViewModel)
        return mainView
    }
    
    static func createDetailViewController(info: UserImageElement, cellIndex: Int) -> UIViewController {
        let detailViewModel = DetailViewModel(info: info, cellIndex: cellIndex)
        let detailView = DetailView(detailViewModel: detailViewModel)
        return detailView
    }
}
