//
//  CustomImageView.swift
//  ImageViewZoomInZoomOut
//
//  Created by Kavita Asija on 19/09/16.
//  Copyright © 2016 Kavita Asija. All rights reserved.
//

import UIKit

class CustomImageView: UIView,UIScrollViewDelegate {


    var scrollview = UIScrollView()
    var imageview = UIImageView()
    var captionTextLb = UILabel()
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    //MARK: SUper Class Methods
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }

    
    func viewsetup(rectframe : CGRect)
    {
        scrollview.frame = CGRectMake(0,0, CGRectGetWidth(rectframe), CGRectGetHeight(rectframe) - 50)
        self.addSubview(scrollview)
        imageview.frame = scrollview.frame
        self.scrollview.addSubview(imageview)        
        captionTextLb.frame = CGRectMake(0, CGRectGetHeight(rectframe) - 30, CGRectGetWidth(rectframe), 30)
        captionTextLb.backgroundColor = UIColor.darkGrayColor()
        captionTextLb.textColor = UIColor.whiteColor()
        self.addSubview(captionTextLb)
        scrollview.delegate = self
        scrollview.backgroundColor = UIColor.blackColor()
        scrollview.alwaysBounceVertical = false
        scrollview.alwaysBounceHorizontal = false
        scrollview.showsVerticalScrollIndicator = true
        scrollview.flashScrollIndicators()
        imageview.layer.cornerRadius = 11.0
        imageview.clipsToBounds = false
        scrollview.minimumZoomScale = 1.0
        scrollview.maximumZoomScale = 10.0
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap(_:)))
        tapgesture.numberOfTapsRequired = 2
        scrollview.addGestureRecognizer(tapgesture)
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageview
    }

    func handleDoubleTap(gesture : UITapGestureRecognizer)  {
        
        if(self.scrollview.zoomScale > self.scrollview.minimumZoomScale)
        {
            self.scrollview.setZoomScale(self.scrollview.minimumZoomScale, animated: true)
        }
        else
        {
            self.scrollview.setZoomScale(3, animated: true)
        }
    }
}
