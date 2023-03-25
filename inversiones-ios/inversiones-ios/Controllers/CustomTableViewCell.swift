//
//  TableViewCell.swift
//  inversiones-ios
//
//  Created by Grisel Angelica Perez Quezada on 22/03/23.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

 
    
    @IBOutlet weak var basediv: UILabel!

    @IBOutlet weak var imageDiv: UIImageView?
    
    @IBOutlet weak var divDest: UILabel!
    
    @IBOutlet weak var monto: UILabel!
    
    @IBOutlet weak var baseTasa: UILabel!
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        /*let backgroundView = UIView()
        backgroundView.backgroundColor = .lightGray
                selectedBackgroundView = backgroundView*/
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("quien", selected)
        // Configure the view for the selected state
        
        if selected {
            backgroundColor = UIColor(red: 252/255, green: 229/255, blue: 205/255, alpha: 1)
        }
        else{
            backgroundColor = UIColor(red: 33/255, green: 77/255, blue: 114/255, alpha: 1)
        }
    }
    
    

}
