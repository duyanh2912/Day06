//
//  ViewController.swift
//  Day06
//
//  Created by Duy Anh on 1/15/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func unwindToBase(segue: UIStoryboardSegue) {
        
    }
}

