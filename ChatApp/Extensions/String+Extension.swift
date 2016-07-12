//
//  String+Extension.swift
//  ChatApp
//
//  Created by Chau Vo on 7/12/16.
//  Copyright © 2016 Chau Vo. All rights reserved.
//

import Foundation

extension String {
  func trim() -> String {
    return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
  }
}
