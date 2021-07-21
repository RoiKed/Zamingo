//
//  HeadlineCell.swift
//  Zamingo
//
//  Created by Roi Kedarya on 20/07/2021.
//

import Foundation
import UIKit

class HeadlineCell: UITableViewCell {
    
    static let identifier = "headlineCell"
    @IBOutlet weak var titleLabel: UILabel!
    var articleDescription: String?
}
