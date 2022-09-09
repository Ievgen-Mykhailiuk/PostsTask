//
//  CellIdentifying.swift
//  NatifeTestTask
//
//  Created by Евгений  on 08/09/2022.
//

import Foundation

protocol CellIdentifying: AnyObject {
    static var cellIdentifier: String { get }
}

extension CellIdentifying {
    static var cellIdentifier: String {
        return String(describing: Self.self)
    }
}
