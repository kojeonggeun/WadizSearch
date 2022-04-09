//
//  TabBarCollectionViewCell.swift
//  WadizSearch
//
//  Created by 고정근 on 2022/04/09.
//

import Foundation
import UIKit

class TabBarCollectionViewCell: UICollectionViewCell {
    static let identifier = "TabBarCollectionViewCell"
    
    
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
  
    func setTitle(str: String) {
        title.text = str
        
    }
    
    
}


