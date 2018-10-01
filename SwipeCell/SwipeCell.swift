//
//  SwipeCell.swift
//  Comic_Collector
//
//  Created by Dennis Müller on 10.04.18.
//  Copyright © 2018 Dennis Müller. All rights reserved.
//

import UIKit
import SnapKit

public enum ActionPanState {
    case isClosed
    case isMoving
    case hasSnappedOpen
}

public enum SwipeCellActionState {
    case isClosed
    case isMoving
    case hasSnappedOpen
}

public class SwipeCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    
    
    // MARK: - Properties
    // ========== PROPERTIES ==========
    var swipeCellActions: [SwipeCell.Action] {
        return []
    }
    
    private var cellSwipeConfirmed: Bool = false
    public weak var actionDelegate: SwipeCellActionDelegate? = nil
    fileprivate var holderViewWidthXConstraint: Constraint? = nil
    fileprivate var holderViewOffset: CGFloat = 0 {
        didSet {
            holderViewWidthXConstraint?.update(offset: holderViewOffset)
        }
    }
    
    private var actionState: SwipeCellActionState {
        switch holderViewOffset {
        case 0:
            return .isClosed
        case -swipeWidth:
            return .hasSnappedOpen
        default:
            return .isMoving
        }
    }
    
    public var areButtonsSnappedOpen: Bool {
        return actionState == .hasSnappedOpen
    }
    
    public var swipeWidth: CGFloat {
        return 2 * contentView.frame.width / 3
    }
    
    fileprivate var panGestureRecognizer: UIPanGestureRecognizer!
    fileprivate var tapGestureRecognizer: UITapGestureRecognizer!
    
    public var swipeActionEnabled: Bool = false {
        didSet {
            tapGestureRecognizer.isEnabled = swipeActionEnabled
            panGestureRecognizer.isEnabled = swipeActionEnabled
        }
    }
    
    fileprivate lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.isUserInteractionEnabled = true
        
        contentView.addSubview(stackView)
        return stackView
    }()
    
    lazy public var holderView: UIView = {
        let view = UIView()
        
        contentView.addSubview(view)
        return view
    }()
    // ====================
    
    // MARK: - Initializers
    // ========== INITIALIZERS ==========
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        
        holderView.snp.makeConstraints { (make) in
            self.holderViewWidthXConstraint = make.centerX.equalToSuperview().constraint
            make.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.holderView.snp.trailing)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handle(tap:)))
        buttonStackView.addGestureRecognizer(tapGestureRecognizer)
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handle(pan:)))
        addGestureRecognizer(panGestureRecognizer)
        
        // off by default
        tapGestureRecognizer.isEnabled = false
        panGestureRecognizer.isEnabled = false
        panGestureRecognizer.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    // ====================
    
    // MARK: - Overrides
    // ========== OVERRIDES ==========
    // ====================
    
    
    // MARK: - Functions
    // ========== FUNCTIONS ==========
    public func swipeHasBegun() {}
    
    @objc private func otherCellWantsToSwipeOpen(notif: Notification) {
        closeButtons()
        
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: [], animations: {
            self.layoutIfNeeded()
        }, completion: { (finished) in
            if self.actionState == .isClosed {
                self.removeButtons()
            }
        })
    }
    
    @objc private func handle(tap: UITapGestureRecognizer) {
        let location = tap.location(in: buttonStackView)
        for holder in buttonStackView.arrangedSubviews {
            if let action = holder as? SwipeCell.Action, action.frame.contains(location) {
                actionDelegate?.didTapOnAction(action)
                
                // close
                closeButtons()
                UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: [], animations: {
                    self.layoutIfNeeded()
                }, completion: { (finished) in
                    if self.actionState == .isClosed {
                        self.removeButtons()
                    }
                })
                
            }
        }
    }
    
    @objc private func handle(pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: contentView)
        
        switch pan.state {
        case .began:
            
            if actionState == .isClosed {
                cellSwipeConfirmed = false // first set it to false!
                
                // check if its a cell swipe
                let velocity = pan.velocity(in: contentView)
                let verticalToHorizontalVelocity = velocity.y / velocity.x
                if verticalToHorizontalVelocity.isInfinite || abs(verticalToHorizontalVelocity) < 0.28 {
                    cellSwipeConfirmed = true
                    createButtonsFromDelegate()
                    swipeHasBegun()
                    
                    // Post a notification to all cells with open swipeActions
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SwipeCellOpenNotification"), object: nil)
                    
                    (superview as! UICollectionView).isScrollEnabled = false
                } else {
                    pan.isEnabled = false
                    pan.isEnabled = true
                }
            } else if actionState == .hasSnappedOpen {
                (superview as! UICollectionView).isScrollEnabled = false
                swipeHasBegun()
            }
            
        case .changed:
            guard cellSwipeConfirmed else { return }
            
            if holderView.frame.origin.x + translation.x > 0.0 {
                holderViewOffset = 0.0
            } else if holderViewOffset + translation.x < -1.2 * swipeWidth {
                holderViewOffset += 1/10 * translation.x
            } else {
                holderViewOffset += translation.x
            }
            pan.setTranslation(.zero, in: contentView)
            layoutIfNeeded()
            
            if !cellSwipeConfirmed {
                
            } else {
                
            }
        case .ended:
            (superview as! UICollectionView).isScrollEnabled = true
            checkSnap(endVelocity: pan.velocity(in: contentView))
            
            UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: [], animations: {
                self.layoutIfNeeded()
            }, completion: { (finished) in
                if self.actionState == .isClosed {
                    self.removeButtons()
                }
            })
        default:
            break
        }
    }
    
    fileprivate func createButtonsFromDelegate() {
        removeButtons() // to be safe
        for action in swipeCellActions {
            buttonStackView.addArrangedSubview(action)
        }
    }
    fileprivate func removeButtons() {
        for view in buttonStackView.arrangedSubviews {
            buttonStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    fileprivate func checkSnap(endVelocity velocity: CGPoint) {
        if velocity.x < -250 || holderViewOffset < -0.8 * swipeWidth {
            openButtons()
        } else if velocity.x > 250 {
            closeButtons()
        } else {
            closeButtons()
        }
    }
    
    fileprivate func closeButtons() {
        holderViewOffset = 0
        tapGestureRecognizer.isEnabled = false
        
        // Remove observer
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "SwipeCellOpenNotification"), object: nil)
    }
    
    fileprivate func openButtons() {
        holderViewOffset = -swipeWidth
        tapGestureRecognizer.isEnabled = true
        
        // Register as an observer
        NotificationCenter.default.addObserver(self, selector: #selector(otherCellWantsToSwipeOpen), name: NSNotification.Name(rawValue: "SwipeCellOpenNotification"), object: nil)
    }
    
    private func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        //        if gestureRecognizer.view != otherGestureRecognizer.view {
        //            return false
        //        }
        
        return true
    }
    // ====================
    
    
}
