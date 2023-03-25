//
//  DetalleViewController.swift
//  inversiones-ios
//
//  Created by Grisel Angelica Perez Quezada on 23/03/23.
//

import UIKit
import Charts




class DetalleViewController: UIViewController, ChartViewDelegate{
    
    var yValues = [PieChartDataEntry]()
    
    var divisas = [ResponseDiv]()
    
    var chartView = PieChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            chartView.widthAnchor.constraint(equalToConstant: 350),
            chartView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            chartView.heightAnchor.constraint(equalTo: chartView.widthAnchor, multiplier: 1),
            chartView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        chartView.backgroundColor = .black
        getDataServicio()
        
        
        // Do any additional setup after loading the view.
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
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
    
    func getDataServicio(){
        
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
     
            var request = URLRequest(url: laUrl)
            request.httpMethod = "POST"
            //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = resEncode
           
            
            urlSession.dataTask(with: request) { data, response, error in
                // Qué haremos cuando obtengamos una repuesta
                if error == nil {
                    
                    guard let datas = data,  let resp = response as? HTTPURLResponse else {
                       
                        return
                    }
                    
                    DispatchQueue.main.async { [self] in
                        
                        do {
                            //todo lo ui
                            print("obteiendo datos: ")
                            print(divisas)
                         divisas = try JSONDecoder().decode([ResponseDiv].self, from: datas)
                           
                            divisas.forEach { i in
                                yValues.append(PieChartDataEntry(value: Double(i.montoCompra), label: i.divisaDestino))
                            }
                            setData()
                            
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
    
    
    func setData(){
        let set1 = PieChartDataSet(entries: yValues, label: "trading")
        set1.drawIconsEnabled = false
        set1.sliceSpace = 2
        
        set1.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let data = PieChartData(dataSet: set1)
        chartView.data = data
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
    }

    
   

}
