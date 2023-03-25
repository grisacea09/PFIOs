//
//  RegisterController.swift
//  inversiones-ios
//
//  Created by Grisel Angelica Perez Quezada on 21/03/23.
//

import UIKit

class RegisterController: UIViewController {
    
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var errorUsername: UILabel!
    
    
    @IBOutlet weak var pwd: UITextField!
    
    @IBOutlet weak var errorPwd: UILabel!
    
    @IBOutlet weak var cCard: UITextField!
    
    @IBOutlet weak var errorCard: UILabel!
    
    @IBOutlet weak var phone: UITextField!
    
    @IBOutlet weak var errorPhone: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupTextFields()
        // Do any additional setup after loading the view.
    }
    
    
    
    func validar() -> Bool{
        var valido = false
        DispatchQueue.main.async { [self] in
           
            if(username.text != ""){
                errorUsername.textColor = .green
                errorUsername.text = "*"
                if(pwd.text != ""){
                    errorPwd.text = "*"
                    errorPwd.textColor = .green
                    if(cCard.text != "" && cCard.text!.count >= 13){
                        errorCard.text = "*"
                        errorCard.textColor = .green
                        if(phone.text != "" && phone.text!.count == 10){
                            //1.- preguntar si hay internet
                            
                            errorPhone.text = "*"
                            errorPhone.textColor = .green
                            valido = true
                            Serviciosrest().sendInsertaUsuario(usr: username.text!, pwd: pwd.text!, cuenta: cCard.text!, tel: phone.text!,monto: 5000,moneda: "MXN"){   (isSucces, resp) in
                                print("entro?")
                                print(isSucces, resp)
                                if(isSucces){
                                    print(isSucces, resp, "-")
                                    if resp == "OK" {
                                        print("Se ha insertado  el usuario correctamente")
                                        //hay que ir al login
                                        DispatchQueue.main.async { [self] in
                                           // self.dismiss(animated: true)
                                            let alert = loginAlert()
                                            present(alert, animated: true, completion: nil)
                                            
                                        }
                                    }
                                    else{
                                        DispatchQueue.main.async { [self] in
                                            self.userMessage(txTitle: "No se logro insertar el usuario", txMsg: "Servidor ocupado")
                                        }
                                    }
                                }
                                else{
                                    DispatchQueue.main.async { [self] in
                                        self.userMessage(txTitle: "No tienes conexion a internet", txMsg: "Es necesario una conexion wifi")
                                    }
                                }
                                
                                
                            }
                            
                        }
                        else{
                            
                            errorPhone.text = "la longitud es incorrecta (10)"
                            valido = false
                        }
                        
                        
                    }
                    else{
                        valido = false
                        errorCard.text = "La longitud es incorrecta (>13)"
                        
                        
                    }
                    
                }
                else{
                    valido = false
                    errorPwd.text = "La contraseña no puede ser vacía"
                }
                
            }
            else{
                valido = false
                errorUsername.text = "El usuario no puede ser vacío"
            }
            
           
            
        }
        return valido
    }
    
    
    @IBAction func insertaUsr(_ sender: UIButton) {
        if NetMonitor.shared.isConnected {
            DispatchQueue.main.async { [self] in
                
                validar()
                
                //here
            }
        }
        else{
            DispatchQueue.main.async { [self] in
                self.userMessage(txTitle:"Sin conexión a Internet", txMsg: "No cuentas con internet, tus datos son insuficientes")
            }
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
    
    
    func loginAlert() -> UIAlertController {
            let alert = UIAlertController(title: "Usuario creado", message: "Usuario creado exitosamente", preferredStyle: .alert)
              
            let action = UIAlertAction(title: "Aceptar", style: .default, handler: { action in
                self.performSegue(withIdentifier: "login", sender: self)
              })
            
            alert.addAction(action)
 
            return alert
        }
    
    @objc func endEditingText(){
        username.endEditing(true)
        pwd.endEditing(true)
        cCard.endEditing(true)
        phone.endEditing(true)
    }
    
    func setupTextFields(){
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButon = UIBarButtonItem(title:"Done" , style: .done, target: self, action: #selector(endEditingText))
        
        toolbar.setItems([flexSpace,doneButon], animated: true)
        toolbar.sizeToFit()
        
        username.inputAccessoryView = toolbar
        pwd.inputAccessoryView = toolbar
        cCard.inputAccessoryView = toolbar
        phone.inputAccessoryView = toolbar
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "login" {
            let destination = segue.destination as! ViewController
            destination.modalPresentationStyle = .fullScreen
            
        }
    }
    
    
    
    

}
