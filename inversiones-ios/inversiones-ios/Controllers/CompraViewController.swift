//
//  CompraViewController.swift
//  inversiones-ios
//
//  Created by Grisel Angelica Perez Quezada on 23/03/23.
//

import UIKit
import AlamofireImage
import Alamofire
import Charts

class CompraViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,ChartViewDelegate {
   
    var selectIndex: Int = 0
    var imgDivisas = [Divisas]()
    let imageCache = AutoPurgingImageCache( memoryCapacity: 111_111_111, preferredMemoryUsageAfterPurge: 90_000_000)
    var chartView = LineChartView()
    @IBOutlet weak var collectionViewDivisas: UICollectionView!
    
    @IBOutlet weak var ayerlb: UILabel!
    @IBOutlet weak var hoylbl: UILabel!
    @IBOutlet weak var tomorrowlbl: UILabel!
    
    @IBOutlet weak var imgAyer: UIImageView!
    @IBOutlet weak var timgTomo: UIImageView!
    
    @IBOutlet weak var imgHoy: UIImageView!
    
    @IBOutlet weak var kpiAyer: UILabel!
    @IBOutlet weak var kpiHoy: UILabel!
    
    @IBOutlet weak var kpiTomo: UILabel!
    
    @IBOutlet weak var comprabtn: UIButton!
    
    @IBOutlet weak var montotxt: UITextField!
    @IBOutlet weak var lbMonto: UILabel!
    
    var divisaBase = "MXN"
       var divisaDestino = ""
       var montoCompra = 0.0
       var tasaBase = 0.0
    
    
    @IBAction func comprarDivisa(_ sender: Any) {
        
        //verificar internet
        //enviar datos en servicio
        //y mostrar alert de que ya se acabo la compra
        let monto = CLong(montotxt.text!)
        if NetMonitor.shared.isConnected {
            let ws: String = endPoint.ipApi+"sendInsertaCompraDivisas/"
            print(ws)
            let url = URL(string: ws)!
            
            let compraDiv = compraDivisa(divisaBase: divisaBase, divisaDestino: divisaDestino, usuario: global.usr, montoCompra: CLong(monto!), tasaBase: tasaBase)
            
            let encoder = JSONEncoder()
            
            var resEncode = Data()
            do {
                resEncode = try encoder.encode(compraDiv)
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
                    DispatchQueue.main.async { [self] in
                        self.userMessage(txTitle:"Servidor caido", txMsg: "Error en la peticion")
                    }
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
                        if(auths.response == "OK"){
                            DispatchQueue.main.async { [self] in
                                self.userMessage(txTitle:"Compra de divisa con exito", txMsg: "Ir al inicio para ver el detalle de la compra")
                            }
                        }
                       
                        
                        
                    } catch let error {
                        print(resp.statusCode)
                        
                    }
                    
                }//fin if
                else{
                    print("Ha ocurrido un error en el http", resp.statusCode)
                    
                }
            }.resume()
            
        }
        else{
            DispatchQueue.main.async { [self] in
                self.userMessage(txTitle:"Sin conexión a Internet", txMsg: "No cuentas con internet, tus datos son insuficientes")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("bajando divisas")
        collectionViewDivisas.delegate = self
        collectionViewDivisas.dataSource = self
        ocultaDetalle()
        
        view.addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            chartView.widthAnchor.constraint(equalToConstant: 370),
            chartView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            chartView.heightAnchor.constraint(equalToConstant: 250),
            chartView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        chartView.backgroundColor = .black
        setupTextFields()
       
       
   
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if NetMonitor.shared.isConnected {
            print("entro2")
            let urlSessionConfiguration = URLSessionConfiguration.ephemeral
          
            //config.waitsForConnectivity = true
            urlSessionConfiguration.timeoutIntervalForRequest = 30
            urlSessionConfiguration.timeoutIntervalForResource = 30
            let urlSession = URLSession(configuration: urlSessionConfiguration)
            var pag = endPoint.ipMock+"vestimenta/divisas_list"
            guard let laUrl = URL(string: pag) else{ return}
            print(laUrl)

            var request = URLRequest(url: laUrl)
            request.httpMethod = "GET"
           
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

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
                           
                            var cosa = try JSONDecoder().decode([Divisas].self, from: datas)
                             print(cosa)
                            imgDivisas = cosa
                            
                           
                           
                           
                           
                            collectionViewDivisas.reloadData()
                            
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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("cuantos? ",imgDivisas.count)
        return imgDivisas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        //collectionView.register(DivisasCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DivisasCollectionViewCell
       //Buscar lib para visualizar imagen desde url..con Glide
       
        let url = URL(string: imgDivisas[indexPath.row].imagen)!
        print("si hay datos?")
       print(imgDivisas)

       
        AF.request( url,method: .get).response{ response in

           switch response.result {
            case .success(let responseData):
               cell.imageDiv?.image = UIImage(data: responseData!, scale:1)

            case .failure(let error):
                print("error--->",error)
            }
        }
        

        cell.symbolDiv?.text = imgDivisas[indexPath.row].divisa
        cell.nameDiv?.text = imgDivisas[indexPath.row].simbolo
       
        cell.nameDiv?.widthAnchor.constraint(equalToConstant: 100).isActive = true
        cell.symbolDiv?.widthAnchor.constraint(equalToConstant: 100).isActive = true
      //  cell.backgroundColor = .cyan
       
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
         let cell = collectionView.cellForItem(at: indexPath) as? DivisasCollectionViewCell
                print(indexPath.row, imgDivisas[indexPath.row])
        selectIndex = indexPath.row
        print("hice click en: ",cell?.nameDiv.text)
        //dibujar la serie
        muestraDetalle()
        guard let c = cell?.nameDiv.text else { return}
        getSerieKpi(divisaDestino: c)
       //mostrar los kpi
        showKpiTrading(divisaDestino: c)
        divisaDestino = c
        print("divisaDestino", c)
        
    }
    
    func getSerieKpi(divisaDestino: String){
        
        var date = Date()
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "MM"
        let monthString = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "dd"
        let dayString = dateFormatter.string(from: date)
        let diaAyer = Int(dayString)!-1
        //let dia20 = Int(dayString)!-20
        
        let  end_date = yearString+"-"+monthString+"-"+dayString
       let start_date = yearString+"-"+monthString+"-\(diaAyer)"
        print(start_date, end_date)
       
        //esto es para traer la data de las divisas de la api
        
        //verificar si hay internet
        if NetMonitor.shared.isConnected {
        
       

            print("divisa destino: ", divisaDestino)
            let url = "https://api.apilayer.com/exchangerates_data/timeseries?start_date=2023-03-01&end_date=2023-03-23"
            
            //var url = endPoint.ipMock+"vestimenta/series_list"
            
            print(url)
            var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.addValue("xnbdxk7XVYtqUOm3TnJtSnaUUESc4ayI", forHTTPHeaderField: "apikey")

             URLSession.shared.dataTask(with: request) { data, response, error in
                
               
                    guard let  data = data, let resp = response as? HTTPURLResponse else {
                        
                        return
                    }
                    
                    
                 DispatchQueue.main.async { [self] in
                     
                     do {
                         var yValues = [ChartDataEntry]()
                         let jsonraro = String(data: data, encoding: .utf8)!
                         print(jsonraro)
                         let res = JSONDecoder()
                                 res.keyDecodingStrategy = .convertFromSnakeCase
                        // let serie = try res.decode(Serie.self, from:Data(jsonraro.utf8))
                          //       print(serie)
                         
                         let serie =  try JSONDecoder().decode(Serie.self, from: data)
                        
                        
                         var count = 1
                         serie.rates.forEach{
                             if(divisaDestino == "GBP"){
                                 print("el val ",$0.value.GBP)
                                 yValues.append(ChartDataEntry(x: Double(count), y: Double($0.value.GBP)))
                             }
                             if(divisaDestino == "BRL"){
                                 yValues.append(ChartDataEntry(x: Double(count), y: Double($0.value.BRL)))
                             }
                             if(divisaDestino == "CAD"){
                                 yValues.append(ChartDataEntry(x: Double(count), y: Double($0.value.CAD)))
                             }
                             if(divisaDestino == "USD"){
                                 yValues.append(ChartDataEntry(x: Double(count), y: Double($0.value.USD)))
                             }
                             if(divisaDestino == "EGP"){
                                 yValues.append(ChartDataEntry(x: Double(count), y: Double($0.value.EGP)))
                             }
                             if(divisaDestino == "EUR"){
                                 yValues.append(ChartDataEntry(x: Double(count), y: Double($0.value.EUR)))
                             }
                             if(divisaDestino == "INR"){
                                 yValues.append(ChartDataEntry(x: Double(count), y: Double($0.value.INR)))
                             }
                             if(divisaDestino == "KPW"){
                                 yValues.append(ChartDataEntry(x: Double(count), y: Double($0.value.KPW)))
                             }
                             if(divisaDestino == "KRW"){
                                 yValues.append(ChartDataEntry(x: Double(count), y: Double($0.value.KRW)))
                             }
                             if(divisaDestino == "COP"){
                                 yValues.append(ChartDataEntry(x: Double(count), y: Double($0.value.COP)))
                             }
                             if(divisaDestino == "CUP"){
                                 yValues.append(ChartDataEntry(x: Double(count), y: Double($0.value.CUP)))
                             }
                             if(divisaDestino == "SEK"){
                                 yValues.append(ChartDataEntry(x: Double(count), y: Double($0.value.SEK)))
                             }
                             if(divisaDestino == "RUB"){
                                 yValues.append(ChartDataEntry(x: Double(count), y: Double($0.value.RUB)))
                             }
                             if(divisaDestino == "CNY"){
                                 yValues.append(ChartDataEntry(x: Double(count), y: Double($0.value.CNY)))
                             }
                             
                             count = count+1
                             
                         }
                         
                         print("yvalues...")
                         print(yValues)
                         self.setData(yValues: yValues)
                         
                         
                     } catch let error {
                         print(error)
                         
                         
                     }//fin catch
                     
                 }//dispatch
                    //print(String(data: data, encoding: .utf8)!)
                 
                
             }.resume()
        }
        else{
            userMessage(txTitle:"Sin conexión a Internet", txMsg: "No cuentas con internet")
        }
        
        
        
    }
  
    
    func showKpiTrading(divisaDestino: String){
        
        var date = Date()
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "MM"
        let monthString = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "dd"
        let dayString = dateFormatter.string(from: date)
        let diaAyer = Int(dayString)!-1
        //let dia20 = Int(dayString)!-20
        
        let  end_date = yearString+"-"+monthString+"-"+dayString
       let start_date = yearString+"-"+monthString+"-\(diaAyer)"
        print(start_date, end_date)
       
        //esto es para traer la data de las divisas de la api
        
        //verificar si hay internet
        if NetMonitor.shared.isConnected {
        
       
            print("divisa destino: ", divisaDestino)
          let url = "https://api.apilayer.com/exchangerates_data/timeseries?start_date=\(start_date)&end_date=\(end_date)"
            
           // var url = endPoint.ipMock+"vestimenta/serie_kpi"
            
            print(url)
            var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.addValue("xnbdxk7XVYtqUOm3TnJtSnaUUESc4ayI", forHTTPHeaderField: "apikey")

             URLSession.shared.dataTask(with: request) { data, response, error in
                
               
                    guard let  data = data, let resp = response as? HTTPURLResponse else {
                        
                        return
                    }
                    
                    
                 DispatchQueue.main.async { [self] in
                     
                     do {
                         var yValues = [Double]()
                         let jsonraro = String(data: data, encoding: .utf8)!
                         print(jsonraro)
                         let res = JSONDecoder()
                                 res.keyDecodingStrategy = .convertFromSnakeCase
                        // let serie = try res.decode(Serie.self, from:Data(jsonraro.utf8))
                          //       print(serie)
                         
                         let serie =  try JSONDecoder().decode(Serie.self, from: data)
                        
                       
                         
                         var count = 1
                         serie.rates.forEach{
                             if(divisaDestino == "GBP"){
                                 print("el val ",$0.value.GBP)
                                 yValues.append( Double($0.value.GBP))
                             }
                             if(divisaDestino == "BRL"){
                                 yValues.append(Double($0.value.BRL))
                             }
                             if(divisaDestino == "CAD"){
                                 yValues.append(Double($0.value.CAD))
                             }
                             if(divisaDestino == "USD"){
                                 yValues.append( Double($0.value.USD))
                             }
                             if(divisaDestino == "EGP"){
                                 yValues.append(Double($0.value.EGP))
                             }
                             if(divisaDestino == "EUR"){
                                 yValues.append( Double($0.value.EUR))
                             }
                             if(divisaDestino == "INR"){
                                 yValues.append( Double($0.value.INR))
                             }
                             if(divisaDestino == "KPW"){
                                 yValues.append( Double($0.value.KPW))
                             }
                             if(divisaDestino == "KRW"){
                                 yValues.append(Double($0.value.KRW))
                             }
                             if(divisaDestino == "COP"){
                                 yValues.append( Double($0.value.COP))
                             }
                             if(divisaDestino == "CUP"){
                                 yValues.append(Double($0.value.CUP))
                             }
                             if(divisaDestino == "SEK"){
                                 yValues.append( Double($0.value.SEK))
                             }
                             if(divisaDestino == "RUB"){
                                 yValues.append( Double($0.value.RUB))
                             }
                             if(divisaDestino == "CNY"){
                                 yValues.append(Double($0.value.CNY))
                             }
                             
                             count = count+1
                             
                         }
                         
                         //crear los triangulos
                         
                         //solo trae dos valores
                         tasaBase = yValues[1]
                         
                         var promedio = (Double(yValues[0])+Double(yValues[1]))/2
                         kpiAyer.text = "\(yValues[0])"
                      kpiHoy.text = "\(yValues[1])"
                         kpiTomo.text = "\(promedio)"

                            if(yValues[1] < yValues[0]){
                              imgAyer.image = UIImage(systemName: "arrowtriangle.up.fill")
                                imgAyer.tintColor = .green
                                imgHoy.image = UIImage(systemName: "arrowtriangle.down.fill")
                                imgHoy.tintColor = .red
                                if(yValues[1] > promedio){
                                    timgTomo.image = UIImage(systemName: "arrowtriangle.down.fill")
                                    timgTomo.tintColor = .red
                                }
                                else{
                                    timgTomo.image = UIImage(systemName: "arrowtriangle.up.fill")
                                    timgTomo.tintColor = .green
                                }
                            }
                         else{
                             imgAyer.image = UIImage(systemName: "arrowtriangle.down.fill")
                                                  imgAyer.image?.withTintColor(.red)
                             imgHoy.image = UIImage(systemName: "arrowtriangle.up.fill")
                             imgHoy.tintColor = .green
                             if(yValues[1] > promedio){
                                 timgTomo.image = UIImage(systemName: "arrowtriangle.down.fill")
                                 timgTomo.tintColor = .red
                             }
                             else{
                                 timgTomo.image = UIImage(systemName: "arrowtriangle.up.fill")
                                 timgTomo.tintColor = .green
                             }
                             
                         }

                        
                             
                              
                         
                         
                         
                         
                     } catch let error {
                         print(error)
                         
                         
                     }//fin catch
                     
                 }//dispatch
                    //print(String(data: data, encoding: .utf8)!)
                 
                
             }.resume()
        }
        else{
            userMessage(txTitle:"Sin conexión a Internet", txMsg: "No cuentas con internet")
        }
        
        
        
    }
    
    
    
    
    
    
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func setData(yValues:[ChartDataEntry]){
        let set1 = LineChartDataSet(entries: yValues, label: "Serie de tiempo")
        let data = LineChartData(dataSet: set1)
        
        chartView.data = data
    }
    
    
    
    @objc func endEditingText(){
        montotxt.endEditing(true)
        
    }
    
    func setupTextFields(){
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButon = UIBarButtonItem(title:"Done" , style: .done, target: self, action: #selector(endEditingText))
        
        toolbar.setItems([flexSpace,doneButon], animated: true)
        toolbar.sizeToFit()
        
        montotxt.inputAccessoryView = toolbar
        
        
    }
    
    func ocultaDetalle(){
        ayerlb.isHidden = true
        hoylbl.isHidden = true
        tomorrowlbl.isHidden = true
        
         imgAyer.isHidden = true
         timgTomo.isHidden = true
        
         imgHoy.isHidden = true
        
         kpiAyer.isHidden = true
        kpiHoy.isHidden = true
         kpiTomo.isHidden = true
         montotxt.isHidden = true
        comprabtn.isHidden = true
        lbMonto.isHidden = true
    }
    
    func muestraDetalle(){
        ayerlb.isHidden = false
        hoylbl.isHidden = false
        tomorrowlbl.isHidden = false
        
         imgAyer.isHidden = false
         timgTomo.isHidden = false
        
         imgHoy.isHidden = false
        
         kpiAyer.isHidden = false
        kpiHoy.isHidden = false
         kpiTomo.isHidden = false
         montotxt.isHidden = false
        comprabtn.isHidden = false
        lbMonto.isHidden = false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
