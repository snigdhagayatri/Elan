//
//  LineGraph.swift
//  LineGraph
//
//  Created by Asif Junaid on 19/10/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//
import UIKit
import QuartzCore
// make Arrays substractable

func - (left: Array<CGFloat>, right: Array<CGFloat>) -> Array<CGFloat> {
    
    var result: Array<CGFloat> = []
    
    for index in 0..<left.count {
        
        var difference = left[index] - right[index]
        
        result.append(difference)
    }
    
    return result
}


//dataSource method
//@objc - Because of Optional Method which is behaving like Objective-C Method
@objc public protocol LineGraphDataSource: NSObjectProtocol {
    optional func showGrid() -> Bool
    optional func showAxes() -> Bool
    optional func showDots() -> Bool
    optional func showFilterButtons() -> Bool
    
    optional func showXLabel() -> Bool
    optional func showYLabel() -> Bool
    optional func showAreaUnderLines() -> Bool
    optional func animationEnabled() -> Bool
    
}

// delegate method

//
//protocol FilterButtonDelegate {
//    func filterButtonTap(sender : UIButton)
//}

// LineGraph class
public class LineGraph: UIView {
    
    // default configuration
    var gridVisible = true
    var axesVisible = true
    var dotsVisible = false
    var filterButtonVisible = true
    
    var labelsXVisible = true
    var labelsYVisible = true
    var areaUnderLinesVisible = true
    var numberOfGridLinesX: CGFloat = 20
    var numberOfGridLinesY: CGFloat = 7
    var animationEnabled = false
    var animationDuration: CFTimeInterval = 1
    
    var xAxisLabelArray: [String]!
    var yAxisLabelArray: [String]!
    var filterButtonArray: [String]!
    var dotsBackgroundColor = UIColor.whiteColor()
    
    var dataArrayHasNegeativeValues = false
    var xAxislabelArrayHasNoValues = false
    var yAxislabelArrayHasNoValues = false
    
    var selectedButton=UIButton()
    
    var fontSize : CGFloat = 14
    
    var dashPatterns: [Int] = []
    // #eeeeee
    var gridColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1)
    
    // #607d8b
    var axesColor = UIColor(red: 96/255.0, green: 125/255.0, blue: 139/255.0, alpha: 1)
    
    // #f69988
    var positiveAreaColor = UIColor(red: 246/255.0, green: 153/255.0, blue: 136/255.0, alpha: 1)
    
    // #72d572
    var negativeAreaColor = UIColor(red: 114/255.0, green: 213/255.0, blue: 114/255.0, alpha: 1)
    
    var areaBetweenLines = [-1, -1]
    
    // sizes
    var lineWidth: CGFloat = 2
    var outerRadius: CGFloat = 12
    var innerRadius: CGFloat = 8
    var outerRadiusHighlighted: CGFloat = 12
    var innerRadiusHighlighted: CGFloat = 8
    var axisInset: CGFloat = 10
    
    // values calculated on init
    var drawingHeight: CGFloat = 0
    var drawingWidth: CGFloat = 0
    
    var dataArray:[Array<CGFloat>] = []
    
    public var dataSource: LineGraphDataSource?
    
    // var filterDelegate : FilterButtonDelegate?
    // data stores
    var dataStore: Array<Array<CGFloat>> = []
    var SwitchdataStore = Dictionary<Int,Array<CGFloat>>()
    
    var dotsDataStore: Array<Array<LineDotLayer>> = []
    var lineLayerStore: Array<CAShapeLayer> = []
    var colors: Array<UIColor> = []
    var switchOneON = false
    var switchTwoOn = false
    var switchIndex = 0
    var layerFillColor : CAShapeLayer = CAShapeLayer()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        if (UIDevice.currentDevice().model) == "iPhone Simulator" || (UIDevice.currentDevice().model) == "iPhone"
        {
            fontSize = 8
            
        }
        //Creating gradients
        
        // category10 colors from d3 - https://github.com/mbostock/d3/wiki/Ordinal-Scales
        self.colors = [
            UIColorFromHex(0x1f77b4),
            UIColorFromHex(0xff7f0e),
            UIColorFromHex(0x2ca02c),
            UIColorFromHex(0xd62728),
            UIColorFromHex(0x9467bd),
            UIColorFromHex(0x8c564b),
            UIColorFromHex(0xe377c2),
            UIColorFromHex(0x7f7f7f),
            UIColorFromHex(0xbcbd22),
            UIColorFromHex(0x17becf)
        ]
        
        
    }
    
    override public func drawRect(rect: CGRect) {
        
        
        //assert((self.dataSource != nil), "LineGraph Data Source not implemented DataSource method")
        if self.dataSource != nil {
            
            
            if let isAxes = self.dataSource?.showAxes?() {
                self.axesVisible = isAxes
            }
            
            if let isDots = self.dataSource?.showDots?() {
                self.dotsVisible = isDots
            }
            
            if let isFilter = self.dataSource?.showFilterButtons?() {
                self.filterButtonVisible = isFilter
            }
            
            if let isXLabel = self.dataSource?.showXLabel?() {
                self.labelsXVisible = isXLabel
            }
            
            if let isYLabel = self.dataSource?.showYLabel?() {
                self.labelsYVisible = isYLabel
            }
            
            if let isAreaUnderLine = self.dataSource?.showAreaUnderLines?() {
                self.areaUnderLinesVisible = true
            }
            
            if let isAnimation = self.dataSource?.animationEnabled?() {
                self.animationEnabled = isAnimation
            }
            
            self.dataStore.removeAll(keepCapacity: false)
            var numberOfLines = self.numberOfLine()
            if numberOfLines > 0
            {
                for index in 0...numberOfLines - 1 {
                    var data = self.dataForLineAtIndex(index)
                    //self.addLine(data!)
                    self.dataStore.append(data)
                }
                
                
            }
            
        }
        
        self.drawingHeight = self.bounds.height - (5 * axisInset)
        self.drawingWidth = self.bounds.width - (2 * axisInset)
        
        
        
        // draw grid
        if gridVisible { drawGrid() }
        
        // draw axes
        if axesVisible { drawAxes() }
        
        if labelsXVisible { drawXLabels() }
        if labelsYVisible { drawYLabels() }
        
        // draw filled area between Graphs
        if areaBetweenLines[0] > -1 && areaBetweenLines[1] > -1 {
            drawAreaBetweenLineGraphs()
        }
        
        
    }
    
    
    func numberOfLine() -> Int {
        
        return dataArray.count
    }
    func dataForLineAtIndex(index:Int) -> Array<CGFloat> {
        
        return dataArray[index]
    }
    /**
    initLineGraph is used to initialize Line graph with give data array , labels for X-Axis , labels for Y-Axis and grid visible to true if you want grid pattern in background
    */
    //marked
    
    public func initLineGraph(dataArray:[Array<CGFloat>],xAxislabelArray : [String],yAxislabelArray : [String],gridVisible : Bool)
    {
        
        for data in dataArray
        {
            for value in data
            {
                if value < 0
                {
                    println("LineGraph : dataArray has negeative values")
                    dataArrayHasNegeativeValues = true
                }
            }
        }
        if dataArrayHasNegeativeValues
        {
            self.dataArray = Array()
        }
        else
        {
            self.dataArray = dataArray
        }
        
        if xAxislabelArray == [] || xAxislabelArray == [""]
        {
            xAxislabelArrayHasNoValues = true
            println("LineGraph : xAxislabelArray is empty")
            
        }
            
        else
        {
            self.xAxisLabelArray = xAxislabelArray
            
        }
        
        if yAxislabelArray == [] || yAxislabelArray == [""]
        {
            yAxislabelArrayHasNoValues = true
            println("LineGraph : yAxislabelArray is empty")
        }
        else
        {
            self.yAxisLabelArray = yAxislabelArray
        }
        
        self.gridVisible = gridVisible
        self.dataStore.removeAll(keepCapacity: false)
        self.drawingHeight = self.bounds.height - (5 * axisInset)
        self.drawingWidth = self.bounds.width - (2 * axisInset)
        
        var numberOfLines = self.numberOfLine()
        if numberOfLines > 0
        {
            for index in 0...numberOfLines - 1 {
                var data = self.dataForLineAtIndex(index)
                self.dataStore.append(data)
            }
        }
        self.setNeedsDisplay()
        
    }
    /**
    displayLineGraph is used to display the graph on defined bounds .
    */
    public func displayLineGraph() {
        for (lineIndex, lineData) in enumerate(dataStore) {
            var scaledDataXAxis = scaleDataXAxis(lineData)
            var scaledDataYAxis = scaleDataYAxis(lineData)
            drawLine(scaledDataXAxis, yAxis: scaledDataYAxis, lineIndex: 0)
            drawAreaBeneathLineGraph(scaledDataXAxis, yAxis: scaledDataYAxis, lineIndex: 0)
            
            
        }
        self.setNeedsDisplay()
    }
    /**
    removeLineGraph will remove the line graph from view
    */
    public func removeLineGraph()
    {
        // remove all labels
        for view: AnyObject in self.subviews {
            view.removeFromSuperview()
        }
        
        // remove all lines on device rotation
        for lineLayer in lineLayerStore {
            lineLayer.removeFromSuperlayer()
        }
        lineLayerStore.removeAll()
        
        // remove all dots on device rotation
        for dotsData in dotsDataStore {
            for dot in dotsData {
                dot.removeFromSuperlayer()
            }
        }
        
        dotsDataStore.removeAll()
        dataStore.removeAll()
        
        
    }
    /**
    reloadLineGraphWithNewData  will reload the line graph with the new data
    */
    public func reloadLineGraphWithNewData(dataArray:[Array<CGFloat>])
    {
        removeLineGraph()
        
        initLineGraph(dataArray,xAxislabelArray: xAxisLabelArray,yAxislabelArray:yAxisLabelArray,gridVisible: gridVisible)
        displayLineGraph()
        
    }
    func didSelectDataPoint(x: CGFloat, yValues: Array<CGFloat>) {
        // label.text = "x: \(x)     y: \(yValues)"
        
    }
    
    convenience override init() {
        self.init(frame: CGRectZero)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    /**
    * Convert hex color to UIColor
    */
    func UIColorFromHex(hex: Int) -> UIColor {
        var red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        var green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        var blue = CGFloat((hex & 0xFF)) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    
    
    /**
    * Lighten color.
    */
    func lightenUIColor(color: UIColor) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b * 1.5, alpha: a)
    }
    
    
    
    /**
    * Get y value for given x value. Or return zero or maximum value.
    */
    func getYValuesForXValue(x: Int) -> Array<CGFloat> {
        var result: Array<CGFloat> = []
        for lineData in dataStore {
            if x < 0 {
                result.append(lineData[0])
            } else if x > lineData.count - 1 {
                result.append(lineData[lineData.count - 1])
            } else {
                result.append(lineData[x])
            }
        }
        return result
    }
    
    
    
    /**
    * Handle touch events.
    */
    func handleTouchEvents(touches: NSSet!, event: UIEvent!) {
        var point: AnyObject! = touches.anyObject()
        var xValue = point.locationInView(self).x
        var closestXValueIndex = findClosestXValueInData(xValue)
        var yValues: Array<CGFloat> = getYValuesForXValue(closestXValueIndex)
        highlightDataPoints(closestXValueIndex)
        self.didSelectDataPoint(CGFloat(closestXValueIndex), yValues: yValues)
    }
    
    
    
    /**
    * Listen on touch end event.
    */
    override public func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        handleTouchEvents(touches, event: event)
    }
    
    
    
    /**
    * Listen on touch move event
    */
    override public func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        handleTouchEvents(touches, event: event)
    }
    
    
    
    /**
    * Find closest value on x axis.
    */
    func findClosestXValueInData(xValue: CGFloat) -> Int {
        var difference : CGFloat = 1
        if !xAxislabelArrayHasNoValues || !yAxislabelArrayHasNoValues
            
        {
            if !(dataStore.isEmpty )
            {
                if(dataStore == [0.0])
                {
                    var scaledDataXAxis = scaleDataXAxis(dataStore[0])
                    if scaledDataXAxis.count < 2
                    {
                        difference = 1
                    }
                    difference = scaledDataXAxis[1] - scaledDataXAxis[0]
                    
                    var dividend = (xValue - axisInset) / difference
                    var roundedDividend = Int(round(Double(dividend)))
                    return roundedDividend
                }
            }
        }
        return 0 //Made changes
        
    }
    
    
    
    /**
    * Highlight data points at index.
    */
    func highlightDataPoints(index: Int) {
        for (lineIndex, dotsData) in enumerate(dotsDataStore) {
            // make all dots white again
            for dot in dotsData {
                dot.backgroundColor = dotsBackgroundColor.CGColor
            }
            // highlight current data point
            var dot: LineDotLayer
            if index < 0 {
                dot = dotsData[0]
            } else if index > dotsData.count - 1 {
                dot = dotsData[dotsData.count - 1]
            } else {
                dot = dotsData[index]
            }
            dot.backgroundColor = lightenUIColor(colors[lineIndex]).CGColor
        }
    }
    
    
    
    /**
    * Draw small dot at every data point.
    */
    func drawDataDots(xAxis: Array<CGFloat>, yAxis: Array<CGFloat>, lineIndex: Int) {
        var dots: Array<LineDotLayer> = []
        for index in 0..<xAxis.count {
            var xValue = xAxis[index] + axisInset - outerRadius/2
            var yValue = self.bounds.height - yAxis[index] - axisInset - outerRadius/2
            
            // draw custom layer with another layer in the center
            var dotLayer = LineDotLayer()
            dotLayer.dotInnerColor = colors[lineIndex]
            dotLayer.innerRadius = innerRadius
            dotLayer.backgroundColor = dotsBackgroundColor.CGColor
            dotLayer.cornerRadius = outerRadius / 2
            dotLayer.frame = CGRect(x: xValue, y: yValue, width: outerRadius, height: outerRadius)
            self.layer.addSublayer(dotLayer)
            dots.append(dotLayer)
            
            // animate opacity
            if animationEnabled {
                var animation = CABasicAnimation(keyPath: "opacity")
                animation.duration = animationDuration
                animation.fromValue = 0
                animation.toValue = 1
                dotLayer.addAnimation(animation, forKey: "opacity")
            }
            
        }
        dotsDataStore.append(dots)
    }
    
    
    
    /**
    * Draw x and y axis.
    */
    func drawAxes() {
        var height = self.bounds.height
        var width = self.bounds.width
        var context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, axesColor.CGColor)
        // draw x-axis
        CGContextMoveToPoint(context, axisInset, height-axisInset)
        CGContextAddLineToPoint(context, width-axisInset, height-axisInset)
        CGContextStrokePath(context)
        // draw y-axis
        CGContextMoveToPoint(context, axisInset, height-axisInset)
        CGContextAddLineToPoint(context, axisInset, axisInset)
        CGContextStrokePath(context)
    }
    
    
    
    /**
    * Get maximum value in all arrays in data store.
    */
    func getMaximumValue() -> CGFloat {
        var maximum = 0
        for data in dataStore {
            var newMaximum = data.reduce(Int.min, { max(Int($0), Int($1)) })
            if newMaximum > maximum {
                maximum = newMaximum
            }
        }
        return CGFloat(maximum)
    }
    
    
    
    /**
    * Scale to fit drawing width.
    */
    func scaleDataXAxis(data: Array<CGFloat>) -> Array<CGFloat> {
        var factor = drawingWidth / CGFloat(data.count - 1)
        var scaledDataXAxis: Array<CGFloat> = []
        for index in 0..<data.count {
            var newXValue = factor * CGFloat(index)
            scaledDataXAxis.append(newXValue)
        }
        return scaledDataXAxis
    }
    
    
    
    /**
    * Scale data to fit drawing height.
    */
    func scaleDataYAxis(data: Array<CGFloat>) -> Array<CGFloat> {
        var maximumYValue = getMaximumValue()
        var factor = drawingHeight / maximumYValue
        var scaledDataYAxis = data.map({datum -> CGFloat in
            var newYValue = datum * factor
            return newYValue
        })
        return scaledDataYAxis
    }
    
    
    
    /**
    * Draw line.
    */
    func drawLine(xAxis: Array<CGFloat>, yAxis: Array<CGFloat>, lineIndex: Int) {
        
        var path = CGPathCreateMutable()
        if yAxis.count < 2
        {
            return //Made changes
        }
        CGPathMoveToPoint(path, nil, axisInset, self.bounds.height - yAxis[0] - axisInset)
        
        CGPathAddLineToPoint(path, nil, axisInset, self.bounds.height - yAxis[0] - axisInset)
        for index in 1..<xAxis.count {
            var xValue = xAxis[index] + axisInset
            var yValue = self.bounds.height - yAxis[index] - axisInset
            CGPathAddLineToPoint(path, nil, xValue, yValue)
            
        }
        
        
        
        
        
        var layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.path = path
        
        //Stroke color not needed for inital graph
        layer.strokeColor = UIColor.blackColor().CGColor//colors[lineIndex].CGColor
        
        
        
        layer.fillColor = nil
        
        layer.lineWidth = lineWidth
        
        self.layer.addSublayer(layer)
        
        if animationEnabled {
            var animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = animationDuration
            animation.fromValue = 0
            animation.toValue = 1
            layer.addAnimation(animation, forKey: "strokeEnd")
        }
        // add line layer to store
        lineLayerStore.append(layer)
        
        
    }
    
    
    /**
    * Fill area between line Graph and x-axis.
    */
    
    func drawAreaBeneathLineGraph(xAxis: Array<CGFloat>, yAxis: Array<CGFloat>, lineIndex: Int) {
        if yAxis.count < 2
        {
            return //Made changes
        }
        var path = CGPathCreateMutable()
        CGPathMoveToPoint(path,nil, axisInset, self.bounds.height - axisInset)
        // add line to first data point
        CGPathAddLineToPoint(path,nil, axisInset, self.bounds.height - yAxis[0] - axisInset)
        
        
        // draw whole line Graph
        
        for index in 1..<xAxis.count {
            var xValue = xAxis[index] + axisInset
            var yValue = self.bounds.height - yAxis[index] - axisInset
            CGPathAddLineToPoint(path,nil, xValue, yValue)
        }
        // move down to x axis
        CGPathAddLineToPoint(path,nil, xAxis[xAxis.count-1] + axisInset, self.bounds.height - axisInset)
        // move to origin
        CGPathAddLineToPoint(path,nil, axisInset, self.bounds.height - axisInset)
        //CGContextFillPath(context) Color is filled using gradient layer
        
        let colorTop = UIColor.clearColor().CGColor
        
        let colorBottom = UIColor(red:0, green: 0, blue: 255/255.0, alpha: 1).CGColor
        layerFillColor.frame = self.bounds
        layerFillColor.path = path
        layerFillColor.fillColor = colorBottom
        var gl: CAGradientLayer = CAGradientLayer()
        
        
        let c: Array <AnyObject> = [colorBottom, colorTop]
        gl.colors = c
        gl.locations = [ 0.0, 1.0]
        gl.frame = layerFillColor.frame
        gl.frame.inset(dx: 10, dy: 10)
        layerFillColor.mask = gl
        
        var animation = CABasicAnimation(keyPath: "fillColor")
        animation.duration = 2
        animation.fromValue = colorTop
        animation.toValue = colorBottom
        animation.fillMode = kCAFillModeBoth
        animation.autoreverses=false
        animation.removedOnCompletion = false
        
        layerFillColor.addAnimation(animation, forKey: "fillColor")
        
        
        
        //        if !((layerFillColor.superlayer) != nil)
        //        {
        self.layer.addSublayer(layerFillColor)
        lineLayerStore.append(layerFillColor)
        
        // }
        
        
        
    }
    
    
    
    /**
    * Fill area between Graphs.
    */
    func drawAreaBetweenLineGraphs() {
        
        var xAxis = scaleDataXAxis(dataStore[0])
        var yAxisDataA = scaleDataYAxis(dataStore[areaBetweenLines[0]])
        var yAxisDataB = scaleDataYAxis(dataStore[areaBetweenLines[1]])
        var difference = yAxisDataA - yAxisDataB
        
        for index in 0..<xAxis.count-1 {
            
            var context = UIGraphicsGetCurrentContext()
            
            if difference[index] < 0 {
                CGContextSetFillColorWithColor(context, negativeAreaColor.CGColor)
            } else {
                CGContextSetFillColorWithColor(context, positiveAreaColor.CGColor)
            }
            
            var point1XValue = xAxis[index] + axisInset
            var point1YValue = self.bounds.height - yAxisDataA[index] - axisInset
            var point2XValue = xAxis[index] + axisInset
            var point2YValue = self.bounds.height - yAxisDataB[index] - axisInset
            var point3XValue = xAxis[index+1] + axisInset
            var point3YValue = self.bounds.height - yAxisDataB[index+1] - axisInset
            var point4XValue = xAxis[index+1] + axisInset
            var point4YValue = self.bounds.height - yAxisDataA[index+1] - axisInset
            
            CGContextMoveToPoint(context, point1XValue, point1YValue)
            CGContextAddLineToPoint(context, point2XValue, point2YValue)
            CGContextAddLineToPoint(context, point3XValue, point3YValue)
            CGContextAddLineToPoint(context, point4XValue, point4YValue)
            CGContextAddLineToPoint(context, point1XValue, point1YValue)
            CGContextFillPath(context)
            
        }
        
    }
    
    
    
    /**
    * Draw x grid.
    */
    func drawXGrid() {
        var space = drawingWidth / numberOfGridLinesX
        var context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, gridColor.CGColor)
        for index in 1...Int(numberOfGridLinesX) {
            CGContextMoveToPoint(context, axisInset + (CGFloat(index) * space), self.bounds.height - axisInset)
            CGContextAddLineToPoint(context, axisInset + (CGFloat(index) * space), axisInset + 30)
        }
        
        CGContextStrokePath(context)
        
    }
    
    
    
    /**
    * Draw y grid.
    */
    func drawYGrid() {
        var height = CGFloat(0)
        var maximumYValue = getMaximumValue()
        var step = Int(maximumYValue) / Int(numberOfGridLinesY)
        step = step == 0 ? 1 : step
        if maximumYValue != 0
        {
            height = drawingHeight / CGFloat(maximumYValue)
        }
        
        var context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, gridColor.CGColor)
        for var index = 0; index <= Int(maximumYValue); index += step {
            CGContextSetFillColorWithColor(context, UIColor.orangeColor().CGColor)
            CGContextMoveToPoint(context, axisInset, self.bounds.height - (CGFloat(index) * height) - axisInset)
            CGContextAddLineToPoint(context, self.bounds.width - axisInset, self.bounds.height - (CGFloat(index) * height) - axisInset)
        }
        CGContextStrokePath(context)
        
    }
    
    func clearAll() {
        self.dataStore.removeAll(keepCapacity: false)
        self.setNeedsDisplay()
    }
    
    /**
    * Draw grid.
    */
    func drawGrid() {
        drawXGrid()
        drawYGrid()
    }
    
    /**
    * Draw Filter Button.
    */
    func drawFilterButtons() {
        var xAxisData = filterButtonArray
        
        var factor = drawingWidth / CGFloat(filterButtonArray.count - 1)
        var scaledDataXAxis: Array<CGFloat> = []
        for index in 0..<filterButtonArray.count {
            var newXValue = factor * CGFloat(index)
            scaledDataXAxis.append(newXValue)
        }
        
        for (index, scaledValue) in enumerate(scaledDataXAxis) {
            var button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
            button.frame = CGRect(x: scaledValue - (axisInset/2), y: self.bounds.origin.x, width: 40, height: axisInset)
            button.setTitle(filterButtonArray[index], forState: UIControlState.Normal)
            button.tag = index
            button.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            button.titleLabel?.font = UIFont(name: "Helvetica",size : fontSize)
            button.userInteractionEnabled = true
            self.userInteractionEnabled = true
            self.addSubview(button)
            self.addSubview(selectedButton)
        }
    }
    
    /**
    * Draw x labels.
    */
    
    func drawXLabels() {
        var xAxisData = xAxisLabelArray
        
        var factor : CGFloat = 0
        
        if xAxislabelArrayHasNoValues
        {
            println("LineGraph : xAxislabelArrayHasNoValues")
        }
        else
        {
            if(xAxisLabelArray.count == 1)
            {
                factor = 0
            }
            else
            {
                factor = drawingWidth / CGFloat(xAxisLabelArray.count - 1)
                
            }
            
            
            var scaledDataXAxis: Array<CGFloat> = []
            
            for index in 0..<xAxisLabelArray.count {
                var newXValue = factor * CGFloat(index)
                scaledDataXAxis.append(newXValue)
                
            }
            for (index, scaledValue) in enumerate(scaledDataXAxis) {
                var label = UILabel(frame: CGRect(x: scaledValue - (axisInset/2), y: self.bounds.height, width: 49, height: axisInset + 15))
                label.font = UIFont.systemFontOfSize(fontSize)
                label.textAlignment = NSTextAlignment.Center
                
                label.text = xAxisLabelArray[index]
                self.addSubview(label)
            }
            
        }
    }
    
    
    
    /**
    * Draw y labels.
    */
    func drawYLabels() {
        if yAxislabelArrayHasNoValues
        { println("LineGraph : yAxislabelArrayHasNoValues")
        }
        else
        {
            
            var factor = drawingHeight / CGFloat(yAxisLabelArray.count - 1)
            var scaledDataYAxis: Array<CGFloat> = []
            for index in 0..<yAxisLabelArray.count {
                var newXValue = factor * CGFloat(index)
                scaledDataYAxis.append(newXValue)
            }
            
            for (index, scaledValue) in enumerate(scaledDataYAxis) {
                var label = UILabel(frame: CGRect(x: -20, y: scaledValue - (axisInset/4) + 30, width: 30, height: axisInset + 10))
                label.font = UIFont.systemFontOfSize(fontSize)
                label.textAlignment = NSTextAlignment.Left
                
                label.text = yAxisLabelArray[index]
                self.addSubview(label)
            }
            
        }
    }
    
    
    
    /**
    * Add line Graph
    */
    func addLine(data: Array<CGFloat>) {
        
        self.dataStore.append(data)
        self.displayLineGraph()
        
    }
    
    func removeLine(index:Int) {
        //      dashPatterns.removeAtIndex(index)
        SwitchdataStore.removeValueForKey(index)
        self.setNeedsDisplay()
    }
    
}