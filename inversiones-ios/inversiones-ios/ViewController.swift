//
//  ViewController.swift
//  inversiones-ios
//
//  Created by Grisel Angelica Perez Quezada on 19/03/23.
//

import UIKit
import Network

class ViewController: UIViewController {
    
    @IBOutlet weak var txusuario: UITextField!
    
    @IBOutlet weak var txpwd: UITextField!
    
    @IBOutlet weak var erroruser: UILabel!
    
    @IBOutlet weak var errorpwd: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        
    }

    @IBAction func login(_ sender: Any) {
        //falta la validacion del tipo de internet...no olvidar
        if NetMonitor.shared.isConnected {
           
            validar()
        }
        else{
            DispatchQueue.main.async { [self] in
                userMessage(txTitle:"No cuentas con conexion a internet", txMsg:"Es necesario conectarse a traves de wifi")
            }
        }
        
    }
    
    func validar(){
        
        var usuario = ""
        var pass = ""
        if ( txusuario.text != ""){
            usuario = txusuario.text!
            erroruser.text = "*"
            erroruser.textColor = .green
            if(txpwd.text != ""){
                pass = txpwd.text!
                errorpwd.text = "*"
                errorpwd.textColor = .green
                Serviciosrest().sendBuscaUsuario(usr: usuario, pwd: pass){ (isSucces, resp) in
                    print("lo encontro?", usuario)
                    print(isSucces, resp)
                    if(isSucces){
                        print(isSucces, resp, "-")
                        
                        if resp == "OK" {
                            
                          
                           
                            global.usr = usuario
                            global.pwd = pass
                            DispatchQueue.main.async { [self] in
                                let story = UIStoryboard(name: "Main", bundle: nil)
                                let controller = story.instantiateViewController(identifier: "mainTabController") as MainTabController
                                   
                                controller.modalPresentationStyle = .fullScreen
                                controller.selectedViewController = controller.viewControllers?[0]
                                controller.user = usuario
                                controller.pwd = pass
                                self.present(controller, animated: true, completion: nil)
                                
                            }
                        }
                    }
                }
                
                
            }
            else{
                errorpwd.text = "La contraseña no puede ser vacía"
            }
        }
        else{
            erroruser.text = "El usuario no puede ser vacío"
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
    
    
    @IBAction func resgistrar(_ sender: UIButton) {
        
        let story = UIStoryboard(name: "Main", bundle: nil)
             let controller = story.instantiateViewController(identifier: "registro") as! RegisterController
        controller.modalPresentationStyle = .fullScreen
             self.present(controller, animated: true, completion: nil)
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       
        if segue.identifier == "registro" {
            let destination = segue.destination as! RegisterController
            
        }
        if segue.identifier == "maintab" {
            let destination = segue.destination as! UITabBarController
            
        }
        
       
        
       
    }
    
    @objc func endEditingText(){
        txusuario.endEditing(true)
        txpwd.endEditing(true)
       
    }
    
    func setupTextFields(){
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButon = UIBarButtonItem(title:"Done" , style: .done, target: self, action: #selector(endEditingText))
        
        toolbar.setItems([flexSpace,doneButon], animated: true)
        toolbar.sizeToFit()
        
        txusuario.inputAccessoryView = toolbar
        txpwd.inputAccessoryView = toolbar
        
        
    }
    
    
   
    
    
}

