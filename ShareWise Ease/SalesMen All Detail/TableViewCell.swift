//
//  TableViewCell.swift
//  AssetAssign
//
//  Created by Moin Janjua on 20/08/2024.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var cView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var dateLabe: UILabel!
    @IBOutlet weak var saleType: UILabel!

    
    @IBOutlet weak var Sales_btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        saleType.layer.cornerRadius = 16
        
        contentView.layer.cornerRadius = 12
        
        // Set up shadow properties
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowRadius = 4.0
        contentView.layer.masksToBounds = false
        
        // Set background opacity
        contentView.alpha = 1.5 // Adjust opacity as needed
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }

}
