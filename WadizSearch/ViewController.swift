//
//  ViewController.swift
//  WadizSearch
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var dataCollectionView: UICollectionView!
    @IBOutlet weak var tabBarCollectionView: UICollectionView!
    
    var datas: [Product] = []
    var storeDatas: [Product] = []
    var funcdingDatas: [Product] = []
    var selectedCategory = 0

    let tabBarTitle = ["전체", "펀딩", "스토어"]
    
    lazy var alertController: UIAlertController = {
        let alert = UIAlertController(title: "데이터 불러오는 중", message: "\n\n", preferredStyle: .alert)
        alert.view.tintColor = .black
        let loading = UIActivityIndicatorView(frame: CGRect(x: 110, y: 35, width: 50, height: 50))
        loading.hidesWhenStopped = true
        loading.style = .gray
        loading.startAnimating()
        alert.view.addSubview(loading)
        return alert
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.searchBar.placeholder = "어떤 프로젝트를 찾고 계신가요?"
        self.searchBar.delegate = self
        self.dataCollectionView.dataSource = self
        self.dataCollectionView.delegate = self
        
        self.tabBarCollectionView.delegate = self
        self.tabBarCollectionView.dataSource = self
        let firstIndexPath = IndexPath(item: 0, section: 0)

        
    }

    func openSFSafariView(_ targetURL: String) {
        guard let url = URL(string: targetURL) else { return }
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.modalPresentationStyle = .automatic
        present(safariViewController, animated: true, completion: nil)
    }
}


extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tabBarCollectionView {
            return 3
        } else {
            
            switch selectedCategory {
            case 0:
                return datas.count
            case 1:
                return storeDatas.count
            case 2:
                return funcdingDatas.count
            default:
                return 0
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tabBarCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabBarCollectionViewCell.identifier, for: indexPath) as? TabBarCollectionViewCell else { return UICollectionViewCell() }
            
            cell.setTitle(str: tabBarTitle[indexPath.row])
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataListCollectionViewCell.identifier, for: indexPath) as? DataListCollectionViewCell else { return UICollectionViewCell() }
            switch selectedCategory {
            case 0:
                cell.updateUI(data:datas[indexPath.row])
            case 1:
                cell.updateUI(data:storeDatas[indexPath.row])
            case 2:
                cell.updateUI(data:funcdingDatas[indexPath.row])
            default:
                break
            }
            
            
            return cell
        }
    }
}

extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == tabBarCollectionView {
            if indexPath.row == 0 {
                selectedCategory = 0
                self.dataCollectionView.reloadData()
            }
        
//            펀딩 or 펀딩오픈
            if indexPath.row == 1 {
                selectedCategory = 1
                self.funcdingDatas.removeAll()
                for i in self.datas{
                    if i.type == Product.ProductType.funding || i.type == Product.ProductType.fundingOpen {
                        self.funcdingDatas.append(i)
                    }
                }
                DispatchQueue.main.async {
                    self.dataCollectionView.reloadData()
                }
            }
            
//        스토어 클릭했을 때
            if indexPath.row == 2{
                self.selectedCategory = 2
                self.storeDatas.removeAll()
                for i in self.datas{
                    if i.type == Product.ProductType.store {
                        self.storeDatas.append(i)
                    }
                }
                DispatchQueue.main.async {
                    self.dataCollectionView.reloadData()
                }
            }
            
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        present(alertController, animated: true)
     
        API.search(keyword: searchText)
            .get { result in
                switch result{
                case .success(let data):
                    self.selectedCategory = 0
                    self.datas = data.body.list
                    self.dataCollectionView.reloadData()
                    self.alertController.dismiss(animated: true, completion: nil)
                case .failure(let error):
                    print(error)
                }
                
            }
    }
    
    
}
