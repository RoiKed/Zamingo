//
//  ChannelViewModel.swift
//  Zamingo
//
//  Created by Roi Kedarya on 20/07/2021.
//

import Foundation
import UIKit

class ChannelVM {
    let type: ChannelType
    private static var TimerCounter = 0
    private static let concurrentQueue = DispatchQueue(label: "Concurrent Queue", attributes: .concurrent)
    var items:[Item]?
    var timer: Timer?
    
    func updateItems(_ completion: @escaping ([Item]?,Error?) -> Void) {
        DispatchQueue.global().async { [weak self] in
            if let self = self, self.type != ChannelType.combined {
                self.increaseCounter()
                Service.shared.getItems(for: self.type) { [weak self] items, error in
                    self?.dencreaseCounter()
                    if let error = error {
                        completion(nil,error)
                        return
                    } else if let self = self, let items = items {
                        completion(items,nil)
                        self.items = items
                        return
                    }
                }
            }
        }
    }
    
    static func shouldStartAnimating() -> Bool {
        return ChannelVM.TimerCounter > 0
    }
    
    static func shouldStopAnimating() -> Bool {
        return ChannelVM.TimerCounter < 1
    }
    
    private func increaseCounter() {
        ChannelVM.concurrentQueue.async(flags: .barrier) {
            ChannelVM.TimerCounter += 1
            if !(0 ..< 4).contains(ChannelVM.TimerCounter) {
                print("     TimerCounter Sync error ")
            }
        }
    }
    
    private func dencreaseCounter() {
        ChannelVM.concurrentQueue.async(flags: .barrier) {
            ChannelVM.TimerCounter -= 1
            if !(0 ..< 4).contains(ChannelVM.TimerCounter) {
                print("     TimerCounter Sync error ")
            }
        }
    }
    
    func updateItems() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    func stopUpdateItems() {
        timer?.invalidate()
    }
    
    @objc private func update() {
        self.updateItems { items, error in
        
        }
    }
    
    init(_ items:[Item]?, _ type: ChannelType) {
        self.type = type
        if let items = items {
            self.items = items
        }
    }
    
    func getItem(for index: Int) -> Item? {
        if let items = items, (0 ..< self.numberOfItems()).contains(index) {
            return items[index]
        }
        return nil
    }
    
    func getTitle(for index: Int) -> String? {
        if items != nil, (0 ..< self.numberOfItems()).contains(index),
           let item = getItem(for: index) {
            return item.title
        }
        return nil
    }
    
    func getDescription(for index: Int) -> String? {
        if items != nil, (0 ..< self.numberOfItems()).contains(index),
           let item = getItem(for: index) {
            return item.description
        }
        return nil
    }
    
    func isEmpty() -> Bool {
        return self.items == nil
    }
    
    func numberOfItems() -> Int {
        if let items = items {
            return items.count
        }
        return 0
    }
}

