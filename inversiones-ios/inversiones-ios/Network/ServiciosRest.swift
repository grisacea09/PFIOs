//
//  ServiciosRest.swift
//  inversiones-ios
//
//  Created by Grisel Angelica Perez Quezada on 21/03/23.
//

import Foundation
import SwiftUI
import Network


class Serviciosrest {
    
    var configuration = URLSessionConfiguration()
    var session = URLSession()
    
    
    func  sendInsertaUsuario(usr:String, pwd:String, cuenta:String, tel:String, monto:CLong, moneda:String, success: @escaping (_ isSuccess:Bool, _ resp:String)->()) {
        
        let ws: String = endPoint.ipApi+"sendInsertaUsuario/"
        print(ws)
        let url = URL(string: ws)!
        
        let insertUsr = UsuarioBody(username: usr, password: pwd, cuenta: cuenta, telefono: tel, montoMaximo: monto, moneda: moneda)
        
        let encoder = JSONEncoder()

        var resEncode = Data()
        do {
            resEncode = try encoder.encode(insertUsr)
            print("resencoder %%%%%%: ")
            print(String(data: resEncode, encoding: .utf8) ?? "")
        } catch  {
            print(error)
        }
 
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = resEncode
        
        let config = URLSessionConfiguration.ephemeral
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 60
        config.timeoutIntervalForResource = 30
        let sesh = URLSession(configuration: config)
        
        
        sesh.dataTask(with: request) { [self] (data,response, error) in
            print("response=?: ",response)
            print("error=?: ",error)
            
            if error !=  nil {
                success(false, "ERROR")
            }
            
            guard let datas = data, let resp = response as? HTTPURLResponse else {
                return
            }
 
            if resp.statusCode == 200 {
                //serializamos los datos
                //res = "200"
                
                
                do {
                    let auths = try JSONDecoder().decode(UsuarioResponseBody.self, from: datas)
                    
                    
                     print("OK 200, ",auths.response)
                    success(true, auths.response)
                    
                } catch let error {
                    print(resp.statusCode)
                    
                    success(false,"ERROR")
                }
                
            }//fin if
            else{
                print("Ha ocurrido un error en el http", resp.statusCode)
                
                success(false, "ERROR")
            }
        }.resume()
    }
   
   
    func  sendBuscaUsuario(usr:String, pwd:String, success: @escaping (_ isSuccess:Bool, _ resp:String)->()) {
        
        let ws: String = endPoint.ipApi+"sendBuscaUsuario/"
        print(ws)
        let url = URL(string: ws)!
        
        let usrPwd = dtoBody(username: usr, password: pwd)
        
        let encoder = JSONEncoder()

        var resEncode = Data()
        do {
            resEncode = try encoder.encode(usrPwd)
            print("resencoder %%%%%%: ")
            print(String(data: resEncode, encoding: .utf8) ?? "")
        } catch  {
            print(error)
        }
 
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = resEncode
        
        let config = URLSessionConfiguration.ephemeral
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 60
        config.timeoutIntervalForResource = 30
        let sesh = URLSession(configuration: config)
        
        
        sesh.dataTask(with: request) { [self] (data,response, error) in
            print("response=?: ",response)
            print("error=?: ",error)
            
            if error !=  nil {
                success(false, "ERROR")
            }
            
            guard let datas = data, let resp = response as? HTTPURLResponse else {
                return
            }
 
            if resp.statusCode == 200 {
                //serializamos los datos
                //res = "200"
                
                
                do {
                    let auths = try JSONDecoder().decode(UsuarioResponseBody.self, from: datas)
                    
                    
                     print("OK 200, ",auths.response)
                    success(true, auths.response)
                    
                } catch let error {
                    print(resp.statusCode)
                    
                    success(false,"ERROR")
                }
                
            }//fin if
            else{
                print("Ha ocurrido un error en el http", resp.statusCode)
                
                success(false, "ERROR")
            }
        }.resume()
    }
   
    
    func  sendBuscaCompraDivisas(usr:String, pwd:String, success: @escaping (_ isSuccess:Bool, _ resp:[ResponseDiv])->()) {
        
        let ws: String = endPoint.ipApi+"sendBuscaCompraDivisas/"
        print(ws)
        let url = URL(string: ws)!
        print("desdeserv : ", usr, pwd)
        let usrPwd = dtoBody(username: global.usr, password: global.pwd)
        
        let encoder = JSONEncoder()

        var resEncode = Data()
        do {
            resEncode = try encoder.encode(usrPwd)
            print("resencoder %%%%%%: ")
            print(String(data: resEncode, encoding: .utf8) ?? "")
        } catch  {
            print(error)
        }
 
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = resEncode
        
        let config = URLSessionConfiguration.ephemeral
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 60
        config.timeoutIntervalForResource = 30
        let sesh = URLSession(configuration: config)
        
        
        sesh.dataTask(with: request) { [self] (data,response, error) in
            print("response=?: ",response)
            print("error=?: ",error)
            
            if error !=  nil {
                success(false, [])
            }
            
            guard let datas = data, let resp = response as? HTTPURLResponse else {
                return
            }
 
            if resp.statusCode == 200 {
                //serializamos los datos
                //res = "200"
                
                
                do {
                    let auths = try JSONDecoder().decode([ResponseDiv].self, from: datas)
                    
                    
                    print("OK 200, ",auths.count)
                    success(true, auths)
                    
                } catch let error {
                    print(resp.statusCode)
                    
                    success(false,[])
                }
                
            }//fin if
            else{
                print("Ha ocurrido un error en el http", resp.statusCode)
                
                success(false, [])
            }
        }.resume()
    }

    
    
}




