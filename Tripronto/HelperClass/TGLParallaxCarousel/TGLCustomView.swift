//
//  CustomView.swift
//  CarouselViewExample
//
//  Created by Matteo Tagliafico on 03/04/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

import UIKit
//import TGLParallaxCarousel

class TGLCustomView: TGLParallaxCarouselItem {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var containerImage: UIImageView!
    @IBOutlet weak var expartImage: UIImageView!
    @IBOutlet weak var destinationName: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var costView: UIView!
    
    @IBOutlet weak var offerName: UILabel!
    
    
    //weak var captionText: String!
    
    fileprivate var containerView: UIView!
    fileprivate let customViewNibName = "TGLCustomView"
    
    
    // MARK: init methods
   // convenience init(frame: CGRect, cost: String,destination: String , offer:String) {
        convenience init(frame: CGRect, cost: String) {
        self.init(frame: frame)
       
//        numberLabel.text=cost
//        destinationName.text = destination
//        offerName.text = offer
        
        
       // self.captionString=cost
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setupUI()
    }
    
    func xibSetup() {
        
        containerView = loadViewFromNib()
        containerView.frame = bounds
        containerView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        containerView.layer.cornerRadius = 5.0
        containerView.clipsToBounds = true
        
        expartImage.layer.cornerRadius = expartImage.frame.size.width / 2;
        expartImage.clipsToBounds = true
        
        addSubview(containerView)
        layoutIfNeeded()
        
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: customViewNibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func setupUI() {
        layer.masksToBounds = false
        layer.shadowRadius = 5
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.65

    }
}
