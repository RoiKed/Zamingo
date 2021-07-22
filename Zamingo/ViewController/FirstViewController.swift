//
//  FirstViewController.swift
//  Zamingo
//
//  Created by Roi Kedarya on 20/07/2021.
//

import Foundation
import UIKit

class FirstViewController: UIViewController {
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var emptyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dateLabel.text = Date().description
    }
}


extension FirstViewController: SelectionProtocol {
    func updateSelection(_ title: String) {
        self.emptyLabel.text = title
    }
}

extension FirstViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
}


