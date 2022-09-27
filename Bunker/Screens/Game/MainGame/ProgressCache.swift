//
//  ProgressCache.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 27.09.2022.
//

import Foundation


final class ProgressCache {
    private var prevProgresses = [String: Double]()

    public func getProgress(for identifier: String) -> Double {
        return prevProgresses[identifier] ?? 0
    }

    public func setProgress(for identifier: String, progress: Double) {
        prevProgresses[identifier] = progress
    }

    public func clearProgress() {
        prevProgresses.removeAll()
    }
}
