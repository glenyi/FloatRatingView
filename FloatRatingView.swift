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
    
    // MARK: Properties
    
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
            for imageView in emptyImageViews {
                imageView.image = emptyImage
            }
            refresh()
        }
    }
    
    /**
    Sets the full image that is overlayed on top of the empty image.
    Should be same size and shape as the empty image.
    */
    @IBInspectable public var fullImage: UIImage? {
        didSet {
            // Update full image views
            for imageView in fullImageViews {
                imageView.image = fullImage
            }
            refresh()
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
            if rating < Float(minRating) {
                rating = Float(minRating)
                refresh()
            }
        }
    }
    
    /**
    Max rating value.
    */
    @IBInspectable public var maxRating: Int = 5 {
        didSet {
            if maxRating != oldValue {
                removeImageViews()
                initImageViews()
                
                // Relayout and refresh
                setNeedsLayout()
                refresh()
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
                refresh()
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
        
        initImageViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initImageViews()
    }
    
    // MARK: Helper methods

    private func initImageViews() {
        guard emptyImageViews.isEmpty && fullImageViews.isEmpty else {
            return
        }

        // Add new image views
        for _ in 0..<maxRating {
            let emptyImageView = UIImageView()
            emptyImageView.contentMode = imageContentMode
            emptyImageView.image = emptyImage
            emptyImageViews.append(emptyImageView)
            addSubview(emptyImageView)

            let fullImageView = UIImageView()
            fullImageView.contentMode = imageContentMode
            fullImageView.image = fullImage
            fullImageViews.append(fullImageView)
            addSubview(fullImageView)
        }
    }

    private func removeImageViews() {
        // Remove old image views
        for i in 0..<emptyImageViews.count {
            var imageView = emptyImageViews[i]
            imageView.removeFromSuperview()
            imageView = fullImageViews[i]
            imageView.removeFromSuperview()
        }
        emptyImageViews.removeAll(keepCapacity: false)
        fullImageViews.removeAll(keepCapacity: false)
    }

    // Refresh hides or shows full images
    private func refresh() {
        for i in 0..<fullImageViews.count {
            let imageView = fullImageViews[i]

            if rating >= Float(i+1) {
                imageView.layer.mask = nil
                imageView.hidden = false
            } else if rating > Float(i) && rating < Float(i+1) {
                // Set mask layer for full image
                let maskLayer = CALayer()
                maskLayer.frame = CGRectMake(0, 0, CGFloat(rating-Float(i))*imageView.frame.size.width, imageView.frame.size.height)
                maskLayer.backgroundColor = UIColor.blackColor().CGColor
                imageView.layer.mask = maskLayer
                imageView.hidden = false
            } else {
                imageView.layer.mask = nil;
                imageView.hidden = true
            }
        }
    }
    
    // Calculates the ideal ImageView size in a given CGSize
    private func sizeForImage(image: UIImage, inSize size: CGSize) -> CGSize {
        let imageRatio = image.size.width / image.size.height
        let viewRatio = size.width / size.height
        
        if imageRatio < viewRatio {
            let scale = size.height / image.size.height
            let width = scale * image.size.width
            
            return CGSizeMake(width, size.height)
        } else {
            let scale = size.width / image.size.width
            let height = scale * image.size.height
            
            return CGSizeMake(size.width, height)
        }
    }

    // Calculates new rating based on touch location in view
    private func updateLocation(touch: UITouch) {
        guard editable else {
            return
        }

        let touchLocation = touch.locationInView(self)
        var newRating: Float = 0
        for i in (maxRating-1).stride(through: 0, by: -1) {
            let imageView = emptyImageViews[i]
            guard touchLocation.x > imageView.frame.origin.x else {
                continue
            }

            // Find touch point in image view
            let newLocation = imageView.convertPoint(touchLocation, fromView: self)

            // Find decimal value for float or half rating
            if imageView.pointInside(newLocation, withEvent: nil) && (floatRatings || halfRatings) {
                let decimalNum = Float(newLocation.x / imageView.frame.size.width)
                newRating = Float(i) + decimalNum
                if halfRatings {
                    newRating = Float(i) + (decimalNum > 0.75 ? 1 : (decimalNum > 0.25 ? 0.5 : 0))
                }
            } else {
                // Whole rating
                newRating = Float(i) + 1.0
            }
            break
        }

        // Check min rating
        rating = newRating < Float(minRating) ? Float(minRating) : newRating

        // Update delegate
        delegate?.floatRatingView?(self, isUpdating: rating)
    }

    // MARK: UIView
    
    // Override to calculate ImageView frames
    override public func layoutSubviews() {
        super.layoutSubviews()

        guard let emptyImage = emptyImage else {
            return
        }

        let desiredImageWidth = frame.size.width / CGFloat(emptyImageViews.count)
        let maxImageWidth = max(minImageSize.width, desiredImageWidth)
        let maxImageHeight = max(minImageSize.height, frame.size.height)
        let imageViewSize = sizeForImage(emptyImage, inSize: CGSizeMake(maxImageWidth, maxImageHeight))
        let imageXOffset = (frame.size.width - (imageViewSize.width * CGFloat(emptyImageViews.count))) /
                            CGFloat((emptyImageViews.count - 1))
        
        for i in 0..<maxRating {
            let imageFrame = CGRectMake(i == 0 ? 0 : CGFloat(i)*(imageXOffset+imageViewSize.width), 0, imageViewSize.width, imageViewSize.height)
            
            var imageView = emptyImageViews[i]
            imageView.frame = imageFrame
            
            imageView = fullImageViews[i]
            imageView.frame = imageFrame
        }
        
        refresh()
    }
    
    // MARK: Touch events

    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        updateLocation(touch)
    }
    
    override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        updateLocation(touch)
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Update delegate
        delegate?.floatRatingView(self, didUpdate: rating)
    }
    
}
