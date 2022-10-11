//
//  NSObject+copyObject.swift
//  Bunker
//
//  Created by Danila Kokin on 11.10.2022.
//

import Foundation

extension NSObject {
    func copyObject<T:NSObject>() throws -> T? {
        let data = try NSKeyedArchiver.archivedData(withRootObject:self, requiringSecureCoding:false)
        return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? T
    }
}
