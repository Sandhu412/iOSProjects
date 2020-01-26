//
//  ImageViewController.swift
//  redditImages_CollectionView
//
//  Created by Sandeep Anjaneya on 1/25/20.
//  Copyright © 2020 Sandeep Anjaneya. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!

    var detailImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        detailImageView.image = detailImage
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
