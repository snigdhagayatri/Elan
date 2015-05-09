//
//  SideBar.swift
//  SideBar
//
//  Created by Ashima on 09/03/15.
//  Copyright (c) 2015 Ashima. All rights reserved.
//

import UIKit
@objc protocol SideBarDelegate{
    
    func sideBarDidSelectButtonAtIndex(index: Int)
    optional func sideBarWillOpen()
    optional func sideBarWillClose()
}


class SideBar: NSObject, sideBarTableViewControllerDelegate {
    
    let barWidth: CGFloat = 150.0
    let sideBarTableViewTopInset: CGFloat = 64.0
    let sideBArContainerView: UIView = UIView()
    let sideBarTableViewController: SideBarTableViewController = SideBarTableViewController()
    let originView: UIView!
    
    var animator: UIDynamicAnimator!
    var delegate: SideBarDelegate?
    var isSideBarOpen: Bool = false
    
    override init()
    {
        super.init()
    }
    
    init(sourceView: UIView, menuItems: Array<String>)
    {
        super.init()
        originView = sourceView
        sideBarTableViewController.tableData = menuItems
        
        setupSideBar()
        
        animator = UIDynamicAnimator(referenceView: originView)
        
        let showGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        showGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Right
        originView.addGestureRecognizer(showGestureRecognizer)
        
        let hideGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        hideGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        originView.addGestureRecognizer(hideGestureRecognizer)
        
        
    }
    
    func setupSideBar()
    {
        sideBArContainerView.frame = CGRectMake(-barWidth-1, originView.frame.origin.y, barWidth, originView.frame.size.height)
        sideBArContainerView.backgroundColor = UIColor.clearColor()
        sideBArContainerView.clipsToBounds = false
        
        originView.addSubview(sideBArContainerView)
        
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        blurView.frame = sideBArContainerView.bounds
        sideBArContainerView.addSubview(blurView)
        
        sideBarTableViewController.delegate = self
        sideBarTableViewController.tableView.frame = sideBArContainerView.bounds
        sideBarTableViewController.tableView.clipsToBounds = false
        sideBarTableViewController.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        sideBarTableViewController.tableView.backgroundColor = UIColor.clearColor()
        sideBarTableViewController.tableView.scrollsToTop = false
        sideBarTableViewController.tableView.contentInset = UIEdgeInsetsMake(sideBarTableViewTopInset, 0, 0, 0)
        
        sideBarTableViewController.tableView.reloadData()
        sideBArContainerView.addSubview(sideBarTableViewController.tableView)
        
    }
    
    func handleSwipe(recognizer: UISwipeGestureRecognizer)
    {
        if recognizer.direction == UISwipeGestureRecognizerDirection.Left
        {
            showSideBar(false)
            delegate?.sideBarWillClose?()
        }
        else
        {
            showSideBar(true)
            delegate?.sideBarWillOpen?()
        }
    }
    
    func showSideBar(shouldOpen:Bool)
    {
        animator.removeAllBehaviors()
        isSideBarOpen = shouldOpen
        
        let gravityX: CGFloat = (shouldOpen) ? 0.5 : -0.5
        let magnitude: CGFloat = (shouldOpen) ? 20 : -20
        let boundaryX : CGFloat = (shouldOpen) ? barWidth : -barWidth-1
        
        let gravityBehavior: UIGravityBehavior = UIGravityBehavior(items: [sideBArContainerView])
        gravityBehavior.gravityDirection = CGVectorMake(gravityX, 0)
        animator.addBehavior(gravityBehavior)
        
        let collisionBehavior: UICollisionBehavior = UICollisionBehavior(items: [sideBArContainerView])
        collisionBehavior.addBoundaryWithIdentifier("sideBarBound", fromPoint: CGPointMake(boundaryX, 20), toPoint: CGPointMake(boundaryX, originView.frame.size.height))
        animator.addBehavior(collisionBehavior)
        
        let pushBehavior: UIPushBehavior = UIPushBehavior(items: [sideBArContainerView], mode: UIPushBehaviorMode.Instantaneous)
        pushBehavior.magnitude = magnitude
        animator.addBehavior(pushBehavior)
        
        let sideBarBehavior: UIDynamicItemBehavior = UIDynamicItemBehavior(items: [sideBArContainerView])
        sideBarBehavior.elasticity = 0.3
        animator.addBehavior(sideBarBehavior)
        
        
    }
    
    
    
    func sideBarControlDidSelectRow(IndexPath: NSIndexPath) {
        
        delegate?.sideBarDidSelectButtonAtIndex(IndexPath.row)
        
    }
   
}
