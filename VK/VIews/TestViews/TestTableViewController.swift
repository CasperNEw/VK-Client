import UIKit

class TestTableViewController: UITableViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var rightSearchButton: UIBarButtonItem!
    var logoImageView: UIImageView!
    
    @IBAction func rightSearchButtonPressed(_ sender: Any) {
        showSearchBar()
        animateBarButton()
    }
    
    func animateBarButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        button.setImage(UIImage.init(named: "lens"), for: UIControl.State())
        let right = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = right
        
        UIView.animate(withDuration: 0.8,
                       delay: 0.1,
                       options: .curveEaseIn,
                       animations: { self.navigationItem.rightBarButtonItem?.customView?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi)) })
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.5,
                       options: .curveEaseIn,
                       animations: { self.navigationItem.rightBarButtonItem?.customView?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2)) })
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.2,
                       options:.curveEaseInOut,
                       animations: { self.navigationItem.rightBarButtonItem?.customView?.frame.origin.x += 300 })

    }
    //после отработывания первого тапа по UIBarButtonItem, сам Item становился не активным, поэтому применил дополнительные "уловки" отрабатывания нажатий по этому Item'у
    @objc private func imageTapped(_ recognizer: UITapGestureRecognizer) {
        showSearchBar()
        animateBarButton()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //плавная анимация исчезновения выделения
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        //регистрация и "уловки"
        self.navigationItem.rightBarButtonItem?.customView?.isUserInteractionEnabled = true
        self.navigationItem.rightBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        navigationItem.rightBarButtonItem?.image = UIImage(named: "lens")
        
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "SimpleMessage")
        
        //автоматическое изменение высоты ячейки
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        
        print("[Logging] load Test Table View")
        
        let logoImage = UIImage(named: "TestTitle")
        logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: logoImage!.size.width, height: logoImage!.size.height ))
        logoImageView.image = logoImage
        navigationItem.titleView = logoImageView
        
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .minimal
        rightSearchButton = navigationItem.rightBarButtonItem
        searchBar.alpha = 0
        
        navigationController?.isNavigationBarHidden = false
        
        
        let hideAction = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideAction)
        
        //добавляем возможность отслеживания положения контента на TableView
        //(tableView as? UIScrollView)?.delegate = self
    }
    //добавляем необходимые для нашей "магии" переменные
    var offsetBool = false
    var offsetWithoutSearchBar: CGFloat = 0.0
    var offsetWithSearchBar: CGFloat = 0.0
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.y)
//        print(searchBar.frame.height)
        //делаем Bool проверку что бы сделать запись значений только при изначальном запуске View
        if offsetBool == false {
            offsetBool = true
            offsetWithoutSearchBar = scrollView.contentOffset.y + searchBar.frame.height
            offsetWithSearchBar = scrollView.contentOffset.y
        }
        //"магия" =)
        if scrollView.contentOffset.y == offsetWithSearchBar {
            UIView.animate(withDuration: 0.6, animations: { scrollView.contentOffset.y = self.offsetWithoutSearchBar })
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
        searchBarCancelButtonClicked(searchBar)
    }

    func showSearchBar() {
        searchBar.alpha = 0
        navigationItem.titleView = searchBar
        navigationItem.setLeftBarButtonItems(nil, animated: true)
        UIView.animate(withDuration: 0.5,
                       delay: 0.2,
                       animations: { self.searchBar.alpha = 1 },
                       completion: { finished in self.searchBar.becomeFirstResponder() })
    }
    
    
    func hideSearchBar() {
        logoImageView.alpha = 0
        navigationItem.setLeftBarButtonItems((rightSearchButton as? [UIBarButtonItem]? ?? nil), animated: true)
        UIView.animate(withDuration: 1,
                       delay: 0.2,
                       animations: {
                        self.navigationItem.titleView = self.logoImageView
                        self.logoImageView.alpha = 1 })
    }
}

extension TestTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar()
        print("out of search")
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setImage(UIImage.init(named: "lens"), for: UIControl.State())
        let right = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = right
        //"уловки"
        self.navigationItem.rightBarButtonItem?.customView?.isUserInteractionEnabled = true
        self.navigationItem.rightBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
    }
}
