//
//  ImageViewController.swift
//  FlipLearn
//
//  Created by PUNEET on 15/1/17.
//  Copyright © 2017 PUNEET. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var scrllView:            UIScrollView!
    @IBOutlet var imgVw:                UIImageView!
    
    var dictImage:                      NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = UIColor.darkGray
        
        self.title = dictImage.object(forKey: KEY_TITLE) as! String?
        // Do any additional setup after loading the view.
        
        //let dictImageData = dictImage.object(forKey: KEY_IMAGE_DATA) as! NSDictionary

       // let height = dictImageData.object(forKey: KEY_IMAGE_HEIGHT) as! CGFloat
        //let width = dictImageData.object(forKey: KEY_IMAGE_WIDTH) as! CGFloat

        
        scrllView.frame = CGRect(x: 0, y: 0, width: DEVICE_WIDTH, height: DEVICE_HEIGHT)
        scrllView.minimumZoomScale = 1.0
        scrllView.maximumZoomScale = 10.0
        scrllView.delegate = self
        
        //imgVw.frame = CGRect(x: (DEVICE_WIDTH-width)/2, y: (DEVICE_HEIGHT-height)/2, width: width, height: height)
        
        imgVw.frame = scrllView.bounds
        imgVw.contentMode = UIViewContentMode.scaleAspectFit
        
        scrllView.contentSize = imgVw.frame.size
        
        let url = URL(string: dictImage.object(forKey: KEY_LINK) as! String)

        imgVw.kf.setImage(with: url,
                              placeholder: nil,
                              options: [.transition(.fade(1))],
                              progressBlock: nil,
                              completionHandler: nil)
        
        // PinchRecognizer on
        let pinchRecognizer = UIPinchGestureRecognizer(target:self, action:Selector(("pinchDetected")))
        self.imgVw.addGestureRecognizer(pinchRecognizer)

        
        
    }

    // PinchRecognizer Function
 
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgVw
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
