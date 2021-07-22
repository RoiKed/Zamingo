//
//  SecondViewController.swift
//  Zamingo
//
//  Created by Roi Kedarya on 20/07/2021.
//

import Foundation
import UIKit

class SecondViewController: UIViewController {
    
    var sportsChannel: ChannelVM!
    var carsChannel: ChannelVM!
    var cultureChannel: ChannelVM!
    var cultureAndSportsChannel: ChannelVM!
    
    weak var delegate: SelectionProtocol?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initChannels()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSchedualedTask()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cancelSchedualedTask()
    }
    
    private func initChannels() {
         sportsChannel = ChannelVM(nil, ChannelType.sports, self)
         carsChannel = ChannelVM(nil, ChannelType.cars, self)
         cultureChannel = ChannelVM(nil, ChannelType.culture, self)
         cultureAndSportsChannel = ChannelVM(nil, ChannelType.combined, nil)
    }
    
    private func setSchedualedTask() {
        setItemIndexForCurrentDisplayedTable()
    }
    
    private func cancelSchedualedTask() {
        carsChannel.stopUpdateItems()
        sportsChannel.stopUpdateItems()
        cultureChannel.stopUpdateItems()
    }
    
    private func setup() {
        if let delegate = self.tabBarController?.viewControllers?.filter({
            $0 is SelectionProtocol
        }).first as? SelectionProtocol {
            self.delegate = delegate
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.loadingIndicator.isHidden = true
        tableView.register(UINib(nibName: "HeadlineCell", bundle: nil), forCellReuseIdentifier: HeadlineCell.identifier)

    }
    //we do the update only when
    @IBAction func segControllValueChange(_ sender: UISegmentedControl) {
        setItemIndexForCurrentDisplayedTable()
        tableView.reloadData()
    }
    
    /**
     we start check updates only for the channels of the table that's presented
     to avoid unneccecary server calls
     */
    private func setItemIndexForCurrentDisplayedTable() {
        if ShouldPresentCarsTable() {
            self.carsChannel.updateItems()
            self.cultureChannel.stopUpdateItems()
            self.sportsChannel.stopUpdateItems()
        } else {
            self.carsChannel.stopUpdateItems()
            self.cultureChannel.updateItems()
            self.sportsChannel.updateItems()
        }
    }
    
    
}

//MARK:- UITableViewDelegate
extension SecondViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //create VC3 and push to nav Bar
        if let cell = tableView.cellForRow(at: indexPath) as? HeadlineCell {
            let title = cell.titleLabel.text
            let description = cell.articleDescription
            
            let thirdViewController = ThirdViewController.initVC(title, description)
            if let navController = self.navigationController {
                navController.pushViewController(thirdViewController, animated: true)
            }
            if let delegate = delegate, let title = title {
                delegate.updateSelection(title)
            }
        }
    }
}

//MARK:- UITableViewDataSource
extension SecondViewController: UITableViewDataSource {
    
    private func ShouldPresentCarsTable() -> Bool {
        return segmentedControl.selectedSegmentIndex == 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ShouldPresentCarsTable() {
            let retVal = getItemsCount(for: carsChannel)
            return retVal
        } else {
            let retVal = getItemsCount(for: cultureChannel) + getItemsCount(for: sportsChannel)
            populateSportsAndCultureItems()
            return retVal
        }
    }
    
    private func populateSportsAndCultureItems() {
        if let sportsItems = sportsChannel.items, let cultureItems = cultureChannel.items {
            let cultureAndSportsItems = sportsItems + cultureItems
            self.cultureAndSportsChannel = ChannelVM(cultureAndSportsItems, ChannelType.combined, nil)
        }
    }
    
    private func getItemsCount(for channel: ChannelVM) -> Int {
        if channel.isEmpty() {
            DispatchQueue.main.async {
                self.startAnimating()
            }
            dispatchGroup.enter()
            channel.updateItems {
                [weak self] items, error in
                if let error = error {
                    print(error)
                } 
                self?.dispatchGroup.leave()
                DispatchQueue.main.async {
                    self?.stopAnimating()
                }
            }
            dispatchGroup.notify(queue: .main) { [weak self] in
                self?.tableView.reloadData()
            }
            return 0
        } else {
            return channel.numberOfItems()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = ShouldPresentCarsTable() ? self.carsChannel: self.cultureAndSportsChannel
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HeadlineCell.identifier, for: indexPath) as? HeadlineCell else {
            fatalError("Could not find cell")
        }
        guard let data = data else {
            fatalError("no data")
        }
        cell.titleLabel.text = data.getTitle(for: indexPath.row)
        cell.articleDescription = data.getDescription(for: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if ShouldPresentCarsTable(), !carsChannel.isEmpty() {
            return "CARS"
        }
        if !cultureAndSportsChannel.isEmpty() {
            if section == 1 {
                return "SPORT"
            }
            return "CULTURE"
        }
        return ""
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ShouldPresentCarsTable(), !carsChannel.isEmpty() {
            return carsChannel.numberOfItems()
        }
        if !cultureAndSportsChannel.isEmpty() {
            if section == 0 {
                print("sportsChannel \(sportsChannel.numberOfItems())")
                return sportsChannel.numberOfItems()
            } else {
                print("cultureChannel \(cultureChannel.numberOfItems())")
                return cultureChannel.numberOfItems()
            }
        }
        return 0
    }
}

extension SecondViewController: UpdateLoadingIndicatorProtocol {
    func handleUpdateStarted() {
        startAnimating()
    }

    func handleUpdateFinished() {
        stopAnimating()
    }


}

//MARK: - handle activity indicator
extension SecondViewController {
    private func startAnimating() {
        DispatchQueue.main.async { [weak self] in
            if ChannelVM.shouldStartAnimating() {
                self?.loadingIndicator.startAnimating()
            }
            self?.loadingIndicator.isHidden = !ChannelVM.shouldStartAnimating()
        }
    }
    
    private func stopAnimating() {
        DispatchQueue.main.async { [weak self] in
            if ChannelVM.shouldStartAnimating() {
                self?.loadingIndicator.startAnimating()
            }
            self?.loadingIndicator.isHidden = ChannelVM.shouldStopAnimating()
        }
    }
}
