//
//  BarGraph.swift
//  BarChart
//
//  Created by Mukhar Gupta on 20/10/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol BarGraphDataSource: NSObjectProtocol{
    
    optional func setMinScaleValue() ->CGFloat
    optional func setMaxScaleValue() -> CGFloat
    optional func xAxisLabelItem() -> [String]
    optional func yAxisLabelItem() -> [String]
    optional func barGradientColors() -> Array <AnyObject>
    optional func showGrid() -> Bool
    optional func showXAxis() -> Bool
    optional func showYAxis() ->Bool
    optional func showXLabel() -> Bool
    optional func showYLabel() -> Bool
    optional func animationEnabled() -> Bool
    
    
}


public class BarGraph: UIView {
    var dataArray:[Array<CGFloat>] = []
    public var dataSource:BarGraphDataSource?
    var barGraphDataArray:[CGFloat]!
    var xAxisVisible = true
    var yAxisVisible = true
    var labelXAxisVisible = true
    var labelYAxisVisible = true
    var gridVisible = true
    var animationVisible = true
    var drawGrid = true
    var xAxislabelArray : [String]?
    var yAxislabelArray : [String]?
    var drawingRect:CGRect!
    var drawingHeight: CGFloat!
    var drawingWidth: CGFloat!
    var BarLayerStore: Array<CAGradientLayer> = []
    //properties
    var durationStep = 0.1
    var xAxisOffset:CGFloat = 40
    var yAxisOffset:CGFloat = 30
    var distanceBetweenTwoBars:CGFloat = 50
    var distanceOfFirstBarFromAxis:CGFloat = 40
    var barWidth:CGFloat = 15
    var animationDuration:CFTimeInterval = 2
    var gridLineColor = UIColor.blackColor()
    var gridLineWidth:CGFloat = 0.5
    var fontSizeForLabel:CGFloat = 14
    var barColor :UIColor = UIColor.blackColor()
    //    var colorOneGradient  = UIColor.blackColor().CGColor
    //    var colorTwoGradient = UIColor.blackColor().CGColor
    
    var xAxislabelArrayHasNoValues = false
    var yAxislabelArrayHasNoValues = false
    
    var touchAreas:[CGRect] = [CGRect]()
    var axisColor: UIColor = UIColor.blackColor()
    
    var barColors: Array <AnyObject>?
    
    var background_Color: UIColor = UIColor.whiteColor()
    var xAxisLabelColor: UIColor = UIColor.blackColor()
    var yAxisLabelColor: UIColor = UIColor.blackColor()
    var xAxisColor: UIColor = UIColor.blackColor()
    var yAxisColor: UIColor = UIColor.blackColor()
    var colorOne = UIColor(red: (0.0/255.0), green: (255.0/255.0), blue: (255/255.0), alpha: 1.0).CGColor
    var colorTwo = UIColor(red: (0.0/255.0), green: (146/255.0), blue: (146/255.0), alpha: 1.0).CGColor
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        
        if UIDevice.currentDevice().model == "iPhone Simulator" || UIDevice.currentDevice().model == "iPhone"{
            fontSizeForLabel = 9
        }
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func drawRect(rect: CGRect) {
        
        var context:CGContextRef = UIGraphicsGetCurrentContext()
        
        if dataSource != nil{
            
            if let isXAxis = dataSource?.showXAxis?(){
                xAxisVisible = isXAxis
            }
            if let isYAxis = dataSource?.showYAxis?(){
                yAxisVisible = isYAxis
            }
            if let isXLabel = dataSource?.showXLabel?(){
                labelXAxisVisible = isXLabel
            }
            if let isYLabel = dataSource?.showYLabel?(){
                labelYAxisVisible = isYLabel
            }
            if let isGrid = dataSource?.showGrid?(){
                gridVisible = isGrid
            }
            if let isAnimation = dataSource?.animationEnabled?(){
                animationVisible  = isAnimation
            }
            
            if let isGrid = dataSource?.showGrid?(){
                drawGrid = isGrid
            }
            
            
            if let yAxislabel = dataSource?.yAxisLabelItem?(){
                yAxislabelArray = yAxislabel
            }
            
            
        }
        
        if yAxisVisible{
            drawAxis(context, fromPoint: CGPointMake(drawingRect.origin.x, drawingRect.origin.y), toPoint: CGPointMake(drawingRect.origin.x, drawingRect.maxY), lineColor: yAxisColor, lineWidth: 1)
        }
        
        if xAxisVisible{
            drawAxis(context, fromPoint: CGPointMake(drawingRect.origin.x, drawingRect.maxY), toPoint: CGPointMake(drawingRect.maxX, drawingRect.maxY), lineColor: xAxisColor, lineWidth: 1)
        }
        
        if labelYAxisVisible{
            drawYAxisLabel(context)
        }
        
    }
    
    
    /** initBarGraph is used to initialize the data for barChart,X-Axis Label data,Y-Axis Label data
    ,Distance Between Two Bars .
    */
    public func initBarGraph(dataArray : [Array<CGFloat>],xAxislabelArray : [String],yAxislabelArray : [String],distanceBetweenTwoBars : CGFloat = 50, colorOne: CGColor = UIColor(red: (0.0/255.0), green: (255.0/255.0), blue: (255/255.0), alpha: 1.0).CGColor, colorTwo: CGColor = UIColor(red: (0.0/255.0), green: (146/255.0), blue: (146/255.0), alpha: 1.0).CGColor, barWidth: CGFloat = 15, animationVisible: Bool = true)
    {
        var dataArrayHasNegeativeValues = false
        for data in dataArray
        {
            for value in data
            {
                if value < 0
                {
                    println("dataArray has negeative values")
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
        
        if xAxislabelArray == []
        {
            xAxislabelArrayHasNoValues = true
            println("xAxislabelArray is empty")
            
        }
            
        else
        {
            self.xAxislabelArray = xAxislabelArray
            
        }
        
        if yAxislabelArray == []
        {
            yAxislabelArrayHasNoValues = true
            println("yAxislabelArray is empty")
        }
        else
        {
            self.yAxislabelArray = yAxislabelArray
        }
        
        
        
        self.distanceBetweenTwoBars = distanceBetweenTwoBars
        self.drawingHeight = self.bounds.height - yAxisOffset * 2
        self.drawingWidth = self.bounds.width - xAxisOffset * 2
        self.colorOne = colorOne
        self.colorTwo = colorTwo
        self.barWidth = barWidth
        self.animationVisible = animationVisible
        
        //drawing rect represents the actual area in which the graph will be...offsets defined will be used to add labels
        drawingRect = CGRect(x: bounds.origin.x + xAxisOffset , y: bounds.origin.y + yAxisOffset, width: drawingWidth, height: drawingHeight)
        self.setNeedsDisplay()
        
    }
    
    
    public func initCustom(fontSizeForLabel: CGFloat = 14, gridLineColor: UIColor =  UIColor.blackColor(), gridLineWidth: CGFloat = 0.5, xAxisLabelColor: UIColor = UIColor.blackColor(), yAxisLabelColor: UIColor = UIColor.blackColor(), xAxisColor: UIColor = UIColor.blackColor(), yAxisColor:UIColor = UIColor.blackColor())
    {
        self.fontSizeForLabel = fontSizeForLabel
        self.gridLineColor = gridLineColor
        self.gridLineWidth = gridLineWidth
        self.xAxisLabelColor = xAxisLabelColor
        self.yAxisLabelColor = yAxisLabelColor
        self.xAxisColor = xAxisColor
        self.yAxisColor = yAxisColor
        self.setNeedsDisplay()
    }
    
    public func initBackground(background_Color: UIColor = UIColor.whiteColor())
    {
        self.background_Color = background_Color
        self.backgroundColor = background_Color
        self.setNeedsDisplay()
    }
    /** displayBarGraph is used to display bar chart on the specified view
    */
    public func displayBarGraph()
    {
        
        var barColorsArray = barGradientColors()
        barColors = barColorsArray
        
        var numberOfLines = dataArray.count
        if numberOfLines > 0
        {
            for index in 0...numberOfLines - 1 {
                barGraphDataArray = dataArray[index]
                self.drawBarGraph()
            }
        }
        
        
    }
    /** reloadBarGraphWithNewData is used to redisplay bar chart with the specified data
    */
    public func reloadBarGraphWithNewData (dataArray : [Array<CGFloat>])
    {
        removeBarChart()
        println("dataArray\(self.dataArray)")
        initBarGraph(dataArray,xAxislabelArray: xAxislabelArray!,yAxislabelArray: yAxislabelArray!,distanceBetweenTwoBars  : distanceBetweenTwoBars, colorOne: colorOne, colorTwo: colorTwo, barWidth: barWidth, animationVisible: animationVisible)
        initCustom(fontSizeForLabel: fontSizeForLabel, gridLineColor: gridLineColor, gridLineWidth: gridLineWidth, xAxisLabelColor: xAxisLabelColor, yAxisLabelColor: yAxisLabelColor, xAxisColor: xAxisColor, yAxisColor: yAxisColor)
        initBackground(background_Color: background_Color)
        displayBarGraph()
    }
    
    func drawBarGraph(){
        var i = 0
        for item in barGraphDataArray{
            var barX = drawingRect.minX + distanceOfFirstBarFromAxis + (CGFloat(i) * distanceBetweenTwoBars - barWidth/2)
            var barY = convertGraphPointYToCoordinateY(item)
            var barHeight = drawingRect.maxY - barY
            var barRect = CGRectMake(barX, barY, barWidth, barHeight)
            drawBar(barRect)
            touchAreas.insert(barRect, atIndex: i)
            //drawing x axis labels
            if labelXAxisVisible{
                drawXAxisLabel(i,barRect: barRect)
            }
            
            i += 1
        }
    }
    
    /** removeBarChart is used to remove bar chart from the view
    */
    public func removeBarChart()
    {
        for barLayer in BarLayerStore {
            barLayer.removeFromSuperlayer()
        }
        // BarLayerStore.removeAll(keepCapacity: false)
    }
    func drawBar(rect: CGRect){
        if !xAxislabelArrayHasNoValues || !yAxislabelArrayHasNoValues
        {
            var position = CGPointMake(((CGRectGetMaxX(rect)+CGRectGetMinX(rect)))/2, CGRectGetMaxY(rect))
            
            var anchorPoint = CGPointMake(0.5,1)
            
            
            //if color gradient is applied
            if barColors?.count > 1 {
                
                var locations = [0.0,1.0]
                
                var subLayer = CAGradientLayer()
                
                subLayer.colors = barColors
                
                subLayer.anchorPoint = CGPointMake(0.5, 1)
                
                subLayer.locations = locations
                
                subLayer.position = position
                
                subLayer.frame = rect
                
                
                if animationVisible{
                    var anime = CABasicAnimation(keyPath: "transform.scale.y")
                    anime.fromValue =  NSNumber ( float: 0)
                    anime.toValue = NSNumber(float : 1)
                    anime.fillMode = kCAFillModeBoth
                    anime.autoreverses=false; // To prevent the animation from reverting back
                    anime.removedOnCompletion = false  //To make sure animated graph is retained
                    anime.beginTime = CACurrentMediaTime() + Double(durationStep)
                    durationStep +=  0.1
                    anime.duration = animationDuration
                    
                    subLayer.addAnimation(anime, forKey: nil)
                }
                BarLayerStore.append(subLayer)
                layer.insertSublayer(subLayer, atIndex: 0)
                //self.layer.addSublayer(sublayer)
                
                
                
                
            }
                // if color graident is not applied
            else{
                
                var subLayer = CALayer()
                subLayer.frame = rect
                subLayer.position = position
                subLayer.backgroundColor = barColor.CGColor
                subLayer.anchorPoint = anchorPoint
                
                
                if animationVisible{
                    var anime = CABasicAnimation(keyPath: "transform.scale.y")
                    anime.fromValue =  NSNumber ( float: 0)
                    anime.toValue = NSNumber(float : 1)
                    anime.fillMode = kCAFillModeBoth
                    anime.autoreverses=false; // To prevent the animation from reverting back
                    anime.removedOnCompletion = false  //To make sure animated graph is retained
                    anime.beginTime = CACurrentMediaTime() + Double(durationStep)
                    durationStep +=  0.1
                    anime.duration = animationDuration
                    
                    subLayer.addAnimation(anime, forKey: nil)
                }
                layer.insertSublayer(subLayer, atIndex: 0)
                //self.layer.addSublayer(sublayer)
                
                
            }
            
        }
    }
    
    // draw axis
    func drawAxis(context: CGContextRef, fromPoint:CGPoint, toPoint: CGPoint, lineColor:UIColor, lineWidth: CGFloat){
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        CGContextSetStrokeColorWithColor(context, lineColor.CGColor)
        CGContextSetLineWidth(context, lineWidth)
        CGContextStrokePath(context)
    }
    
    
    
    //drawGrid
    func drawGridLine(xPoint:CGFloat, yPoint:CGFloat, context: CGContextRef){
        var start = CGPointMake(xPoint + 20, yPoint)
        var end = CGPointMake(drawingRect.maxX , yPoint)
        drawAxis(context, fromPoint: start, toPoint: end, lineColor: gridLineColor, lineWidth:gridLineWidth)
    }
    
    
    // draw y axis labels
    func drawYAxisLabel(ctx:CGContextRef){
        if !yAxislabelArrayHasNoValues
        {
            var factor = drawingRect.height / CGFloat(yAxislabelArray!.count - 1)
            
            for index in 0..<yAxislabelArray!.count{
                var label3 = UILabel(frame: CGRectMake(0, 0, 400, 15))
                var labelX3 : CGFloat = drawingRect.origin.x - 20
                var labelY3 : CGFloat = drawingRect.maxY - (CGFloat(index) * factor)
                
                
                if drawGrid{
                    if index != 0{
                        drawGridLine(labelX3, yPoint: labelY3, context:ctx)
                        
                    }
                }
                label3.center = CGPointMake(labelX3 , labelY3)
                label3.textAlignment = NSTextAlignment.Center
                label3.font = UIFont(name: "Helvetica", size: fontSizeForLabel)
                label3.text = yAxislabelArray![index]
                label3.textColor = yAxisLabelColor
                self.addSubview(label3)
            }
        }
    }
    
    
    
    //draw x axis labels
    func drawXAxisLabel(index:Int, barRect:CGRect){
        
        var label3 = UILabel(frame: CGRectMake(0, 0, 400, 15))
        var labelX3 : CGFloat = barRect.midX
        var labelY3 : CGFloat = barRect.maxY + 12
        label3.center = CGPointMake(labelX3 , labelY3)
        label3.textAlignment = NSTextAlignment.Center
        label3.font = UIFont(name: "Helvetica", size: fontSizeForLabel)
        if !xAxislabelArrayHasNoValues
        {
            label3.text = xAxislabelArray![index]
        }
        label3.textColor = xAxisLabelColor
        self.addSubview(label3)
    }
    
    
    
    // function to find y point of barRect corresponding to the value
    
    func convertGraphPointYToCoordinateY(point:CGFloat) -> CGFloat
    {
        var convertedPointY:CGFloat = 0
        if yAxislabelArrayHasNoValues{
            println("no values..!!")
            println(yAxislabelArrayHasNoValues)
        }
        else{
            
            var factor = drawingRect.height / CGFloat(yAxislabelArray!.count - 1 )
            
            var diffY = CGFloat( (yAxislabelArray![1] as NSString).floatValue - (yAxislabelArray![0] as NSString).floatValue )
            
            var initialY = CGFloat((yAxislabelArray![0] as NSString).floatValue) - diffY
            
            convertedPointY = (drawingRect.maxY) - (((point)/diffY) * factor)
        }
        return convertedPointY
        
    }
    
    func didSelectBarAtIndex(barIndex: Int, barValue: CGFloat) {
        
    }
    func barGradientColors() -> Array<AnyObject> {
        let c: Array <AnyObject> = [colorOne!, colorTwo!]
        return c
        
    }
    
    // method to detect touch
    
    //    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    //
    //        var touch:UITouch = touches.anyObject() as UITouch
    //        var point:CGPoint = touch.locationInView(self)
    //
    //        for i in 0..<barGraphDataArray.count
    //        {
    //            if (CGRectContainsPoint(touchAreas[i], point))
    //            {
    //                didSelectBarAtIndex(i, barValue: barGraphDataArray[i])
    //
    //                break;
    //            }
    //        }
    //
    //    }
    
}