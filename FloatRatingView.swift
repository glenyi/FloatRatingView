//
//  FloatRatingView.swift
//  Rating Demo
//
//  Created by Glen Yi on 2014-09-05.
//  Copyright (c) 2014 On The Pursuit. All rights reserved.
//

import UIKit

@objc public protocol FloatRatingViewDelegate {
    /**
    Returns the rating value when touch events end
    */
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float)
    
    /**
    Returns the rating value as the user pans
    */
    optional func floatRatingView(ratingView: FloatRatingView, isUpdating rating: Float)
}

/**
A simple rating view that can set whole, half or floating point ratings.
*/
@IBDesignable
public class FloatRatingView: UIView {
    
    // MARK: Float Rating View properties
    
    public weak var delegate: FloatRatingViewDelegate?
    
    /**
    Array of empty image views
    */
    private var emptyImageViews: [UIImageView] = []
    
    /**
    Array of full image views
    */
    private var fullImageViews: [UIImageView] = []

    /**
    Sets the empty image (e.g. a star outline)
    */
    @IBInspectable public var emptyImage: UIImage? {
        didSet {
            // Update empty image views
            for imageView in self.emptyImageViews {
                imageView.image = emptyImage
            }
            self.refresh()
        }
    }
    
    /**
    Sets the full image that is overlayed on top of the empty image.
    Should be same size and shape as the empty image.
    */
    @IBInspectable public var fullImage: UIImage? {
        didSet {
            // Update full image views
            for imageView in self.fullImageViews {
                imageView.image = fullImage
            }
            self.refresh()
        }
    }
    
    /**
    Sets the empty and full image view content mode.
    */
    var imageContentMode: UIViewContentMode = UIViewContentMode.ScaleAspectFit
    
    /**
    Minimum rating.
    */
    @IBInspectable public var minRating: Int  = 0 {
        didSet {
            // Update current rating if needed
            if self.rating < Float(minRating) {
                self.rating = Float(minRating)
                self.refresh()
            }
        }
    }
    
    /**
    Max rating value.
    */
    @IBInspectable public var maxRating: Int = 5 {
        didSet {
            let needsRefresh = maxRating != oldValue
            
            if needsRefresh {
                self.removeImageViews()
                self.initImageViews()
                
                // Relayout and refresh
                self.setNeedsLayout()
                self.refresh()
            }
        }
    }
    
    /**
    Minimum image size.
    */
    @IBInspectable public var minImageSize: CGSize = CGSize(width: 5.0, height: 5.0)
    
    /**
    Set the current rating.
    */
    @IBInspectable public var rating: Float = 0 {
        didSet {
            if rating != oldValue {
                self.refresh()
            }
        }
    }
    
    /**
    Sets whether or not the rating view can be changed by panning.
    */
    @IBInspectable public var editable: Bool = true
    
    /**
    Ratings change by 0.5. Takes priority over floatRatings property.
    */
    @IBInspectable public var halfRatings: Bool = false
    
    /**
    Ratings change by floating point values.
    */
    @IBInspectable public var floatRatings: Bool = false
    
    
    // MARK: Initializations
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initImageViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initImageViews()
    }
    
    // MARK: Refresh hides or shows full images
    
    func refresh() {
        for i in 0..<self.fullImageViews.count {
            let imageView = self.fullImageViews[i]
            
            if self.rating>=Float(i+1) {
                imageView.layer.mask = nil
                imageView.hidden = false
            }
            else if self.rating>Float(i) && self.rating<Float(i+1) {
                // Set mask layer for full image
                let maskLayer = CALayer()
                maskLayer.frame = CGRectMake(0, 0, CGFloat(self.rating-Float(i))*imageView.frame.size.width, imageView.frame.size.height)
                maskLayer.backgroundColor = UIColor.blackColor().CGColor
                imageView.layer.mask = maskLayer
                imageView.hidden = false
            }
            else {
                imageView.layer.mask = nil;
                imageView.hidden = true
            }
        }
    }
    
    // MARK: Layout helper classes
    
    // Calculates the ideal ImageView size in a given CGSize
    func sizeForImage(image: UIImage, inSize size:CGSize) -> CGSize {
        let imageRatio = image.size.width / image.size.height
        let viewRatio = size.width / size.height
        
        if imageRatio < viewRatio {
            let scale = size.height / image.size.height
            let width = scale * image.size.width
            
            return CGSizeMake(width, size.height)
        }
        else {
            let scale = size.width / image.size.width
            let height = scale * image.size.height
            
            return CGSizeMake(size.width, height)
        }
    }
    
    // Override to calculate ImageView frames
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if let emptyImage = self.emptyImage {
            let desiredImageWidth = self.frame.size.width / CGFloat(self.emptyImageViews.count)
            let maxImageWidth = max(self.minImageSize.width, desiredImageWidth)
            let maxImageHeight = max(self.minImageSize.height, self.frame.size.height)
            let imageViewSize = self.sizeForImage(emptyImage, inSize: CGSizeMake(maxImageWidth, maxImageHeight))
            let imageXOffset = (self.frame.size.width - (imageViewSize.width * CGFloat(self.emptyImageViews.count))) /
                                CGFloat((self.emptyImageViews.count - 1))
            
            for i in 0..<self.maxRating {
                let imageFrame = CGRectMake(i==0 ? 0:CGFloat(i)*(imageXOffset+imageViewSize.width), 0, imageViewSize.width, imageViewSize.height)
                
                var imageView = self.emptyImageViews[i]
                imageView.frame = imageFrame
                
                imageView = self.fullImageViews[i]
                imageView.frame = imageFrame
            }
            
            self.refresh()
        }
    }
    
    func removeImageViews() {
        // Remove old image views
        for i in 0..<self.emptyImageViews.count {
            var imageView = self.emptyImageViews[i]
            imageView.removeFromSuperview()
            imageView = self.fullImageViews[i]
            imageView.removeFromSuperview()
        }
        self.emptyImageViews.removeAll(keepCapacity: false)
        self.fullImageViews.removeAll(keepCapacity: false)
    }
    
    func initImageViews() {
        if self.emptyImageViews.count != 0 {
            return
        }
        
        // Add new image views
        for _ in 0..<self.maxRating {
            let emptyImageView = UIImageView()
            emptyImageView.contentMode = self.imageContentMode
            emptyImageView.image = self.emptyImage
            self.emptyImageViews.append(emptyImageView)
            self.addSubview(emptyImageView)
            
            let fullImageView = UIImageView()
            fullImageView.contentMode = self.imageContentMode
            fullImageView.image = self.fullImage
            self.fullImageViews.append(fullImageView)
            self.addSubview(fullImageView)
        }
    }
    
    // MARK: Touch events
    
    // Calculates new rating based on touch location in view
    func handleTouchAtLocation(touchLocation: CGPoint) {
        if !self.editable {
            return
        }
        
        var newRating: Float = 0
        for i in (self.maxRating-1).stride(through: 0, by: -1) {
            let imageView = self.emptyImageViews[i]
            if touchLocation.x > imageView.frame.origin.x {
                // Find touch point in image view
                let newLocation = imageView.convertPoint(touchLocation, fromView:self)
                
                // Find decimal value for float or half rating
                if imageView.pointInside(newLocation, withEvent: nil) && (self.floatRatings || self.halfRatings) {
                    let decimalNum = Float(newLocation.x / imageView.frame.size.width)
                    newRating = Float(i) + decimalNum
                    if self.halfRatings {
                        newRating = Float(i) + (decimalNum > 0.75 ? 1:(decimalNum > 0.25 ? 0.5:0))
                    }
                }
                // Whole rating
                else {
                    newRating = Float(i) + 1.0
                }
                break
            }
        }
        
        // Check min rating
        self.rating = newRating < Float(self.minRating) ? Float(self.minRating):newRating
        
        // Update delegate
        if let delegate = self.delegate {
            delegate.floatRatingView?(self, isUpdating: self.rating)
        }
    }
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.locationInView(self)
            self.handleTouchAtLocation(touchLocation)
        }
    }
    
    override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first  {
            let touchLocation = touch.locationInView(self)
            self.handleTouchAtLocation(touchLocation)
        }
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Update delegate
        if let delegate = self.delegate {
            delegate.floatRatingView(self, didUpdate: self.rating)
        }
    }
    
}
