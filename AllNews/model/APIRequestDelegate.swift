//
//  APIRequestDelegate.swift
//  AllNews
//
//  Created by Alexander Lopez Cedillo on 26/04/20.
//  Copyright © 2020 Alexander Lopez Cedillo. All rights reserved.
//

import Foundation

protocol APIRequestDelegate {
    func didFinishRequest(data: Data?, error: (code: String, message: String)?)
}
