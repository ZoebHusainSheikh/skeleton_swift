//
//  ViewController.swift
//  Skeleton
//
//  Created by BestPeers on 31/05/17.
//  Copyright © 2017 BestPeers. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        RequestManager().getWordInformation(word: "love", wordInfoType: .definitions) { (success, response) in
            print(response ?? Constants.kErrorMessage)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

