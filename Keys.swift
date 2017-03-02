//
//  Keys.swift
//  FlipLearn
//
//  Created by PUNEET on 15/1/17.
//  Copyright © 2017 PUNEET. All rights reserved.
//

import Foundation
import UIKit

var DEVICE_WIDTH:            CGFloat{return UIScreen.main.bounds.width}
var DEVICE_HEIGHT:           CGFloat{return UIScreen.main.bounds.height}
var CORNER_RADIUS:           CGFloat{return 4.0}
var storyBoard:              UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
var REQUEST_URL:             NSString{return"https://www.googleapis.com/customsearch/v1?cx=012627040779741890965%3Awsq_xsxrtnc&searchType=image&key=AIzaSyBMcch-v9mgtiKkL48jHxEBeow0D85KHyQ"}

var TITLE_FONT =             UIFont(name: "HelveticaNeue-Regular", size: 16)
var SUB_TITLE_FONT =         UIFont(name: "HelveticaNeue-Light", size: 14)

/*
 * IMAGES USED IN THE APP
 */
var IMAGE_LIKE =              UIImage(named: "liked-thumb")
var IMAGE_UNLIKE =            UIImage(named: "like-thumb")
var IMAGE_PLACEHOLDER =       UIImage(named: "placeholder")


/*
 *  TEXT LABEL USED IN THE APP
 */
var TEXT_PLACEHOLDER_SEARCH:  NSString{ return "Search Images"}

/*
 * ALL LABELS
 */
var LABEL_SUBMIT:             NSString{ return "Submit"}
var LABEL_SELECT_SIZE:        NSString{return "Select Sizes"}
var LABEL_SHOW_FAV:           NSString{return "Show favorites"}
var LABEL_HIDE_FAV:           NSString{return "Show images"}


/*
 * ALl Keys to parse Data
 */
var KEY_ITEMS:                NSString{return "items"}
var KEY_LINK:                 NSString{return "link"}
var KEY_TITLE:                NSString{return "title"}
var KEY_IMAGE_DATA:           NSString{return "image"}
var KEY_IMAGE_BYTE_SIZE:      NSString{return "byteSize"}
var KEY_IMAGE_HEIGHT:         NSString{return "height"}
var KEY_IMAGE_WIDTH:          NSString{return "width"}
var KEY_QUERIES:              NSString{return "queries"}
var KEY_NEXT_PAGE:            NSString{return "nextPage"}
var KEY_START_INDEX:          NSString{return "startIndex"}
var KEY_TOTAL_RESULTS:        NSString{return "totalResults"}



		
