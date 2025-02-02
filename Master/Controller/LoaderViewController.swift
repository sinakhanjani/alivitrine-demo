//
//  ViewController.swift
//  Master
//
//  Created by Sinakhanjani on 10/27/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class LoaderViewController: UIViewController {
    
    fileprivate let dispathGroup = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
//        Authentication.auth.authenticationUser(token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImIwNDllYzQ2M2Y5MTY4NWM3M2YwNTg3YjMwMzBkYzJjNjcwNjUwOWUxMzYwZmQ0ZTBkNjdkNTUyMDlmZTMzMmZmOWMzOGU1NjdjMmU0ZWUyIn0.eyJhdWQiOiIyIiwianRpIjoiYjA0OWVjNDYzZjkxNjg1YzczZjA1ODdiMzAzMGRjMmM2NzA2NTA5ZTEzNjBmZDRlMGQ2N2Q1NTIwOWZlMzMyZmY5YzM4ZTU2N2MyZTRlZTIiLCJpYXQiOjE1OTU2Njk3MDAsIm5iZiI6MTU5NTY2OTcwMCwiZXhwIjo4NjQxNTk1NjczMzAwLCJzdWIiOiIxMDU0Iiwic2NvcGVzIjpbXX0.3oNJGyTKKpKVvlslAnkmGfcQ6gOdaf4sefRSn0Lg6kx9t26_rXaC1wwyE-FWHizqlALeexLXfW5kmJFRZmWtYaOfMPwjVV20RBitIr_eEIew4PKmcYowkXNEik8VtqlTg4Fh4f1llNiFpFZ5d-dLG57uRMglK1ZwVMiCW0bOorOyhd6hGyKffcdbdghFxB-2OC4uQKbKcou4fO3rYiqrqUCnTNAe5lRAlBxC_8bmYLsT6gvOgQ8CKjbcgVp9Ba-e10SarWMe7nXhla8ezI21pxi2lcvC3miQI31twXJJ-o7lpEQwh1g5kovARtkmgMsQzLNTONE_hm5Q_X6oJi9X_zryQ6XTyJRtiZZqE4iBQIkSkKaxZLBJVumyUFIqqz4R5An3WxD0zkNtM7a6CheCdL6o2jawBAfeRf1zJKkIqnBu3KwIrcN0Ch1SE1hbkFQCkMvEtf1RJC0ov5yC4hWaYTcY2SGKV7rYxDMMa1Fy8BxY_zkOXgn2nCBspp_OH4R3wHx0hYyEaSxMv24JG0fBTbEJ66Lil24uKHnfAQRa9FIt_ODOP7VOZYZ1B2Vp0ffase4WI31PFwJXsOHsxknOicSCrqRWS8JdSr5eKUJUu44EwBgqPmvFir-bDvUWwEMCj91-eLfTjB6NEJjhiKE238kkWvm5yepg5fInJoj2aGs", isLoggedIn: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        updateUI()
        go()
    }
    
    func go() {
        if Authentication.auth.token != nil {
            self.present(TabBarController.create(), animated: true, completion: nil)
        }
        else {
            present(IntroViewController.create(), animated: false, completion: nil)
        }
    }

    @IBAction func unwindToLoaderViewController(_ segue: UIStoryboardSegue) {
        //
    }
}

