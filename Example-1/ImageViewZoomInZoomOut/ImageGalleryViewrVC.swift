//
//  ImageGalleryViewrViewController.swift
//  Onthr3
//
//  Created by Kavita Asija on 28/09/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class ImageGalleryViewrVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,NSURLSessionDelegate {


    var thumNailIconUrlArray : NSMutableArray!
    var LargeImageArray : NSMutableArray!
    var imagecaptionTextArray : NSMutableArray!
    var scrollingIndex : Int?

    var crossbtn = UIButton()
    var collectionView : UICollectionView!
    
    private var downloadedImageUrlArray = [String : AnyObject]()
    private var isImageStartDownloaded = NSMutableArray()
    var session: NSURLSession!
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.collectionView?.backgroundColor = UIColor.whiteColor()
        
        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        self.collectionView.registerClass(ImageViewCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView.pagingEnabled = true
        self.collectionView.frame = self.view.frame
        self.view.addSubview(collectionView)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.backgroundColor = UIColor.clearColor()
        if LargeImageArray == nil
        {
            LargeImageArray = NSMutableArray(array: ["https://s3-us-west-2.amazonaws.com/onthr3/qa/9/Kavita-Birthday-2016-08-22/157c662a8a9fa7.jpeg","https://s3-us-west-2.amazonaws.com/onthr3/qa/9/Kavita-Birthday-2016-08-22/157c662a8a9fa7.jpeg","https://s3-us-west-2.amazonaws.com/onthr3/qa/9/Kavita-Birthday-2016-08-22/157c662a8a9fa7.jpeg","https://s3-us-west-2.amazonaws.com/onthr3/qa/9/Kavita-Birthday-2016-08-22/157c662a8a9fa7.jpeg"])
        }
        if thumNailIconUrlArray == nil
        {
            thumNailIconUrlArray = NSMutableArray(array: ["https://qa.onthr3.com/image/120/120?src=qa%2F9%2FKavita-Birthday-2016-08-22%2F157c662a8a9fa7.jpeg","https://qa.onthr3.com/image/120/120?src=qa%2F9%2FKavita-Birthday-2016-08-22%2F157c662a8a9fa7.jpeg","https://qa.onthr3.com/image/120/120?src=qa%2F9%2FKavita-Birthday-2016-08-22%2F157c662a8a9fa7.jpeg","https://qa.onthr3.com/image/120/120?src=qa%2F9%2FKavita-Birthday-2016-08-22%2F157c662a8a9fa7.jpeg"])
        }
        crossbtn.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 50, 20, 50, 50)
        crossbtn.setImage(UIImage(named: "icon_cross"), forState: UIControlState.Normal)
        crossbtn.addTarget(self, action: #selector(self.crossbtnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(crossbtn)
        self.view.bringSubviewToFront(crossbtn)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        if scrollingIndex != nil && scrollingIndex <= LargeImageArray.count - 1
        {
            let indexpath = NSIndexPath(forRow: scrollingIndex!, inSection: 0)
            self.collectionView.scrollToItemAtIndexPath(indexpath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
        }

    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        
        self.session.invalidateAndCancel()
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func crossbtnAction(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return LargeImageArray.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.25
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.25
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as? ImageViewCell
        self.startDownloadTask(LargeImageArray[indexPath.row] as! String)
//        if indexPath.row < LargeImageArray.count
//        {
//            self.startDownloadTask(LargeImageArray[indexPath.row] as! String)
//        }
//
        let caption = (self.imagecaptionTextArray != nil) ? self.imagecaptionTextArray.objectAtIndex(indexPath.row) as! String : ""
        if thumNailIconUrlArray != nil
        {
            if downloadedImageUrlArray[LargeImageArray[indexPath.row] as! String] != nil
            {
                let url =  downloadedImageUrlArray[LargeImageArray[indexPath.row] as! String] as! String
                cell?.viewsetup(thumNailIconUrlArray[indexPath.row] as? String, largeImage:url,captionText: caption)
            }
            else
            {
                cell?.viewsetup(thumNailIconUrlArray[indexPath.row] as? String, largeImage: nil,captionText: caption)
            }
        }
        else
        {
            if downloadedImageUrlArray[LargeImageArray[indexPath.row] as! String] != nil
            {
                let url =  downloadedImageUrlArray[LargeImageArray[indexPath.row] as! String] as! String
                cell?.viewsetup(nil, largeImage:url,captionText: caption)
            }
            else
            {
                cell?.viewsetup(nil, largeImage: nil,captionText: caption)
            }
        }
        
                return cell!
    }
    
    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
    {
        
        return CGSizeMake(CGRectGetWidth(self.collectionView.frame) , CGRectGetHeight(UIScreen.mainScreen().bounds) - 50)
    }
    
    func startDownloadTask(largeimageUrl : String) {
        
        if self.isImageStartDownloaded.containsObject(largeimageUrl) == false
        {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {()in
            
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let documentDirectoryPath = paths.first
            let fileManager = NSFileManager()

                let url : NSURL = (NSURL.init(string: largeimageUrl)!)
                let nameOfImage = url.lastPathComponent
                let destinationURL = NSURL(fileURLWithPath: documentDirectoryPath! + "/\(nameOfImage!)")
                if !fileManager.fileExistsAtPath(destinationURL.path!)
                {
                        self.isImageStartDownloaded.addObject(largeimageUrl )
                        let downloadTask = self.session.downloadTaskWithURL(url)
                        downloadTask.resume()
                }
                else
                {
                    self.isImageStartDownloaded.addObject(largeimageUrl )
                    dispatch_async(dispatch_get_main_queue(), {() in
                        if self.downloadedImageUrlArray[largeimageUrl] == nil
                        {
                            self.downloadedImageUrlArray[largeimageUrl] = destinationURL.path!
                        }
                        let getIndexOfUrl = self.LargeImageArray.indexOfObject(largeimageUrl)
                        let indexpath = NSIndexPath(forRow: getIndexOfUrl, inSection: 0)
                        self.collectionView.reloadItemsAtIndexPaths([indexpath])
                    })
                }
        })
        }
        else
        {
            
        }
    }
    

    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("Completion : \((totalBytesWritten * 100)/totalBytesExpectedToWrite)")
        
//        let value = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        let value = Float((totalBytesWritten * 100)/totalBytesExpectedToWrite)
        let getIndexOfUrl = self.LargeImageArray.indexOfObject(downloadTask.originalRequest!.URL!.absoluteString)
        self.UpdateCellDownLoadingBar(value, index: getIndexOfUrl)
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        print(location.absoluteString)
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectoryPath = paths.first
        let fileManager = NSFileManager()
        let name = downloadTask.originalRequest!.URL!.lastPathComponent
        var destinationURL = NSURL(fileURLWithPath: documentDirectoryPath! + "/\(name!)")
        if fileManager.fileExistsAtPath(destinationURL.path!) {
            destinationURL = NSURL(fileURLWithPath: documentDirectoryPath! + "/\(name!)")
        } else {
            try! fileManager.moveItemAtURL(location, toURL: destinationURL)
        }
        
        dispatch_async(dispatch_get_main_queue(), {() in
               //self.downloadedImageUrlArray.addObject(destinationURL.path!)
            let getIndexOfUrl = self.LargeImageArray.indexOfObject(downloadTask.originalRequest!.URL!.absoluteString)
            if self.downloadedImageUrlArray[destinationURL.path!] == nil
            {
                self.downloadedImageUrlArray[self.LargeImageArray.objectAtIndex(getIndexOfUrl) as! String] = destinationURL.path!
            }
            
            let indexpath = NSIndexPath(forRow: getIndexOfUrl, inSection: 0)
            self.collectionView.reloadItemsAtIndexPaths([indexpath])
          })
        
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if self.isImageStartDownloaded.containsObject(task.originalRequest!.URL!.absoluteString) == true
        {
            self.isImageStartDownloaded.removeObject(task.originalRequest!.URL!.absoluteString)
        }
        print(error)
    }
    
    func UpdateCellDownLoadingBar(value : Float,index : Int)  {
        let indexpath = NSIndexPath(forRow: index, inSection: 0)
        let cell = self.collectionView.cellForItemAtIndexPath(indexpath) as? ImageViewCell
        cell?.updateDownloadProgress(value)        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
