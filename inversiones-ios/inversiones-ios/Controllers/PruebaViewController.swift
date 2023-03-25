//
//  PruebaViewController.swift
//  inversiones-ios
//
//  Created by Grisel Angelica Perez Quezada on 23/03/23.
//

import UIKit

class PruebaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   

    @IBOutlet weak var table: UITableView!
    
    var divisas = [ResponseDiv]()
    var tam = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // consultar el API y serializar el JSON
        print("entro")
        if NetMonitor.shared.isConnected {
            print("entro2")
            let urlSessionConfiguration = URLSessionConfiguration.ephemeral
          
            //config.waitsForConnectivity = true
            urlSessionConfiguration.timeoutIntervalForRequest = 30
            urlSessionConfiguration.timeoutIntervalForResource = 30
            let urlSession = URLSession(configuration: urlSessionConfiguration)
            var pag = endPoint.ipApi+"sendBuscaCompraDivisas/"
            guard let laUrl = URL(string: pag) else{ return}
            print(laUrl)
            
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
     
            
            var urlRequest: URLRequest = URLRequest(url: laUrl)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = resEncode
            
            urlSession.dataTask(with: urlRequest) { data, response, error in
                // Qué haremos cuando obtengamos una repuesta
                if error == nil {
                    
                    guard let datas = data,  let resp = response as? HTTPURLResponse else {
                       // print("no hay internet datas")
                        
                        return
                    }
                    
                    DispatchQueue.main.async { [self] in
                        
                        do {
                            divisas = try JSONDecoder().decode([ResponseDiv].self, from: datas)
                            print("obteniendo las divisas del servicio: ")
                            print(divisas)
                            tam = divisas.count
                           
                           
                            
                         
                            
                           
                            table.reloadData()
                            
                        } catch let error {
                            
                            print("Ha ocurrido un error:\(error.localizedDescription)")
                            
                        }
                        
                        
                        
                        
                    }
                }else{
                    print("error")
                    DispatchQueue.main.async { [self] in
                        self.userMessage(txTitle:"Sin conexión a Internet", txMsg: "No cuentas con internet, tus datos son insuficientes")
                    }
                }
            }
            // 5. Iniciamos tarea
            .resume()
        }
        else{
            userMessage(txTitle:"Sin conexión a Internet", txMsg: "No cuentas con internet")
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
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
    return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tam
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell =
        tableView.dequeueReusableCell(withIdentifier: "CustomCellIdentifier",for: indexPath) as! CustomTableViewCell
        // Sets the text of the Label in the Table View Cell
        let model = divisas[indexPath.row]
        print("desde cell: ",model)
       
        aCell.imageDiv?.image = UIImage(named: "cambiar")
        aCell.basediv.text = "Divisa Base: \( divisas[indexPath.row].divisaBase)"
        aCell.divDest.text = "Divisa Destino: \( divisas[indexPath.row].divisaDestino)"
        aCell.monto?.text = "Monto: \( divisas[indexPath.row].montoCompra)"
        aCell.baseTasa?.text = "Tasa Base: \(divisas[indexPath.row].tasaBase)"
 
               
        return aCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 140
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("clik")
        
        
        present(DetalleViewController(), animated: true, completion: nil)
    
        
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

}
