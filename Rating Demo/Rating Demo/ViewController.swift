//
//  ViewController.swift
//  Rating Demo
//
//  Created by Glen Yi on 2014-09-05.
//  Copyright (c) 2014 On The Pursuit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var ratingSegmentedControl: UISegmentedControl!
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet var liveLabel: UILabel!
    @IBOutlet var updatedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Reset float rating view's background color
        floatRatingView.backgroundColor = UIColor.clear

        /** Note: With the exception of contentMode, type and delegate,
         all properties can be set directly in Interface Builder **/
        floatRatingView.delegate = self
        floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
        floatRatingView.type = .halfRatings
        
        // Segmented control init
        ratingSegmentedControl.selectedSegmentIndex = 1
        
        // Labels init
        liveLabel.text = String(format: "%.2f", self.floatRatingView.rating)
        updatedLabel.text = String(format: "%.2f", self.floatRatingView.rating)
    }

    @IBAction func ratingTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            floatRatingView.type = .wholeRatings
        case 1:
            floatRatingView.type = .halfRatings
        case 2:
            floatRatingView.type = .floatRatings
        default:
            floatRatingView.type = .wholeRatings
        }
    }
}

extension ViewController: FloatRatingViewDelegate {

    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        liveLabel.text = String(format: "%.2f", self.floatRatingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        updatedLabel.text = String(format: "%.2f", self.floatRatingView.rating)
    }
    
}

