//
//  DFWButton.swift
//  test
//
//  Created by RATHAN, KAPILDEV on 6/21/18.
//  Copyright © 2018 home. All rights reserved.

import UIKit

@IBDesignable
open class DFWButton: UIButton {
  
  @IBInspectable public var selectedBackgroundColor: UIColor?
  @IBInspectable public var highlightedBackgroundColor: UIColor?
  @IBInspectable public var selectedBorderColor: UIColor?
  
  /// A boolean to indicate if the highlighter should extend to match the width to the button's title, or the button's frame. Defaults to false.
  @IBInspectable var wrapsToText : Bool = false
  
  private var normalBackgroundColor: UIColor?
  private var normalBorderColor: UIColor?
  
  override open func awakeFromNib() {
    
    super.awakeFromNib()
    
    self.normalBackgroundColor = self.backgroundColor
    self.normalBorderColor = UIColor.red
  }
  
  override open var isSelected: Bool {
    
    didSet {
      
      let backgroundColor = (self.isSelected ? self.selectedBackgroundColor : nil) ?? self.normalBackgroundColor
      let borderColor = (self.isSelected ? self.selectedBorderColor : nil) ?? self.normalBorderColor
      
      self.backgroundColor = backgroundColor
//      self.borderColor = UIColor.red
    }
  }
  
  override open var isHighlighted: Bool {
    
    didSet {
      
      let highlightedColor = (self.isHighlighted ? self.highlightedBackgroundColor : nil) ?? self.normalBackgroundColor
      
      self.backgroundColor = highlightedColor
    }
  }
  
  // MARK: - tvOS highlighting
  @IBInspectable public var showHighlighter: Bool = false {
    
    didSet {
      
      if showHighlighter, isFocused, self.highlighter == nil {
        
        self.buildHighlighter()
      }
      else if !showHighlighter, let highlighter = self.highlighter {
        
        removeHighlighter(highlighter: highlighter, animated: false)
      }
    }
  }
  
  fileprivate let buttonHighlighterHeight: CGFloat = 4.0
  fileprivate let buttonHighlighterSpacing: CGFloat = 9.0
  
  fileprivate var highlighter: UIView?
  
  fileprivate var highlighterConstraints: [NSLayoutConstraint] = []
  
  override open func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    
    super.didUpdateFocus(in: context, with: coordinator)
    
    guard self.window != nil else {
      
      self.highlighter?.removeFromSuperview()
      self.highlighter = nil
      return
    }
    
    let oldButton = context.previouslyFocusedView as? DFWButton
    let newButton = context.nextFocusedView as? DFWButton
    
    if oldButton == self, newButton == nil, let highlighter = self.highlighter {
      
      removeHighlighter(highlighter: highlighter, animated: true)
    }
    else if newButton == self {
      
      if let oldButton = oldButton,
        oldButton != self,
        let highlighter = oldButton.highlighter,
        let superview = highlighter.superview,
        self.highlighterSuperview() === superview {
        
        superview.removeConstraints(oldButton.highlighterConstraints)
        
        let frame = highlighter.frame
        let buttonFrame = superview.convert(self.frame, from: self.superview)
        
        UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: [.beginFromCurrentState], animations: {
          
          let xConstraint = NSLayoutConstraint(item: highlighter, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: (frame.midX + buttonFrame.midX) * 0.5)
          let topConstraint = NSLayoutConstraint(item: highlighter, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: (frame.minY + buttonFrame.maxY + self.buttonHighlighterSpacing) * 0.5)
          let  widthConstraint = NSLayoutConstraint(item: highlighter, attribute: .width, relatedBy: .equal, toItem: self.wrapsToText ? self.titleLabel : self, attribute: .width, multiplier: 1.5, constant: 0.0)
          
          // Move the highlighter, while increasing its size to 150%
          UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
            
            highlighter.superview?.addConstraints([xConstraint, widthConstraint, topConstraint])
            highlighter.superview?.layoutIfNeeded()
          })
          
          UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
            
            superview.removeConstraints([xConstraint, widthConstraint, topConstraint])
            
            let xConstraint = NSLayoutConstraint(item: highlighter, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
            let topConstraint = NSLayoutConstraint(item: highlighter, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: self.buttonHighlighterSpacing)
            
            let widthConstraint = NSLayoutConstraint(item: highlighter, attribute: .width, relatedBy: .equal, toItem: self.wrapsToText ? self.titleLabel : self, attribute: .width, multiplier: 1.0, constant: 0.0)
            self.highlighterConstraints = [xConstraint, widthConstraint, topConstraint]
            superview.addConstraints(self.highlighterConstraints)
            superview.layoutIfNeeded()
          })
          
        }, completion: nil)
        
        self.highlighter = highlighter
        oldButton.highlighter = nil
      }
      else if self.highlighter == nil {
        
        // If highlight was previously not shown, we animate it onto the selected component.
        self.buildHighlighter()
        guard let highlighter = self.highlighter, let superview = highlighter.superview else {
          return
        }
        
        let xConstraint = NSLayoutConstraint(item: highlighter, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let widthConstraint = NSLayoutConstraint(item: highlighter, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: highlighter, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: buttonHighlighterSpacing)
        
        superview.addConstraints([xConstraint, widthConstraint, topConstraint])
        superview.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
          
          highlighter.alpha = 1
          
          superview.removeConstraint(widthConstraint)
          
          let widthConstraint = NSLayoutConstraint(item: highlighter, attribute: .width, relatedBy: .equal, toItem: self.wrapsToText ? self.titleLabel : self, attribute: .width, multiplier: 1.0, constant: 0.0)
          superview.addConstraint(widthConstraint)
          superview.layoutIfNeeded()
          
          self.highlighterConstraints = [xConstraint, widthConstraint, topConstraint]
          
        }, completion: nil)
      }
    }
  }
  
  private func buildHighlighter() {
    
    guard let superview = self.highlighterSuperview() else {
      return
    }
    
    let highlighter = UIView()
    highlighter.translatesAutoresizingMaskIntoConstraints = false
    highlighter.backgroundColor = UIColor.black
    highlighter.alpha = 0.0
    let heightConstraint = NSLayoutConstraint(item: highlighter, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: buttonHighlighterHeight)
    highlighter.addConstraint(heightConstraint)
    
    superview.addSubview(highlighter)
    
    self.highlighter = highlighter
  }
  
  private func highlighterSuperview() -> UIView? {
    
    // Find the nearest view up the current button's view hierarchy that is full-screen.  That is the view that will contain the highlighter.  This is necessary because otherwise the highlighter would need to switch superviews when moving between certain buttons, and this doesn't play well with swapping out the constraints with the .beginFromCurrent option -- Dan Coleman
    var superview = self.superview
    while let sv = superview, sv.convert(sv.bounds, to: UIApplication.shared.keyWindow) != UIScreen.main.bounds {
      superview = sv.superview
    }
    
    return superview
  }
  
  private func removeHighlighter(highlighter : UIView, animated : Bool) {
    
    if animated {
      highlighter.superview?.removeConstraints(self.highlighterConstraints)
      
      let xConstraint = NSLayoutConstraint(item: highlighter, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
      let widthConstraint = NSLayoutConstraint(item: highlighter, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 0.0)
      let topConstraint = NSLayoutConstraint(item: highlighter, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: buttonHighlighterSpacing)
      
      UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
        
        highlighter.alpha = 0
        highlighter.superview?.addConstraints([xConstraint, widthConstraint, topConstraint])
        highlighter.superview?.layoutIfNeeded()
        
      }, completion: { (finished) in
        
        highlighter.removeFromSuperview()
        self.highlighter = nil
      })
    }
    else {
      highlighter.removeFromSuperview()
      self.highlighter = nil
    }
  }
  
  public func dismissHighlighter() {
    if  let highlighter = self.highlighter {
      removeHighlighter(highlighter: highlighter, animated: true)
    }
  }
}
