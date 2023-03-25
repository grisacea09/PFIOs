//
//  MainTabController.swift
//  inversiones-ios
//
//  Created by Grisel Angelica Perez Quezada on 22/03/23.
//

import Foundation
import UIKit

class MainTabController: UITabBarController {
    
    
    
    var user: String?
    var pwd: String?
    
   


    override func viewDidLoad() {
        super.viewDidLoad()
        guard let selUser = user else{ return }
        guard let selPwd = pwd else{ return }
      
        print("segue", selUser, selPwd)
        global.usr = selUser
        global.pwd = selPwd
       
            
        
       
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("llego??")
        guard let selUser = user else{ return }
        guard let selPwd = pwd else{ return }
      
        print("segue", selUser, selPwd)
        global.usr = selUser
        global.pwd = selPwd
       
       
        let floatingButton = UIButton()
        //floatingButton.setTitle("square.and.arrow.up.fill", for: .normal)
        floatingButton.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 42, weight: .medium)), for: .normal)
       
        floatingButton.backgroundColor = UIColor(red: 255/255, green: 58/255, blue: 81/255, alpha: 1)
        floatingButton.tintColor = .white
        floatingButton.layer.cornerRadius = 25
        floatingButton.addTarget(self, action:#selector(btnAddTouch), for:.touchUpInside)
        view.addSubview(floatingButton)
        
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        floatingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        floatingButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        floatingButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
       
        

    }
    
    @objc func btnAddTouch(_ button: UIButton) {
        alertMessage()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "VChome" {
            let destination = segue.destination as! PruebaViewController
        }
        if segue.identifier == "VCmapa" {
            let destination = segue.destination as! MapaViewController
        }
        if segue.identifier == "VCdetalle" {
            let destination = segue.destination as! DetalleViewController
        }
    }
   
    func userMessage(txTitle:String, txMsg:String){
        // create the alert
        let alert = UIAlertController(title: txTitle,message: txMsg, preferredStyle: UIAlertController.Style.alert)

                // add an action (button)
                alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))

                // show the alert
                self.present(alert, animated: true, completion: nil)
    }
    
    func alertMessage(){
        let showAlert = UIAlertController(title: "Gracias por usar la app", message: nil, preferredStyle: .alert)
        let imageView = UIImageView(frame: CGRect(x: 10, y: 50, width: 250, height: 230))
        imageView.image = UIImage(named: "emoticonos")
        showAlert.view.addSubview(imageView)
        let height = NSLayoutConstraint(item: showAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 320)
        let width = NSLayoutConstraint(item: showAlert.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
        showAlert.view.addConstraint(height)
        showAlert.view.addConstraint(width)
        showAlert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        self.present(showAlert, animated: true, completion: nil)
    }
  
    
}
