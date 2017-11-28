//
//  DrawView.swift
//  TouchTracker
//
//  Created by Павел Собянин on 03.11.17.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import UIKit

extension CGPoint {
    func distanceToPoint(p: CGPoint) -> Double {
        return Double(sqrt(pow((p.x - self.x), 2) + pow((p.y - self.y), 2)))
    }
}

class DrawLine: UIView, UIGestureRecognizerDelegate {
    var currentLines = [NSValue:Line]()
    var finishedLines = [Line]()
    var circleTouches = [NSValue:Line]()
    var finishedCircleLines = [Line]()
    var isCircle = false
    var selectedLineIndex: Int? {
        didSet {
            if selectedLineIndex == nil {
                let menu = UIMenuController.shared
                menu.setMenuVisible(false, animated: true)
            }
        }
    }
    var moveRecognizer: UIPanGestureRecognizer!
    var lastTouchLocation: CGPoint?
    var elapsedTime: DispatchTime?
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @objc func doubleTap(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a double tap")
        selectedLineIndex = nil
        currentLines.removeAll()
        finishedLines.removeAll()
        circleTouches.removeAll()
        finishedCircleLines.removeAll()
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawLine.doubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)
        
        let tapRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(DrawLine.tap(_:)))
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.require(toFail: doubleTapRecognizer)
        addGestureRecognizer(tapRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                               action: #selector(DrawLine.longPress(_:)))
        addGestureRecognizer(longPressRecognizer)
        
        moveRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DrawLine.moveLine(_:)))
        moveRecognizer.delegate = self
        moveRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(moveRecognizer)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func moveLine(_ gestureRecognizer: UIPanGestureRecognizer) {
        print("Recognized a pan")
        //print(gestureRecognizer.location(in: self))
        // If a line is selected...
        let touchLocation = gestureRecognizer.location(in: self)
        if let index = selectedLineIndex {
            switch gestureRecognizer.state {
            case .began:
                if index != indexOfLine(at: touchLocation) {
                    selectedLineIndex = nil
                }
                setNeedsDisplay()
            // When the pan recognizer changes its position...
            case .changed:
            // How far has the pan moved?
                let translation = gestureRecognizer.translation(in: self)
                // Add the translation to the current beginning and end points of the line
                // Make sure there are no copy and paste typos!
                finishedLines[index].begin.x += translation.x
                finishedLines[index].begin.y += translation.y
                finishedLines[index].end.x += translation.x
                finishedLines[index].end.y += translation.y
                
                gestureRecognizer.setTranslation(CGPoint.zero, in: self)
                // Redraw the screen
                setNeedsDisplay()
            default:
                return
            }
        }
    }
    
    func drawingVelocity(_ touchLocation: CGPoint) {
        if let beginTouchLocation = lastTouchLocation, let start = elapsedTime {
            let endTouchLocation = touchLocation
            let end = DispatchTime.now()
            let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
            let timeInterval = Double(nanoTime) / 1_000_000_000
            print(endTouchLocation)
            //print(gestureRecognizer.location(in: self))
            let distance = endTouchLocation.distanceToPoint(p: beginTouchLocation)
            print(distance)
            print("\(distance / timeInterval) points per second")
            lastTouchLocation = endTouchLocation
        }
        else {
            lastTouchLocation = touchLocation
            elapsedTime = DispatchTime.now()
        }
    }
    
    @objc func longPress(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a long press")
        if gestureRecognizer.state == .began {
            let point = gestureRecognizer.location(in: self)
            selectedLineIndex = indexOfLine(at: point)
            
            if selectedLineIndex != nil {
                currentLines.removeAll()
            }
        }
        else if gestureRecognizer.state == .ended
        {
            selectedLineIndex = nil
        }
        setNeedsDisplay()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc func deleteLine(_ sender: UIMenuController) {
        // Remove the selected line from the list of finishedLines
        if let index = selectedLineIndex {
            finishedLines.remove(at: index)
            selectedLineIndex = nil
            // Redraw everything
            setNeedsDisplay()
        }
    }
    
    @objc func tap(_ gestureRecognizer: UIGestureRecognizer) {
        print("One tap is recognized")
        let point = gestureRecognizer.location(in: self)
        selectedLineIndex = indexOfLine(at: point)
        
        // Grab the menu controller
        let menu = UIMenuController.shared
        if selectedLineIndex != nil {
            // Make DrawView the target of menu item action messages
            becomeFirstResponder()
            // Create a new "Delete" UIMenuItem
            let deleteItem = UIMenuItem(title: "Delete",
                                        action: #selector(DrawLine.deleteLine(_:)))
            menu.menuItems = [deleteItem]
            // Tell the menu where it should come from and show it
            let targetRect = CGRect(x: point.x, y: point.y, width: 2, height: 2)
            menu.setTargetRect(targetRect, in: self)
            menu.setMenuVisible(true, animated: true)
        } else {
            // Hide the menu if no line is selected
            menu.setMenuVisible(false, animated: true)
        }
        setNeedsDisplay()
    }
    
    func getColorByAngle(_ angle: CGFloat) -> UIColor {
        switch angle {
        case 0..<45:
            return UIColor.black
        case 45..<90:
            return UIColor.green
        case 90..<135:
            return UIColor.blue
        case 135..<180:
            return UIColor.yellow
        default:
            return UIColor.brown
        }
    }
    
    func stroke(_ line: Line) {
        //print(#function)
        //print(line)
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = .round
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    func drawCircle(_ lines: [Line]) {
        print(#function)
        let centerX: CGFloat
        let centerY: CGFloat
        //let lines = Array(circleTouches.values)
        
        centerX = lines.reduce(0, { $0 + $1.end.x/2 })
        centerY = lines.reduce(0, { $0 + $1.end.y/2 })
        
        let radius = min(abs(lines[0].end.x - lines[1].end.x), abs(lines[0].end.y - lines[1].end.y))/2
        let circle = UIBezierPath(
            arcCenter: CGPoint(x: centerX, y: centerY),
            radius: CGFloat(radius),
            startAngle: CGFloat(0),
            endAngle: 2*CGFloat.pi,
            clockwise: true
        )
        circle.lineWidth = lineThickness
        circle.lineCapStyle = .round
        UIColor.orange.setStroke()
        circle.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        // Draw finished lines in black
        //UIColor.black.setStroke()
        //finishedLineColor.setStroke()
        print(#function)
        for line in finishedLines {
            let lineColor = getColorByAngle(line.angle())
            lineColor.setStroke()
            stroke(line)
        }
        
        for i in stride(from: 0, to: finishedCircleLines.count, by: 2) {
            drawCircle([finishedCircleLines[i], finishedCircleLines[i + 1]])
        }
        
        //UIColor.red.setStroke()
        currentLineColor.setStroke()
        if isCircle {
            let lines = Array(circleTouches.values)
            //print(lines)
            for i in stride(from: 0, to: lines.count, by: 2) {
                drawCircle([lines[i], lines[i + 1]])
            }
        }
        else {
            for (_, line) in currentLines {
                stroke(line)
            }
        }
        
        if let index = selectedLineIndex {
            UIColor.green.setStroke()
            let selectedLine = finishedLines[index]
            stroke(selectedLine)
        }
    }
    
    func indexOfLine(at point: CGPoint) -> Int? {
        // Find a line close to point
        for (index, line) in finishedLines.enumerated() {
            let begin = line.begin
            let end = line.end
            // Check a few points on the line
            for t in stride(from: CGFloat(0), to: 1.0, by: 0.05) {
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                // If the tapped point is within 20 points, let's return this line
                if hypot(x - point.x, y - point.y) < 20.0 {
                    return index
                }
            }
        }
        // If nothing is close enough to the tapped point, then we did not select a line
        return nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //let touch = touches.first!
        //becomeFirstResponder()
        // Log statement to see the order of events
        print(#function)
        //selectedLineIndex = nil
        isCircle = touches.count == 2
        //var dict = isCircle ? circleTouches : currentLines
        // Get location of the touch in view's coordinate system
        for touch in touches {
            let location = touch.location(in: self)
            let newLine = Line(begin: location, end: location)
            
            let key = NSValue(nonretainedObject: touch)
            
            //[key] = newLine
            //dict[key] = newLine
            isCircle ? (circleTouches[key] = newLine) : (currentLines[key] = newLine)
        }
        //print(dict.count)
        //print(circleTouches.count)
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //let touch = touches.first!
        //let location = touch.location(in: self)
        
        // Log statement to see the order of events
        print(#function)
        //var dict = currentTouchesDictionary(isCircle)
        //print(dict)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            isCircle ? (circleTouches[key]?.end = touch.location(in: self)) : (currentLines[key]?.end = touch.location(in: self))
            //dict[key]?.end = touch.location(in: self)
        }
        drawingVelocity(touches.first!.location(in: self))

        //print(dict)
        //print(circleTouches.count)
        //print(currentLines)
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)
        //var dict = currentTouchesDictionary(isCircle)
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = isCircle ? circleTouches[key] : currentLines[key] {
                let location = touch.location(in: self)
                
                line.end = location
                
                if isCircle {
                    circleTouches.removeValue(forKey: key)
                    finishedCircleLines.append(line)
                }
                else {
                    finishedLines.append(line)
                    currentLines.removeValue(forKey: key)
                }
                //isCircle ? circleTouches.removeValue(forKey: key) :
                //print(line.angle())
            }
        }
        lastTouchLocation = nil
        elapsedTime = nil
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        currentLines.removeAll()
        setNeedsDisplay()
    }
}
