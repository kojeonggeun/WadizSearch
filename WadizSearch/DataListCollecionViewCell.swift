//
//  DataListCollecionViewCell.swift
//  WadizSearch
//
//  Created by 고정근 on 2022/04/09.
//

import Foundation
import UIKit

class DataListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var keyword: UIButton!
    @IBOutlet weak var price: UILabel!
    
    
    static var identifier = "DataListCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    
    func updateUI(data:Product){
        ImageLoader(url: data.photoURL!).load{ result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.image.image = image.resized(for: CGSize(width: 150, height: 140))
                }
                
            case .failure(let error):

                print("이미지 실패 UI 구현 해야 함, 회색 바탕 UI")
            }
        }
        
        self.title.text = data.title
        self.type.text = data.type.rawValue
        
        if let priceString = data.price?.decimalFormatString! {
            self.price.text = "\(priceString) 원"
        } else {
            self.price.text = "가격 없음"
        }
        
        
        
        var firstData = data.additionalInfo?.split(separator: ",").filter{ $0.contains("@")}
        var secData = data.additionalInfo?.split(separator: ",").filter{ $0.contains("#")}
        
        for (index,item) in secData!.enumerated(){
            if index <= 1 {
                firstData!.append(item)
            }
        }
        
        var addi = ""
        for i in firstData! {
            addi.append(String(i))
        }
        print(addi)
        
        self.keyword.setTitle(addi, for: .normal)
    }
}
