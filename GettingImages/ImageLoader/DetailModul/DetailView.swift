import UIKit
import Kingfisher

class DetailView: UIViewController {
    
    private var detailViewModel: DetailViewModel!
    let image = UIImage()
    
    private var indicator: UIActivityIndicatorView = {
        $0.color = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIActivityIndicatorView(style: .large))
    
    private var bgView: UIView = {
        $0.clipsToBounds = false
        $0.layer.cornerRadius = 35
        $0.backgroundColor = AppColor.bgView.withAlphaComponent(0.5)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private var imageCollection: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.image = UIImage(named: "ls")?.withRoundedCorners(radius: 35)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private var titleLabel: UILabel = {
        $0.text = "Имя"
        $0.font = .systemFont(ofSize: 35, weight: .bold)
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.textColor = AppColor.textBlack
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())

    private lazy var buttonDismiss: UIButton = {
        $0.backgroundColor = .blue
        $0.setTitle("Закрыть", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.gray, for: .highlighted)
        $0.layer.cornerRadius = 20
        $0.translatesAutoresizingMaskIntoConstraints = false
        return  $0
    }(UIButton(primaryAction: backAction))
    
    private lazy var backAction = UIAction { [weak self] _ in
        self?.navigationController?.popViewController(animated: true)
    }
    
    private lazy var buttonSendData: UIButton = {
        $0.backgroundColor = .blue
        $0.setTitle("Отправить данные", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.gray, for: .highlighted)
        $0.layer.cornerRadius = 20
        $0.translatesAutoresizingMaskIntoConstraints = false
        return  $0
    }(UIButton(primaryAction: actionSendData))
    
    private lazy var actionSendData = UIAction { [weak self] _ in
        guard let image = self?.imageCollection.image else { return }
        guard let viewView = self?.view else { return }
        self?.present(self!.detailViewModel.shareImage(image: image, view: viewView), animated: true)
    }
    
    init(detailViewModel: DetailViewModelProtocol) {
        self.detailViewModel = detailViewModel as? DetailViewModel
        super.init(nibName: nil, bundle: nil)
        updateView()
        indicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
    }

    private func updateView(){
        titleLabel.text = detailViewModel.data.title
        guard let urlString = detailViewModel.data.thumbnailURL else { return }
        guard let url = URL(string: urlString) else { return }
        loadImage(from: url, cellIndex: detailViewModel.cellIndex)
    }
    
    private func loadImage(from urls: URL, cellIndex: Int) {
        let processor =  DownsamplingImageProcessor(size: CGSize(width: 150, height: 150)) |> RoundCornerImageProcessor(cornerRadius: 35)
        imageCollection.kf.setImage(with: urls, options: [.processor(processor)])
        indicator.stopAnimating()
        imageCollection.image = imageCollection.image?.withRoundedCorners(radius: 35)
    }
    
    private func setConstraints(){
        view.backgroundColor = .systemBlue
        [bgView, imageCollection,
         titleLabel, indicator,
         buttonDismiss, buttonSendData].forEach(view.addSubview(_:))
        indicator.stopAnimating()
        
        bgView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor)
        
        imageCollection.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: nil,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 10, left: 0, bottom: 0, right: 0),
            size: CGSize(width: view.bounds.width / 1.5,
                         height: view.bounds.height / 3))
        imageCollection.centerXInSuperview()
        
        titleLabel.anchor(
            top: imageCollection.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: .init(top: 20, left: 20, bottom: 0, right: 20))
        
        indicator.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom:view.bottomAnchor,
            trailing: view.trailingAnchor)
        
        buttonDismiss.anchor(
            top: nil,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: nil,
            padding: .init(top: 0, left: 10, bottom: 50, right: 0),
            size: CGSize(width: 120, height: 50))
        
        buttonSendData.anchor(
            top: nil,
            leading: nil,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 50, right: 10),
            size: CGSize(width: 200, height: 50))
    }
}


