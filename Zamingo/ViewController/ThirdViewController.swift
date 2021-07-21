//
//  ThirdViewController.swift
//  Zamingo
//
//  Created by Roi Kedarya on 21/07/2021.
//

import Foundation
import UIKit

class ThirdViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    static let identifier = "thirdViewController"
    var titleContent: String?
    var descriptionContent: String?
    
    class func initVC( _ title: String?, _ description: String?) -> ThirdViewController {
        guard let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ThirdViewController.identifier) as? ThirdViewController  else {
            fatalError("could not find ThirdViewController")
        }
        newViewController.titleContent = title
        newViewController.descriptionContent = description
        return newViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let title = titleContent {
            self.titleLabel.text = title
        }
        if let description = descriptionContent {
            self.descriptionLabel.text = description
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
