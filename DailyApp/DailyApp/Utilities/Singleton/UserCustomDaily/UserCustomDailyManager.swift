//
//  UserCustomDailyManager.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 17.12.2022.
//

import Foundation


class UserCustomDailyManager {
    
    static let shared = UserCustomDailyManager()
    private init() {}
    
    var customDailies : [Daily] = []
    
    var delegate: UserCustomDailyManagerDelegate?
            
    
    func createCustomDaily(dailyRequest : DailyRequest){
        DispatchQueue.main.async {
            CreateDaily(dailyRequest: DailyRequest(message: dailyRequest.message, isBase: dailyRequest.isBase)).execute { [weak self] response in
                guard let strongSelf = self else {return}
                switch response {
                case .this(let success):
                    strongSelf.customDailies.append(success.data)
                    strongSelf.delegate?.setCustomDailies(customDailies: strongSelf.customDailies)
                case .that(let error):
                    print(error.error)
                }
               
            } onError: { err in
                print(err)
            }
        }
    }
    
     func deleteCustomDaily(daily : Daily){
        DispatchQueue.main.async {
            DeleteDaily(daily: daily).execute{ [weak self] response in
                guard let strongSelf = self else {return}
                guard let index = strongSelf.customDailies.firstIndex(where: {$0._id == daily._id}) else {return}
                strongSelf.customDailies.remove(at: index)
                strongSelf.delegate?.setCustomDailies(customDailies: strongSelf.customDailies)
            }onError: { err in
                print(err)
            }
        }
    }
}


protocol UserCustomDailyManagerDelegate {
    func setCustomDailies(customDailies : [Daily])
}
