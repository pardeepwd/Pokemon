//
//  CustomTagColViewCell.swift
//  Pokemon
//
//  Created by Simran Singh Sandhu on 23/07/21.
//

import UIKit

class CustomTagColViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var tagName: String? {
        didSet {
            tagLabel.text = tagName
            bgView.layer.cornerRadius = 10
        }
    }
}
