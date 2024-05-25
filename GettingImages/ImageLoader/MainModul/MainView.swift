import UIKit

protocol MainViewProtocol: AnyObject{
    func showPost()
}

class MainView: UIViewController {

    private var mainVCViewModel: MainVCViewModel!

    private lazy var topMenuView: UIView = {
        $0.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: mainVCViewModel.menuViewHeight)
        $0.backgroundColor = .clear
        $0.addSubview(menuAppName)
        return $0
    }(UIView())
    
    private lazy var menuAppName: UILabel = {
        $0.text = "Image Loader"
        $0.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        $0.textColor = .white
        $0.frame = CGRect(x: 40, y: mainVCViewModel.menuViewHeight - 70, width: view.bounds.width, height: 30)
        return $0
    }(UILabel())
    
    lazy var collectionView: UICollectionView = {
        let itemSize = ((view.bounds.width - 60) / 2) - 15
        let layout = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemSize,
                                 height: itemSize)
        layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsets(top: 50, left: 30, bottom: 80, right: 30)
        
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
        $0.delegate = self
        $0.alwaysBounceVertical = true
        $0.backgroundColor = .gray
        $0.register(MainCollectionView.self, forCellWithReuseIdentifier: MainCollectionView.identifier)
        return $0
    }(UICollectionView(
        frame: view.bounds,
        collectionViewLayout: UICollectionViewFlowLayout()))
    
    init(mainVCViewModel: MainVCViewModelProtocol) {
        self.mainVCViewModel = mainVCViewModel as? MainVCViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfig()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if mainVCViewModel.images.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.collectionView.reloadData()
            }
        } else {
            self.collectionView.reloadData()
        }
    }
    
    private func setConfig(){
        view.backgroundColor = .clear
        navigationController?.isNavigationBarHidden = true
        [collectionView, topMenuView].forEach(view.addSubview(_:))
    }
    
    private func setupNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .blue
        navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
    }
}

//MARK: - UICollectionViewDataSource
extension MainView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainVCViewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionView.identifier, for: indexPath) as! MainCollectionView
        let cellItem = mainVCViewModel.images[indexPath.row]
        cell.configure(info: cellItem, cellIndex: indexPath.row)
        return cell
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        mainVCViewModel.lastContentOffset = scrollView.contentOffset.y
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if mainVCViewModel.lastContentOffset > scrollView.contentOffset.y {
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                self?.topMenuView.alpha = 1.0
                self?.topMenuView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        } else if mainVCViewModel.lastContentOffset < scrollView.contentOffset.y {
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                self?.topMenuView.alpha = 0
                self?.topMenuView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: nil)
        }
    }
}

extension MainView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellItem = mainVCViewModel.images[indexPath.row]
        let detailsView = Builder.createDetailViewController(info: cellItem, cellIndex: indexPath.row)
        navigationController?.pushViewController(detailsView, animated: true)
    }
}

extension MainView: MainViewProtocol {
    func showPost() {
        collectionView.reloadData()
    }
}
