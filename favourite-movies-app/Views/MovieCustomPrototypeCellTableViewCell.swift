//
//  MovieCustomPrototypeCellTableViewCell.swift
//  favourite-movies-app
//
//  Created by Kapil Rathan on 10/7/17.
//  Copyright © 2017 Kapil Rathan. All rights reserved.
//

import UIKit

protocol MovieCustomCellDelegate {
    func didTapFavButton(cell: MovieCustomPrototypeCellTableViewCell)
}
class MovieCustomPrototypeCellTableViewCell: UITableViewCell {
    
    @IBOutlet var movieImageView: UIImageView!
    @IBOutlet var movieTitle : UILabel!
    @IBOutlet var movieYear : UILabel!
    @IBOutlet var favourite : UIButton!

    var delegate: MovieCustomCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func favButtonSelected(_ sender: Any) {
        self.delegate?.didTapFavButton(cell: self)
        self.favourite.backgroundColor = UIColor.red
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
