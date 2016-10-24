//
//  TesterViewController.swift
//  Movie Club
//
//  Created by Parth Mehta on 6/06/2016.
//  Copyright © 2016 Parth Mehta. All rights reserved.
//

import UIKit
import Material

class TesterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let searchbar = SearchBar()
        self.view.addSubview(searchbar)
        Layout.top(self.view, child: searchbar, top: 50)
        
        let image:UIImage? = MaterialIcon.cm.arrowBack
        let button: IconButton = IconButton()
        button.pulseColor = MaterialColor.grey.base
        button.setImage(image, forState: .Normal)
        button.setImage(image, forState: .Highlighted)
        searchbar.leftControls = [button]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
