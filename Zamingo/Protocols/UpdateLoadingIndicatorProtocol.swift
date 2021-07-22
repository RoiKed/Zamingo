//
//  UpdateLoadingIndicatorProtocol.swift
//  Zamingo
//
//  Created by Roi Kedarya on 22/07/2021.
//

import Foundation

protocol UpdateLoadingIndicatorProtocol: AnyObject {
    func handleUpdateStarted()
    func handleUpdateFinished()
}
