//
//  ClockView.swift
//  Module11
//
//  Created by username on 14.11.2021.
//

import UIKit

// создать часы с часовой, минутной и секундной стрелками, у которых можно менять цвет и размер каждой стрелки

@IBDesignable
class ClockView: UIView {
    
    private struct Constants {
        static let arcWidth: CGFloat = 30.0
        static let numberOfMarkers = 60
        static let numberOfMinutesMarkers = 12
        static let markerWidth: CGFloat = 2.0
        static let markerColor: UIColor = UIColor.black
        static let strokeWidth: CGFloat = 2.5
        static let strokeColor: UIColor = UIColor.black
    }
    
    @IBInspectable var secondArrowColor: UIColor = UIColor.yellow
    @IBInspectable var minuteArrowColor: UIColor = UIColor.magenta
    @IBInspectable var hourArrowColor: UIColor = UIColor.red
    
    @IBInspectable var secondArrowSize: CGFloat = 145.0
    @IBInspectable var minuteArrowSize: CGFloat = 115.0
    @IBInspectable var hourArrowSize: CGFloat = 85.0
    
    @IBInspectable var secondArrowTail: CGFloat = 35.0
    @IBInspectable var minuteArrowTail: CGFloat = 20.0
    @IBInspectable var hourArrowTail: CGFloat = 20.0
    
    @IBInspectable var secondArrowWidth: CGFloat = 6.0
    @IBInspectable var minuteArrowWidth: CGFloat = 8.0
    @IBInspectable var hourArrowWidth: CGFloat = 10.0
    @IBInspectable var arrowsAxisRadius: CGFloat = 10.0
    
    var isSetuped: Bool = false
    
    @IBInspectable var clockColor: UIColor = UIColor.orange
    
    @IBInspectable var hasShadow: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var seconds: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var minutes: CGFloat = 0
    @IBInspectable var hours: CGFloat = 3
    
    var day: CGFloat = 1
    var month: CGFloat = 1
    var year: CGFloat = 2000
    let formatter = DateFormatter()
    var dateLabel: UILabel!
    
    
    override func draw(_ rect: CGRect) {
        
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        formatter.dateFormat = "dd.MM.YYYY"
        let timeStr = formatter.string(from: Date())
        
        if !isSetuped {
            dateLabel = UILabel(frame: CGRect(x: 0,
                                              y: bounds.height * 2 / 3,
                                              width: bounds.width,
                                              height: bounds.height / 8))
            self.addSubview(dateLabel)
            dateLabel.textAlignment = .center
            dateLabel.textColor = .black
            isSetuped = true
        }
        dateLabel.text = timeStr

        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius = max(bounds.width, bounds.height) / 2
        let path = UIBezierPath(arcCenter: center,
                                radius: radius - Constants.arcWidth/2,
                                startAngle: 0,
                                endAngle: .pi * 2.0,
                                clockwise: true)
        
        path.lineWidth = Constants.arcWidth
        clockColor.setStroke()
        path.stroke()

        if(hasShadow) {
            self.layer.shadowRadius = 10
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 10, height: 10)
        }
        else {
            self.layer.shadowOpacity = 0
        }
    
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        drawSecondsMarkers(context, rect)
        context.restoreGState()
        context.saveGState()
        drawHoursMarkers(context, rect)
        context.restoreGState()
        
        drawArrow(rect,
                  to: seconds,
                  color: secondArrowColor,
                  size: secondArrowSize,
                  width: secondArrowWidth,
                  tail: secondArrowTail)
        drawArrow(rect,
                  to: minutes,
                  color: minuteArrowColor,
                  size: minuteArrowSize,
                  width: minuteArrowWidth,
                  tail: minuteArrowTail)
        drawArrow(rect,
                  to: hours * (60 / 12) + 5 * minutes / 60, //добавляю смещене к часовой стрелке с учетом минут
                  color: hourArrowColor,
                  size: hourArrowSize,
                  width: hourArrowWidth,
                  tail: hourArrowTail)
        
        let circlePath = UIBezierPath(ovalIn: CGRect(x: bounds.width / 2.0 - arrowsAxisRadius,
                                                     y: bounds.height / 2.0 - arrowsAxisRadius,
                                                     width: arrowsAxisRadius * 2.0,
                                                     height: arrowsAxisRadius * 2.0))
        hourArrowColor.setFill()
        circlePath.fill()
        Constants.strokeColor.setStroke()
        circlePath.lineWidth = Constants.strokeWidth
        circlePath.stroke()
        
    }
    
    fileprivate func drawSecondsMarkers(_ context: CGContext, _ rect: CGRect) {
        Constants.markerColor.setFill()
        let markerSize = Constants.arcWidth
        
        let markerPath = UIBezierPath(rect: CGRect(x: -Constants.markerWidth / 2.0,
                                                   y: 0,
                                                   width: Constants.markerWidth,
                                                   height: markerSize))
        
        context.translateBy(x: rect.width / 2.0, y: rect.height / 2.0)
        
        for i in 1...Constants.numberOfMarkers {
            context.saveGState()
            let arcLengthPerMarker = 2.0 * .pi  / CGFloat(Constants.numberOfMarkers)
            let angle = arcLengthPerMarker * CGFloat(i) - .pi
            context.rotate(by: angle)
            context.translateBy(x: 0, y: rect.height / 2.0 - markerSize)
            markerPath.fill()
            context.restoreGState()
        }
    }
    
    fileprivate func drawHoursMarkers(_ context: CGContext, _ rect: CGRect) {
        Constants.markerColor.setFill()
        let hourMarkerSize: CGFloat = 8.0
        
        let hourMarkerPath = UIBezierPath(rect: CGRect(x: -hourMarkerSize / 2.0,
                                                       y: 0,
                                                       width: hourMarkerSize,
                                                       height: hourMarkerSize))
        
        context.translateBy(x: rect.width / 2.0, y: rect.height / 2.0)
        
        for i in 1...Constants.numberOfMinutesMarkers {
            context.saveGState()
            let arcLengthPerMarker = 2.0 * .pi  / CGFloat(Constants.numberOfMinutesMarkers)
            let angle = arcLengthPerMarker * CGFloat(i) - .pi
            context.rotate(by: angle)
            context.translateBy(x: 0, y: rect.height / 2.0 - hourMarkerSize)
            hourMarkerPath.fill()
            context.restoreGState()
        }
    }
    
    fileprivate func drawArrow(_ rect: CGRect, to mark: CGFloat, color arrowColor: UIColor,
                               size arrowSize: CGFloat, width arrowWidth: CGFloat, tail tailLenght: CGFloat) {
    
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        
        let arrowPath = UIBezierPath(rect: CGRect(x: -arrowWidth / 2,
                                                  y: -tailLenght,
                                                  width: arrowWidth,
                                                  height: arrowSize))
        
        context.translateBy(x: rect.width / 2, y: rect.height / 2)
        let angle = -.pi + (2 * .pi / 60) * mark
        context.rotate(by: angle)
        arrowColor.setFill()
        arrowPath.fill()
        Constants.strokeColor.setStroke()
        arrowPath.lineWidth = Constants.strokeWidth
        arrowPath.stroke()
        context.restoreGState()
    }

    func setClock(to time: Date) {
        
        let calendar = Calendar.current
        
        hours = CGFloat(calendar.component(.hour, from: time))
        minutes = CGFloat(calendar.component(.minute, from: time))
        seconds = CGFloat(calendar.component(.second, from: time))
        day = CGFloat(calendar.component(.day, from: time))
        month = CGFloat(calendar.component(.month, from: time))
        year = CGFloat(calendar.component(.year, from: time))
    }

}

