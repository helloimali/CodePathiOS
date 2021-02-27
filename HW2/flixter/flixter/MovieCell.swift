//
//  MovieCell.swift
//  flixter
//
//  Created by Ali Malik on 2/20/21.
//

import UIKit

class MovieCell: UITableViewCell {

    //Contains Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var synopsisLbl: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
