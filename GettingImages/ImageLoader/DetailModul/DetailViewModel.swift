import UIKit

protocol DetailViewModelProtocol: AnyObject{
    init(info: UserImageElement, cellIndex: Int)
    var data: UserImageElement { get }
    var cellIndex: Int { get }
}

class DetailViewModel: DetailViewModelProtocol {
    var cellIndex: Int
    var data: UserImageElement
    
    required init(info: UserImageElement, cellIndex: Int) {
        self.data = info
        self.cellIndex = cellIndex
    }
    
    func shareImage(image: UIImage, view: UIView) -> UIActivityViewController {
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(
            activityItems: imageToShare as [Any],
            applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = view
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        return activityViewController
    }
}
