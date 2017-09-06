//
//  Model.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 4/12/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import Foundation

class Model {

    var coreDataManager: CoreDataManager!
    var dataManager: DataManager
    
    // Singleton
    fileprivate struct Static
    {
        static var instance: Model?
    }
    
    class var sharedInstance: Model
    {
        if !(Static.instance != nil)
        {
            Static.instance = Model()
        }
        return Static.instance!
    }
    
    fileprivate init()
    {
        self.coreDataManager = CoreDataManager()
        self.dataManager = DataManager(coreDataManager: coreDataManager)
        
        print("Model instantiated")
    }
}
