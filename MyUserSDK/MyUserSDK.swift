//
//  MyUserSDK.swift
//  MyUserSDK
//
//  Created by Amey Dalvi on 22/04/24.
//

import Foundation
import UIKit


public class MyUserSDK{
    //public static let shared = ApiManger()
    public static func showListView(from presentingVC: UIViewController, completion: @escaping (_ name: String?,_ dict: [String:Any]?) -> Void) {
        let listViewController = ListVC(completion: completion)
        presentingVC.present(listViewController, animated: true, completion: nil)
    }
    

}
