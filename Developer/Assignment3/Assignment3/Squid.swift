//
//  Squid.swift
//  Assignment3
//
//  Created by 강현준 on 2021/07/06.
//

import SwiftUI

struct Squid: Shape {
    func path(in rect: CGRect) -> Path {
        let rightTopPoint = CGPoint(x: rect.maxX, y: rect.minY)
        let leftBottomPoint = CGPoint(x: rect.minX, y: rect.maxY)

        let controlPoint1 = CGPoint(x: rect.minX + rect.width/4, y: rect.minY - rect.height/2)
        let controlPoint2 = CGPoint(x: rect.maxX - rect.width/4, y: rect.maxY)
        let controlPoint3 = CGPoint(x: rect.maxX - rect.width/4, y: rect.maxY + rect.height/2)
        let controlPoint4 = CGPoint(x: rect.minX + rect.width/4, y: rect.minY)
        
        var p = Path()
        p.move(to: leftBottomPoint)
        p.addCurve(to: rightTopPoint, control1: controlPoint1, control2: controlPoint2)
        p.addCurve(to: leftBottomPoint, control1: controlPoint3, control2: controlPoint4)
        return p
    }
}
