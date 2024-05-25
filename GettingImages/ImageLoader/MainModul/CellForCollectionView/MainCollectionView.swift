import UIKit
import Kingfisher

class MainCollectionView: UICollectionViewCell {
    
    static let identifier = "MainCollectionView"
   
    private lazy var indicator: UIActivityIndicatorView = {
        $0.color = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIActivityIndicatorView(style: .large))

    private lazy var bgView: UIView = {
        $0.clipsToBounds = false
        $0.layer.cornerRadius = 35
        $0.backgroundColor = AppColor.bgView.withAlphaComponent(0.5)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private lazy var imageCollection: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.image = UIImage(named: "ls")?.withRoundedCorners(radius: 35)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private lazy var titleLabel: UILabel = {
        $0.text = "Имя"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.textColor = AppColor.textBlack
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(info: UserImageElement , cellIndex: Int){
        titleLabel.text = info.title
        guard let urlString = info.thumbnailURL else { return }
        guard let url = URL(string: urlString) else { return }
        loadImage(from: url, cellIndex: cellIndex)
    }
    
    private func loadImage(from urls: URL, cellIndex: Int) {
        let processor =  DownsamplingImageProcessor(size: CGSize(width: 150, height: 150)) |> RoundCornerImageProcessor(cornerRadius: 35)
        imageCollection.kf.setImage(with: urls, options: [.processor(processor)])
        indicator.stopAnimating()
        imageCollection.image = imageCollection.image?.withRoundedCorners(radius: 35)
    }
        
    private func setConstraints(){
        [bgView, imageCollection, 
         titleLabel, indicator].forEach(addSubview(_:))
        
        indicator.startAnimating()
        
        bgView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor)
        
        imageCollection.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 10, left: 10, bottom: 10, right: 10))
        
        titleLabel.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        
        indicator.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor)
    }
}


