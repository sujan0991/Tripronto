//
//  TGLParallaxCarousel.swift
//  CarouselViewExample
//
//  Created by Matteo Tagliafico on 03/04/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

import UIKit

@objc public protocol TGLParallaxCarouselDelegate {
    func didMovetoPageAtIndex(_ index: Int)
    @objc optional func didTapOnItemAtIndex(_ index: Int, carousel: TGLParallaxCarousel)
}


@objc public protocol TGLParallaxCarouselDatasource {
    func numberOfItemsInCarousel(_ carousel: TGLParallaxCarousel) ->Int
    func viewForItemAtIndex(_ index: Int, carousel: TGLParallaxCarousel) ->TGLParallaxCarouselItem
    
}

public enum CarouselType {
    case normal
    case threeDimensional
}

open class TGLParallaxCarouselItem: UIView {
    var xDisp: CGFloat = 0
    var zDisp: CGFloat = 0
    var captionString = ""
    
}

open class TGLParallaxCarousel: UIView {
    
    @IBOutlet weak  var upperView: UIView!
 //   @IBOutlet weak  var pageControl: UIPageControl!
    
    // MARK: - delegate & datasource
   // @IBOutlet weak var captionLabel: UILabel!
    open weak var delegate: TGLParallaxCarouselDelegate?
    open weak var datasource: TGLParallaxCarouselDatasource? {
        didSet {
            reloadData()
        }
    }
    
    // MARK: - properties
    fileprivate var containerView: UIView!
    fileprivate let ISPCarouselViewNibName = "TGLParallaxCarousel"
    fileprivate var carouselItems = [TGLParallaxCarouselItem]()
    
    open var timer = Timer()
    open var itemMargin: CGFloat = 0
    open var bounceMargin: CGFloat = 10
    open var selectedIndex = -1 {
        didSet {
           
            if selectedIndex < 0 { selectedIndex = 0 }
            else if selectedIndex > (datasource!.numberOfItemsInCarousel(self) - 1 )
                {
                    selectedIndex = datasource!.numberOfItemsInCarousel(self) - 1
                }
    //        updatePageControl(selectedIndex)
            print(selectedIndex)
            print(datasource!.numberOfItemsInCarousel(self))
                
            self.delegate?.didMovetoPageAtIndex(selectedIndex)
        }
    }
    
    open var type: CarouselType = .threeDimensional {
        didSet {
            reloadData()
        }
    }
    
    fileprivate var itemWidth: CGFloat?
    fileprivate var itemHeight: CGFloat?
    
    fileprivate var isDecelerating = false
    fileprivate var parallaxFactor: CGFloat {
        
        if let _ = itemWidth { return ((itemWidth! + itemMargin) / xDisplacement ) }
        else { return 1}
    }
    
    var xDisplacement: CGFloat {
        if type == .normal {
            if let _ = itemWidth { return itemWidth! }
            else { return 0 }
        }
        else if type == .threeDimensional { return 30 }        // TODO
        else { return 0 }
    }
    
    var zDisplacementFactor: CGFloat {
        if type == .normal { return 0 }
        else if type == .threeDimensional { return 1 }
        else { return 0 }
    }
    
    // MARK: - gesture handling
    fileprivate var startGesturePoint: CGPoint = CGPoint.zero
    fileprivate var endGesturePoint: CGPoint = CGPoint.zero
    fileprivate var startTapGesturePoint: CGPoint = CGPoint.zero
    fileprivate var endTapGesturePoint: CGPoint = CGPoint.zero
    fileprivate var currentGestureVelocity: CGFloat = 0
    fileprivate var decelerationMultiplier: CGFloat = 25
    fileprivate var loopFinished = false
    
    fileprivate var currentTargetLayer: CALayer?
    fileprivate var currentItem: TGLParallaxCarouselItem?
    fileprivate var currentFoundItem: TGLParallaxCarouselItem?
    
    
    
    // MARK: init methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        
        containerView = loadViewFromNib()
        containerView.frame = bounds
        containerView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(containerView)
        
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: ISPCarouselViewNibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action:#selector(detectPan(_:)))
        containerView.addGestureRecognizer(panGesture)
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(detectTap(_:)))
        containerView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: setup
    func reloadData() {
        guard let datasource = datasource else { return }

      //  pageControl.numberOfPages = datasource.numberOfItemsInCarousel(self)
        layoutIfNeeded()

        for i in 0..<datasource.numberOfItemsInCarousel(self) {
            addItem(datasource.viewForItemAtIndex(i, carousel: self))
        }
       
        layoutIfNeeded()
    }
    
    
    
    // MARK: add item logic
    
    func addItem(_ item: TGLParallaxCarouselItem) {
        
        //print("item",item)
        
        if selectedIndex == -1 {
            selectedIndex = 0
           
            }
        
        if itemWidth == nil { itemWidth = item.frame.size.width }
        if itemHeight == nil { itemHeight = item.frame.size.height }
        
        // center item
        item.center = CGPoint(x: upperView.center.y, y: upperView.center.y )
        
       
        DispatchQueue.main.async{
            
            self.upperView.layer.insertSublayer(item.layer, at: UInt32(self.carouselItems.count))
            
            self.carouselItems.append(item)
            //print(self.carouselItems)
            // self.captionLabel.text=self.carouselItems[0].captionString

            
            self.refreshItemsPosition(animated: true)
        }
    }
    
    
    
    // MARK: refresh logic
    
    func refreshItemsPosition(animated: Bool) {
        if carouselItems.count == 0 { return }
        
        if animated {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationCurve(.linear)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(0.2)
        }
        
        for (index, item) in carouselItems.enumerated() {
            
            item.xDisp = xDisplacement * CGFloat(index)
            item.zDisp = round(-fabs(item.xDisp) * zDisplacementFactor)
            
            item.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            item.layer.isDoubleSided = true
            
            var t = CATransform3DIdentity;
            t.m34 = -(1/500)as CGFloat
            t = CATransform3DTranslate(t, item.xDisp, 0.0, item.zDisp);
            item.layer.transform = t;
        }
        
        if animated {
            UIView.commitAnimations()
        }
    }
    
    
    
    // MARK : handle gestures
    
    func detectPan(_ recognizer:UIPanGestureRecognizer) {
        
        switch recognizer.state {
        case .began:
            startGesturePoint = recognizer.location(in: recognizer.view)
            currentGestureVelocity = 0
            
        case .changed:
            currentGestureVelocity = recognizer.velocity(in: recognizer.view).x
            endGesturePoint = recognizer.location(in: recognizer.view)
            
            let xOffset = (startGesturePoint.x - endGesturePoint.x ) * (1/parallaxFactor)
            
            moveCarousel(xOffset)
            startGesturePoint = endGesturePoint
            
        case .ended, .cancelled, .failed:
            startDecelerating()
        case.possible:
            break
        }
    }
    
    func detectTap(_ recognizer:UITapGestureRecognizer) {
        
        let targetPoint: CGPoint = recognizer.location(in: recognizer.view)
        currentTargetLayer = containerView.layer.hitTest(targetPoint)!
        let targetItem = findItemOnScreen()
        
        if targetItem != nil {
            
            let firstItemOffset = carouselItems[0].xDisp - targetItem!.xDisp
            let tappedIndex = -Int(round(firstItemOffset / xDisplacement))
            
            //if targetItem!.xDisp == 0 {
                self.delegate?.didTapOnItemAtIndex!(tappedIndex, carousel: self)
            //} else {
                // a seconda del valore di targetItem!.xDisp cambio l'offset e centro sull'item
                let offsetToAdd = xDisplacement * -CGFloat(tappedIndex - selectedIndex)
                selectedIndex = tappedIndex
                moveCarousel(-offsetToAdd)
          //  }
        }
    }
    
    
    // MARK: find item
    func findItemOnScreen() ->TGLParallaxCarouselItem? {
        currentFoundItem = nil

        for i in 0..<carouselItems.count {
            currentItem = carouselItems[i]
            checkInSubviews(currentItem!)
        }
        return currentFoundItem
    }
    
    func checkInSubviews(_ view:UIView){
        let subviews = view.subviews
        if subviews.count == 0 { return }
        
        for subview : AnyObject in subviews{
            if checkView(subview as! UIView) { return }
            checkInSubviews(subview as! UIView)
        }
    }
    
    func checkView(_ view: UIView) ->Bool {
        if view.layer.isEqual(currentTargetLayer) {
            currentFoundItem = currentItem
            return true
        } else {
            return false
        }
    }
    
    
    // MARK: moving logic
    func moveCarousel(_ offset: CGFloat) {
        

        if (offset == 0) { return }
        
        var detected = false
        
        for i in 0..<carouselItems.count {
            
            let item: TGLParallaxCarouselItem = carouselItems[i]
            
            // check bondaries
            if carouselItems[0].xDisp >= bounceMargin {
                detected = true
                if offset < 0 {
                    if loopFinished { return }
                }
            }
            
            let lastItemIndex = datasource!.numberOfItemsInCarousel(self) - 1
            if carouselItems[lastItemIndex].xDisp <= -bounceMargin {
                detected = true
                if offset > 0 {
                    if loopFinished { return }
                }
            }
            
            
            item.xDisp = item.xDisp - offset
            item.zDisp =  -fabs(item.xDisp) * zDisplacementFactor
            
            let factor = self.factorForXDisp(item.zDisp)
            
            DispatchQueue.main.async(execute: {
                
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    
                    var t = CATransform3DIdentity;
                    t.m34 = -(1/500)as CGFloat
                    t = CATransform3DTranslate(t, item.xDisp * factor , 0.0, item.zDisp);
                    item.layer.transform = t;
                   // print(item.captionString)
                 //   self.captionLabel.text=item.captionString
                    
                })
            })
            
            if i == carouselItems.count - 1 && detected { loopFinished = true }
            else { loopFinished = false }
        }
    }
    
    func factorForXDisp(_ x: CGFloat) -> CGFloat {
        
        let pA = CGPoint(x: xDisplacement / 2, y: parallaxFactor)
        let pB = CGPoint(x: xDisplacement, y: 1)
        
        let m = (pB.y - pA.y) / (pB.x - pA.x)
        let y = (pA.y - m * pA.x) + m * fabs(x)
        
        switch fabs(x) {
        case (xDisplacement / 2)..<xDisplacement:
            return y
        case 0..<(xDisplacement / 2):
            return parallaxFactor
        default:
            return 1
        }
    }
    
    
    // MARK: helper functions
    func startDecelerating() {
        
        isDecelerating = true
        
        let distance = decelerationDistance()
        let offsetItems = carouselItems[0].xDisp
        let endOffsetItems = offsetItems + distance
        
        selectedIndex = -Int(round(endOffsetItems / xDisplacement))
        
        //print(carouselItems[selectedIndex].captionString)
        //self.captionLabel.text=carouselItems[selectedIndex].captionString
        
        let offsetToAdd = xDisplacement * -CGFloat(selectedIndex) - offsetItems
        moveCarousel(-offsetToAdd)
        isDecelerating = false
    }
    
    
    func decelerationDistance() ->CGFloat {
        let acceleration = -currentGestureVelocity * decelerationMultiplier;
        
        if acceleration == 0 { return 0 }
        else { return -pow(currentGestureVelocity, 2.0) / (2.0 * acceleration); }
    }
    

    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch")
    }
    // MARK: page control update
//    func updatePageControl(index: Int) {
//        pageControl.currentPage = index
//    }
    
}
