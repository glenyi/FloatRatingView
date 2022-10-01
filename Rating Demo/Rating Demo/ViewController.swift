//
//  ViewController.swift
//  Rating Demo
//
//  Created by Glen Yi on 2014-09-05.
//  Copyright (c) 2014 On The Pursuit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let segmentItems = ["Whole", "Half", "Float"]
    private lazy var ratingSegmentedControl: UISegmentedControl = .init(items: self.segmentItems)
    private lazy var floatRatingView: FloatRatingView = .init()
    private lazy var liveLabel: UILabel = .init()
    private lazy var updatedLabel: UILabel = .init()
    
    override func loadView() {
        super.loadView()
        
        #if os(iOS)
        self.view.backgroundColor = .systemBackground
        #endif
        
        for v in [ratingSegmentedControl, floatRatingView, liveLabel, updatedLabel] {
            v.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(v)
        }
        
        self.ratingSegmentedControl.addTarget(self, action: #selector(ratingTypeChanged(_:)), for: .valueChanged)
        
        self.floatRatingView.emptyImage = #imageLiteral(resourceName: "StarEmpty")
        self.floatRatingView.fullImage = #imageLiteral(resourceName: "StarFull")
        self.floatRatingView.minRating = 1
        self.floatRatingView.maxRating = 5
        self.floatRatingView.rating = 2.5
        self.floatRatingView.minImageSize = .init(width: 44, height: 44)
        
        // Auto Layout //
        
        let widthConstraint = ratingSegmentedControl.widthAnchor
        #if os(tvOS)
            .constraint(equalTo: view.widthAnchor, multiplier: 0.333)
        #else
            .constraint(equalTo: view.widthAnchor, constant: -100)
        #endif
        
        NSLayoutConstraint.activate([
            ratingSegmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            ratingSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            widthConstraint,
            
            floatRatingView.topAnchor.constraint(equalTo: ratingSegmentedControl.bottomAnchor, constant: 20),
            floatRatingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            floatRatingView.heightAnchor.constraint(equalToConstant: 44),
            floatRatingView.widthAnchor.constraint(equalTo: ratingSegmentedControl.widthAnchor),
            
            liveLabel.topAnchor.constraint(equalTo: floatRatingView.bottomAnchor, constant: 50),
            liveLabel.leadingAnchor.constraint(equalTo: ratingSegmentedControl.leadingAnchor),
            updatedLabel.topAnchor.constraint(equalTo: liveLabel.bottomAnchor, constant: 10),
            updatedLabel.leadingAnchor.constraint(equalTo: ratingSegmentedControl.leadingAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Float Rating View"

        // Reset float rating view's background color
        floatRatingView.backgroundColor = UIColor.clear

        // Note: With the exception of contentMode, type and delegate,
        // all properties can be set directly in Interface Builder
        floatRatingView.delegate = self
        floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView.type = .halfRatings
        
        // Segmented control init
        ratingSegmentedControl.selectedSegmentIndex = 1
        
        // Labels init
        self.floatRatingView(self.floatRatingView, isUpdating: 0)
        self.floatRatingView(self.floatRatingView, didUpdate: 0)
    }

    @objc func ratingTypeChanged(_ sender: UISegmentedControl) {
        self.floatRatingView.type = .init(rawValue: sender.selectedSegmentIndex) ?? .wholeRatings
    }
}

// MARK: FloatRatingViewDelegate

extension ViewController: FloatRatingViewDelegate {
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        self.liveLabel.text = String(format: "Live Rating: %.2f", self.floatRatingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        self.updatedLabel.text = String(format: "Updated Rating: %.2f", self.floatRatingView.rating)
    }
}
