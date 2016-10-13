
//
//  ImageViewCell.swift
//  Onthr3
//
//  Created by Kavita Asija on 28/09/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class ImageViewCell: UICollectionViewCell,UIScrollViewDelegate
{
    
    

    private var isDownLoadingInprogress = false
    private var progressbar : MBCircularProgressBarView!
    var customView : CustomImageView!

    
    func SetUpCollectionView(frame : CGRect)  {
        
        customView = CustomImageView(frame: frame)
        customView.backgroundColor = UIColor.blackColor()
        customView.viewsetup(frame)
        self.contentView.addSubview(customView)
    }
    func viewsetup(thumbnailImage : String?,largeImage : String?,captionText : String)
    {
        self.SetUpCollectionView(CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds), CGRectGetHeight(UIScreen.mainScreen().bounds)-50))

        customView.imageview.image = nil
        if largeImage == nil
        {
            if thumbnailImage != nil
            {
                customView.imageview.image = UIImage(named: "placeholderInResults")
                guard
                    let urlimage = NSURL(string: thumbnailImage!)
                    else {return }
                NSURLSession.sharedSession().dataTaskWithURL(urlimage, completionHandler: { (data, _, error) -> Void in
                    guard
                        let data = data where error == nil,
                        let image = UIImage(data: data)
                        else { return }
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                       self.customView.imageview.image = image
                    }
                }).resume()

            }
            else
            {
                customView.imageview.image = UIImage(named: "placeholderInResults")
            }
            isDownLoadingInprogress = true
            progressbar = MBCircularProgressBarView(frame: CGRectMake(CGRectGetWidth(self.frame)/2 - 50,CGRectGetHeight(self.frame)/2 - 50,100,100))
            progressbar.progressColor = UIColor.blueColor()
            progressbar.progressStrokeColor = nil
            progressbar.progressLineWidth = 2
            progressbar.layer.cornerRadius = 10
            progressbar.tag = 100
            progressbar.backgroundColor = UIColor.lightGrayColor()
            self.addSubview(self.progressbar)
            self.bringSubviewToFront(self.progressbar)
        }
        else
        {
//            customView.imageview.image = UIImage(named: largeImage!)
            
            let cgImage = UIImage(contentsOfFile: largeImage!)!.CGImage
            let width = CGImageGetWidth(cgImage) / 2
            let height = CGImageGetHeight(cgImage) / 2
            let bitsPerComponent = CGImageGetBitsPerComponent(cgImage)
            let bytesPerRow = CGImageGetBytesPerRow(cgImage)
            let colorSpace = CGImageGetColorSpace(cgImage)
            let bitmapInfo = CGImageGetBitmapInfo(cgImage)
            
            if let context = CGBitmapContextCreate(nil, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo.rawValue)
            {
                
                CGContextSetInterpolationQuality(context, .High)
                
                CGContextDrawImage(context, CGRect(origin: CGPointZero, size: CGSize(width: CGFloat(width), height: CGFloat(height))), cgImage)
                
                let scaledImage = CGBitmapContextCreateImage(context).flatMap { UIImage(CGImage: $0) }
                customView.imageview.image = scaledImage
                
            }
            else
            {
                customView.imageview.image = UIImage(contentsOfFile: largeImage!)
            }

            if progressbar != nil
            {
                dispatch_async(dispatch_get_main_queue(), {() in
                    self.progressbar.removeFromSuperview()
                    self.progressbar = nil

                    if let view = self.viewWithTag(100)
                    {
                        view.removeFromSuperview()
                    }
                })
            }
        }
        if captionText.isEmpty == false
        {
            self.customView.captionTextLb.text = captionText
            self.customView.captionTextLb.hidden = false
        }
        else
        {
            self.customView.captionTextLb.hidden = true
        }
    }

    func updateDownloadProgress(value : Float)
    {
        if progressbar != nil
        {
            dispatch_async(dispatch_get_main_queue(), {() in
                self.progressbar.setValue(CGFloat(value) ,animateWithDuration: 0.0 )
            })
        }
        
    }
}