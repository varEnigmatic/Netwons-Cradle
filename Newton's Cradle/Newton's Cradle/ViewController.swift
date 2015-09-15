//
//  ViewController.swift
//  Newton's Cradle
//
//  Created by Dapeng Gao on 14/6/15.
//  Copyright © 2015 Dapeng Gao. All rights reserved.
//

import UIKit

private let numberOfBalls = 5

private let ballDiameter: CGFloat = 80
private let anchorDiameter: CGFloat = 20
private let decorationDiameter = ballDiameter / 5

private let yBegin: CGFloat = 150
private let length: CGFloat = 300

private let initialVelocity: CGFloat = 500

class ViewController: UIViewController {

    private var animator: UIDynamicAnimator!
    private let itemBehavior = UIDynamicItemBehavior()

    private var balls: [(ball: Ball, bearing: UIView)] = []

    @IBOutlet private weak var forceButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator(referenceView: view)
    }

    @IBAction private func start(sender: UIButton) {
        sender.hidden = true
        forceButton.hidden = false
        setUp()
    }

    private func setUp() {

        let xBegin = (view.bounds.width - CGFloat(numberOfBalls - 1) * ballDiameter) / 2
        let xEnd = view.bounds.width - xBegin

        let gravityBehavior = UIGravityBehavior()
        let collisionBehavior = UICollisionBehavior()

        for x in xBegin.stride(through: xEnd, by: ballDiameter) {

            let bearing = UIView(frame: CGRect(x: 0, y: 0, width: anchorDiameter, height: anchorDiameter))
            bearing.center = CGPoint(x: x, y: yBegin)
            bearing.backgroundColor = .greenColor()
            bearing.layer.cornerRadius = anchorDiameter / 2

            let ball = Ball(frame: CGRect(x: 0, y: 0, width: ballDiameter, height: ballDiameter))
            ball.center = CGPoint(x: x, y: yBegin + length)
            ball.backgroundColor = .lightGrayColor()
            ball.layer.cornerRadius = ballDiameter / 2

            let decoration = UIView(frame: CGRect(x: 0, y: 0, width: decorationDiameter, height: decorationDiameter))
            decoration.center.x = view.convertPoint(ball.center, toCoordinateSpace: ball).x
            decoration.backgroundColor = .redColor()
            decoration.layer.cornerRadius = decorationDiameter

            ball.addSubview(decoration)
            view.addSubview(ball)
            view.addSubview(bearing)

            let attachmentBehavior = UIAttachmentBehavior(item: ball, attachedToAnchor: bearing.center)
            animator.addBehavior(attachmentBehavior)

            gravityBehavior.addItem(ball)
            collisionBehavior.addItem(ball)
            itemBehavior.addItem(ball)

            balls.append(ball: ball, bearing: bearing)
        }

        itemBehavior.elasticity = 1
        itemBehavior.friction = 0
        itemBehavior.resistance = 0
        itemBehavior.angularResistance = 0
        itemBehavior.allowsRotation = true

        animator.addBehavior(gravityBehavior)
        animator.addBehavior(collisionBehavior)
        animator.addBehavior(itemBehavior)
    }

    @IBAction private func applyForce() {
        itemBehavior.addLinearVelocity(CGPoint(x: initialVelocity, y: 0), forItem: balls.last!.ball)
    }
}

private class Ball: UIView {
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .Ellipse
    }
}
