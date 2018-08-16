//
//  GameHelper.swift
//  YetAnother2048
//
//  Created by 宋 奎熹 on 2018/8/16.
//  Copyright © 2018 宋 奎熹. All rights reserved.
//

import Foundation

private let kGameModelKey = "game_model"

class GameHelper: NSObject {
    
    static let shared: GameHelper = GameHelper()
    
    var userDefaults = UserDefaults.standard
    
    private override init() {
        
    }
    
    func saveGame(_ gameModel: GameModel) {
        let data = NSKeyedArchiver.archivedData(withRootObject: gameModel)
        userDefaults.set(data, forKey: kGameModelKey)
        userDefaults.synchronize()
    }
    
    func loadGame() -> GameModel? {
        if let data = userDefaults.value(forKey: kGameModelKey) as? Data,
            let model = NSKeyedUnarchiver.unarchiveObject(with: data) as? GameModel {
            return model
        }
        return nil
    }
    
    func setNoGameSaved() {
        userDefaults.set(nil, forKey: kGameModelKey)
        userDefaults.synchronize()
    }
    
}
