//
//  TrackerGeometricParams.swift
//  Tracker
//
//  Created by Almira Khafizova on 15.11.23.
//

import UIKit

struct TrackerGeometricParams {
    var cellCount: Int
    var topDistance: CGFloat
    var leftInset: CGFloat
    var rightInset: CGFloat
    var cellSpacing: CGFloat
    var paddingWidth: CGFloat
    
    init(cellCount: Int, topDistance: CGFloat, leftInset: CGFloat, rightInset: CGFloat, cellSpacing: CGFloat) {
        self.cellCount = cellCount
        self.topDistance = topDistance
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.cellSpacing = cellSpacing
        self.paddingWidth = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpacing
    }
}
