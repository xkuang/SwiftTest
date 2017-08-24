//
//  BMNetworkTools.swift
//  SwiftTest
//
//  Created by 张琳 on 2017/6/22.
//  Copyright © 2017年 张琳. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import PKHUD

private let NetworkRequestShareInstance = NetworkRequest()

class NetworkRequest {
    class var sharedInstance : NetworkRequest {
        return NetworkRequestShareInstance
    }
}
extension NetworkRequest {
    //MARK: - GET 请求
    //    let tools : NetworkRequest.shareInstance!
    
    func getRequest(urlString: String, params : [String : Any], success : @escaping (_ response : JSON)->(), failture : @escaping (_ error : Error)->()) {
        
        //使用Alamofire进行网络请求时，调用该方法的参数都是通过getRequest(urlString， params, success :, failture :）传入的，而success传入的其实是一个接受           [String : AnyObject]类型 返回void类型的函数
        
        Alamofire.request(urlString, method: .get, parameters: params)
            .responseJSON { (response) in/*这里使用了闭包*/
                //当请求后response是我们自定义的，这个变量用于接受服务器响应的信息
                //使用switch判断请求是否成功，也就是response的result
                switch response.result {
                case .success(let value):
                    
                    let jsonValue = JSON(value)
                    let result:String = jsonValue["result"].stringValue
                    let rescode:Int = jsonValue["rescode"].intValue
                    let msg:String = jsonValue["msg"].stringValue
                    
                    switch (result) {
                        
                    case "ok":
                        success(jsonValue["data"])
                    case "fail" :
                        if rescode == 202 { //未登录
                            HUD.flash(.label("您还没有登录"), delay: 2.0)
                        }else{
                            HUD.flash(.label(msg), delay: 2.0)
                        }
                    case "tokenInvalid":
                        HUD.flash(.label("token失效"), delay: 2.0)
                    default:
                        HUD.flash(.label(msg), delay: 2.0)
                        
                    }
                    
                    dPrint(item: JSON(value))
                
                    
                case .failure(let error):
                    
                    failture(error)
                    dPrint(item: "error:\(error)")
                }
        }
        
    }
    //MARK: - POST 请求
    func postRequest(urlString : String, params : [String : Any], isLogin : Bool, success : @escaping (_ response : JSON)->(), failture : @escaping (_ error : Error)->()) {
        
        let headers: HTTPHeaders = [
            "Authorization": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJDMDAwMzYwNSIsImV4cCI6MTUwNDE1OTg3Nywibmlja05hbWUiOiIxODU1MTYyNDgxNCIsInVzZXJUeXBlIjoxLCJzb3VyY2UiOjIsImR1c2VyQ29kZSI6IkQwMDAxNyJ9.QHAGsnYJuh1mhtEDmjIT7ii7nkhoz2o6PZ9uRHtg0nQ",
            "Accept": "application/json",
            "Content-Type":"application/x-www-form-urlencoded"
        ]
        
    
        Alamofire.request(urlString, method: HTTPMethod.post, parameters: params,headers:headers).responseJSON { (response) in
            switch response.result{
            case .success (let value):
                
                let jsonValue = JSON(value)
                let result:String = jsonValue["result"].stringValue
                let rescode:Int = jsonValue["rescode"].intValue
                let msg:String = jsonValue["msg"].stringValue
                
                switch (result) {
                    
                case "ok":
                    success(jsonValue["data"])
                case "fail" :
                    if rescode == 202 { //未登录
                        HUD.flash(.label("您还没有登录"), delay: 2.0)
                    }else{
                        HUD.flash(.label(msg), delay: 2.0)
                    }
                case "tokenInvalid":
                    HUD.flash(.label("token失效"), delay: 2.0)
                default:
                    HUD.flash(.label(msg), delay: 2.0)
                    
                }
                
                dPrint(item: JSON(value))
                
            case .failure(let error):
                
                failture(error)
                dPrint(item: "error:\(error)")
            }
            
        }
        
        
       
    }
    
    //MARK: - 照片上传
    ///
    /// - Parameters:
    ///   - urlString: 服务器地址
    ///   - params: ["flag":"","userId":""] - flag,userId 为必传参数
    ///        flag - 666 信息上传多张  －999 服务单上传  －000 头像上传
    ///   - data: image转换成Data
    ///   - name: fileName
    ///   - success:
    ///   - failture:
    func upLoadImageRequest(urlString : String, params:[String:String], data: [Data], name: [String],success : @escaping (_ response : JSON)->(), failture : @escaping (_ error : Error)->()){
        
        let headers = ["content-type":"multipart/form-data"]
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                //666多张图片上传
                let flag = params["flag"]
                let userId = params["userId"]
                
                multipartFormData.append((flag?.data(using: String.Encoding.utf8)!)!, withName: "flag")
                multipartFormData.append( (userId?.data(using: String.Encoding.utf8)!)!, withName: "userId")
                
                for i in 0..<data.count {
                    multipartFormData.append(data[i], withName: "appPhoto", fileName: name[i], mimeType: "image/png")
                }
        },
            to: urlString,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        
                        switch response.result{
                        case .success (let value):
                            
                            let jsonValue = JSON(value)
                            success(jsonValue["data"])
                            dPrint(item: JSON(value))
                            
                        case .failure(let error):
                            
                            failture(error)
                            dPrint(item: "error:\(error)")
                        }
                    
                    }
                case .failure(let encodingError):
                    dPrint(item: encodingError)
                    failture(encodingError)
                }
        }
        )
    }
}
