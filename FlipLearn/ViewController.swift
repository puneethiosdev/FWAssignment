//
//  ViewController.swift
//  FlipLearn
//
//  Created by PUNEET on 15/1/17.
//  Copyright © 2017 PUNEET. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate {
    
    @IBOutlet var imgVwLogo:                UIImageView!
    @IBOutlet var txtFldSearch:             UITextField!
    @IBOutlet var tblView:                  UITableView!
    @IBOutlet var vwBar:                    UIView!
    @IBOutlet var btnSelectSize:            UIButton!
    @IBOutlet var btnShowLikedImage:        UIButton!
    @IBOutlet var tblSize:                  UITableView!
    
    var startValue                          = 1
    var dictResponse:NSDictionary           = NSDictionary()
    var arrItems:NSMutableArray             = []
    var imgSize                             = "small"
    let actInd: UIActivityIndicatorView     = UIActivityIndicatorView()
    let container: UIView                   = UIView()
    var arrSizes:[String]                   = ["icon","small","medium","large","xlarge","xxlarge","huge"]
    var isShowLikesImages:Bool              = false
    
    var TAG_TABLE_SIZE_LIST:                Int{return 10}
    var strSearch                           = ""
    var arrLikes:NSMutableArray             = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imgVwLogo.frame = CGRect(x: (DEVICE_WIDTH - imgVwLogo.frame.size.width)/2, y: (DEVICE_HEIGHT-imgVwLogo.frame.size.height)/2-80, width: imgVwLogo.frame.size.width, height: imgVwLogo.frame.size.height)
        
        txtFldSearch.placeholder = TEXT_PLACEHOLDER_SEARCH as String
        txtFldSearch.frame = CGRect(x: 10, y: 0, width: DEVICE_WIDTH-50, height: 40);
        
        vwBar.frame = CGRect(x: 15, y: (DEVICE_HEIGHT-40)/2, width: DEVICE_WIDTH-30, height: 40);
        vwBar.layer.borderColor = UIColor.lightGray.cgColor
        vwBar.layer.borderWidth = 0.8
        vwBar.layer.cornerRadius = CORNER_RADIUS
        
        btnSelectSize.frame = CGRect(x: 0, y: 40, width: vwBar.frame.size.width/2+5, height: 30)
        btnSelectSize.setTitle(LABEL_SELECT_SIZE as String, for: UIControlState.normal)
        btnSelectSize.layer.cornerRadius = CORNER_RADIUS
        
        btnShowLikedImage.frame = CGRect(x: btnSelectSize.frame.size.width-5, y: 40, width: vwBar.frame.size.width/2, height: 30)
        btnShowLikedImage.setTitle(LABEL_SHOW_FAV as String, for: UIControlState.normal)
        btnShowLikedImage.layer.cornerRadius = CORNER_RADIUS
        
        btnSelectSize.isHidden = true
        btnShowLikedImage.isHidden = true
        
        tblView.frame = CGRect(x: 0, y: 90, width: DEVICE_WIDTH, height: DEVICE_HEIGHT-95)
        tblView.isHidden = true
        self.tblView.backgroundColor = UIColor.clear
        
        self.arrLikes = NSMutableArray()
        
        self.createAndLoadSizeList()
    }
    
    func createAndLoadSizeList() -> Void {
        
        tblSize.frame = CGRect(x: 15, y: 90, width: vwBar.frame.size.width, height: 210)
        
        tblSize.delegate = self
        tblSize.dataSource = self
        tblSize.tag = TAG_TABLE_SIZE_LIST
        tblSize.backgroundColor = UIColor.white
        tblSize.isHidden = true
        self.view.addSubview(tblSize)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        imgVwLogo.isHidden = true
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.vwBar.frame = CGRect(x: self.vwBar.frame.origin.x, y: 20, width: self.vwBar.frame.size.width, height: self.vwBar.frame.size.height)
        })
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != strSearch, !(textField.text?.isEmpty)!
        {
            startValue = 1
            self.arrItems.removeAllObjects()
            self.arrLikes.removeAllObjects()
            isShowLikesImages = false
            
            self.showActivityIndicatory(uiView: self.view)
            self.callGoogleCustomSearchAPI(strSearchText: textField.text!)
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text?.lengthOfBytes(using: String.Encoding.utf8) == 0, self.arrItems.count < 1
        {
            imgVwLogo.isHidden = false
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.vwBar.frame = CGRect(x: self.vwBar.frame.origin.x, y: (DEVICE_HEIGHT-40)/2, width: self.vwBar.frame.size.width, height: self.vwBar.frame.size.height)
            })
            
        }
        return true
    }
    
    func callGoogleCustomSearchAPI(strSearchText: String) {
        strSearch = strSearchText
        
        let requestString = String(format: "%@&q=%@&start=%d&imgSize=%@",REQUEST_URL,strSearchText, startValue,imgSize)
        
        Alamofire.request(requestString).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    //print("JSON: \(JSON)")
                    self.dictResponse = JSON as! NSDictionary
                    if self.arrItems.count>1
                    {
                        let arrNewITems = NSMutableArray(array:self.dictResponse.object(forKey: KEY_ITEMS) as! NSArray)
                        for i in 0..<arrNewITems.count {
                            self.arrItems.add(arrNewITems.object(at: i))
                        }
                    }
                    else
                    {
                        self.arrItems = NSMutableArray(array:self.dictResponse.object(forKey: KEY_ITEMS) as! NSArray)
                    }
                    //print("Items ARRAY:\(self.arrItems)")
                    self.tblView.isHidden = false
                    self.tblView.reloadData()
                    self.btnShowLikedImage.isHidden = false
                    self.btnSelectSize.isHidden = false
                    self.vwBar.frame = CGRect(x: 15, y: 20, width: DEVICE_WIDTH-30, height: 70);
                    
                    let dictQuery = self.dictResponse.object(forKey: KEY_QUERIES) as! NSDictionary
                    let dictNextPage = dictQuery.object(forKey: KEY_NEXT_PAGE) as! NSArray
                    let dict = dictNextPage.object(at: 0) as! NSDictionary
                    self.startValue = dict.object(forKey: KEY_START_INDEX) as! Int
                    
                    self.actInd.stopAnimating()
                    self.container.removeFromSuperview()
                    
                }
                print("Validation Successful")
            case .failure(let error):
                print(error)
                // create the alert
                let alert = UIAlertController(title: "FlipLearn", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.actInd.stopAnimating()
                self.container.removeFromSuperview()
            }
        }
    }
    
    // MARK: Add loader when request happen
    func showActivityIndicatory(uiView: UIView) {
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        actInd.startAnimating()
    }
    
    /*
     Define UIColor from hex value
     
     @param rgbValue - hex color value
     @param alpha - transparency level
     */
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        // Return the number of rows in the section.
        if tableView.tag == TAG_TABLE_SIZE_LIST {
            return self.arrSizes.count
        }
        if isShowLikesImages {
            return self.arrLikes.count
        }
        return self.arrItems.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == TAG_TABLE_SIZE_LIST {
            return 35
        }
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        
        cell.clipsToBounds = true
        
        if tableView.tag == TAG_TABLE_SIZE_LIST {
            cell.textLabel?.text = self.arrSizes[indexPath.row]
        }
        else
        {
            var dictI = NSDictionary()
            if isShowLikesImages {
                dictI = self.arrLikes.object(at: indexPath.row) as! NSDictionary
            }
            else
            {
                dictI = self.arrItems.object(at: indexPath.row) as! NSDictionary
            }
            let dictImage = dictI.object(forKey: KEY_IMAGE_DATA) as! NSDictionary
            
            let url = URL(string: dictI.object(forKey: KEY_LINK) as! String)
            
            if let imageView = cell.viewWithTag(100) as? UIImageView, let lblTitle = cell.viewWithTag(101) as? UILabel, let lblSubTitle = cell.viewWithTag(102) as? UILabel{
                
                imageView.kf.setImage(with: url,
                                      placeholder: IMAGE_PLACEHOLDER,
                                      options: [.transition(.fade(1))],
                                      progressBlock: nil,
                                      completionHandler: nil)
                
                lblTitle.text = dictI.object(forKey: KEY_TITLE) as! String?
                if let byteSize = dictImage.object(forKey: KEY_IMAGE_BYTE_SIZE) as! NSNumber?
                {
                    lblSubTitle.text = "Byte Size: \(byteSize)"
                }
                
            }
            else
            {
                var imageView = UIImageView()
                imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 100, height: 100))
                imageView.layer.borderWidth = 0.5
                imageView.layer.masksToBounds = false
                imageView.layer.borderColor = UIColor.lightGray.cgColor
                imageView.layer.cornerRadius = CORNER_RADIUS;
                imageView.clipsToBounds = true
                imageView.tag = 100
                imageView.kf.setImage(with: url,
                                      placeholder: nil,
                                      options: [.transition(.fade(1))],
                                      progressBlock: nil,
                                      completionHandler: nil)
                cell.contentView.addSubview(imageView)
                
                var lblTitle = UILabel()
                lblTitle = UILabel(frame: CGRect(x: 120, y: 10, width: DEVICE_WIDTH-130, height: 50))
                lblTitle.textColor = .white
                lblTitle.numberOfLines = 2
                lblTitle.lineBreakMode = .byWordWrapping
                lblTitle.font = TITLE_FONT
                lblTitle.tag = 101
                lblTitle.text = dictI.object(forKey: KEY_TITLE) as! String?
                cell.contentView.addSubview(lblTitle)
                
                var lblSubTitle = UILabel()
                lblSubTitle = UILabel(frame: CGRect(x: 120, y: 60, width: DEVICE_WIDTH-130, height: 20))
                lblSubTitle.textColor = .white
                lblSubTitle.font = SUB_TITLE_FONT
                lblSubTitle.tag = 102
                if let byteSize = dictImage.object(forKey: KEY_IMAGE_BYTE_SIZE) as! NSNumber?
                {
                    lblSubTitle.text = "Byte Size: \(byteSize)"
                }
                cell.contentView.addSubview(lblSubTitle)
            }
            let btnLike = UIButton()
            btnLike.frame = CGRect(x: cell.frame.size.width-45, y: 70, width: 30, height: 30);
            btnLike.addTarget(self, action:#selector(likeImage(_sender:)), for:.touchUpInside)
            btnLike.setImage(IMAGE_UNLIKE, for: .normal)
            btnLike.tag = indexPath.row
            cell.contentView.addSubview(btnLike)
            
            if self.arrLikes.contains(dictI) {
                btnLike.setImage(IMAGE_LIKE, for: .normal)
            }
            else
            {
                btnLike.setImage(IMAGE_UNLIKE, for: .normal)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == TAG_TABLE_SIZE_LIST {
            imgSize = self.arrSizes[indexPath.row]
            self.callGoogleCustomSearchAPI(strSearchText: txtFldSearch.text!)
            self.tblSize.isHidden = true
            self.btnSelectSize.isSelected = false
            self.arrItems.removeAllObjects()
            self.arrLikes.removeAllObjects()
            isShowLikesImages = false
            
            startValue = 1
        }
        else
        {
            let imgVw = self.storyboard!.instantiateViewController(withIdentifier: "IMAGE") as! ImageViewController
            imgVw.dictImage = self.arrItems.object(at: indexPath.row) as! NSDictionary
            self.navigationController!.pushViewController(imgVw, animated: true)
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    @IBAction func likeImage(_sender:UIButton)
    {
        let dictI = self.arrItems.object(at: _sender.tag) as! NSDictionary
        
        if _sender.isSelected {
            _sender.isSelected = false
            _sender.setImage(IMAGE_UNLIKE, for: .normal)
            arrLikes.remove(dictI)
        }
        else
        {
            _sender.isSelected = true
            _sender.setImage(IMAGE_LIKE, for: .normal)
            arrLikes.add(dictI)
        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = CGFloat(scrollView.contentOffset.y)
        let maximumOffset = CGFloat(scrollView.contentSize.height - scrollView.frame.size.height)
        
        //NSInteger result = maximumOffset - currentOffset;
        
        // Change 10.0 to adjust the distance from bottom
        if (maximumOffset - currentOffset <= 10.0) {
            //[self refreshDataWithCategoryID:strCatID WithDirection:@"" LastPostID:strPostID];
            //strDir = STRING_IS_BLANK;
            if !isShowLikesImages{
                self.showActivityIndicatory(uiView: self.view)
                self.callGoogleCustomSearchAPI(strSearchText: txtFldSearch.text!)
            }
        }
        
    }
    
    @IBAction func showSelectSizeOptions(_sender: UIButton)
    {
        if _sender.isSelected {
            _sender.isSelected = false
            self.tblSize.isHidden = true
        }
        else
        {
            _sender.isSelected = true
            self.tblSize.isHidden = false
        }
    }
    
    @IBAction func showLikeImages(_sender: UIButton!)
    {
        
        if _sender.isSelected {
            _sender.isSelected = false
            isShowLikesImages = false
            tblView.reloadData()
            _sender.setTitle(LABEL_SHOW_FAV as String, for: UIControlState.normal)

        }
        else
        {
            _sender.isSelected = true
            if self.arrLikes.count>0 {
                isShowLikesImages = true
                tblView.reloadData()
                _sender.setTitle(LABEL_HIDE_FAV as String, for: UIControlState.normal)

            }
            else
            {
                let alert = UIAlertController(title: "FlipLearn", message: "No liked image please like a image.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

