//
//  MapaViewController.swift
//  inversiones-ios
//
//  Created by Grisel Angelica Perez Quezada on 23/03/23.
//

import UIKit
import CoreLocation
import MapKit

class MapaViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager:  CLLocationManager!
    var elMapa:MKMapView!
    var estadioAzul = CLLocationCoordinate2D(latitude: 19.3834381, longitude: -99.1804635)
    var  markers = [Locations]()
  

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        //precision  de la frecuencia con que se va a estar obteniendo las lecturas y gasto de bateria
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        locationManager.delegate = self
        elMapa = MKMapView()
        elMapa.frame = self.view.bounds
        elMapa.delegate = self
        self.view.addSubview(elMapa)
        getBanks()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global().async { [self] in
            if CLLocationManager.locationServicesEnabled() {
                // Verificar permisos para mi aplicación
                if self.locationManager.authorizationStatus == .authorizedAlways ||
                    self.locationManager.authorizationStatus == .authorizedWhenInUse {
                    // si tengo permiso de usar el gps, entonces iniciamos la detección
                    locationManager.startUpdatingLocation()
                    
                   
                    
                   
                }
                else {
                    // no tenemos permisos, hay que volver a solicitarlos
                    locationManager.requestAlwaysAuthorization()
                }
            }
            else {
                let ac = UIAlertController(title:"Error", message:"Lo sentimos, pero al parecer no hay geolocalización. Deseas habilitarla?", preferredStyle: .alert)
                let action = UIAlertAction(title: "SI", style: .default) {
                    action1 in
                    // abrimos los setting del dispositivo para que habilite la localizacion
                    let settingsURL = URL(string: UIApplication.openSettingsURLString)!
                    if UIApplication.shared.canOpenURL(settingsURL) {
                        UIApplication.shared.open(settingsURL, options: [:])
                    }
                }
                ac.addAction(action)
                let action2 = UIAlertAction(title: "NO", style: .default) {
                    action2 in
                    // Si necesitamos terminar una app. El código indica el tipo de error
                    //exit(666)
                }
                ac.addAction(action2)
                self.present(ac, animated: true)
            }
            
        }
    }
    
    
    @objc func ubicacionActualizada(_ notificacion: Notification){
        if let userInfo = notificacion.userInfo {
            let latitud = userInfo["lat"] as? Double ?? 0
            let longitud = userInfo["lon"] as? Double ?? 0
            let nuevaCoordenada = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
            elMapa.setRegion(MKCoordinateRegion(center: nuevaCoordenada, latitudinalMeters: 50, longitudinalMeters: 50), animated: true)
            let elPin = MKPointAnnotation()
            elPin.coordinate = nuevaCoordenada
            elPin.title = "you are here"
            elMapa.addAnnotation(elPin)
            destino(centro: nuevaCoordenada)
        }
    }
    
    func getBanks(){
        
        if NetMonitor.shared.isConnected {
            print("entro2")
            let urlSessionConfiguration = URLSessionConfiguration.ephemeral
          
            //config.waitsForConnectivity = true
            urlSessionConfiguration.timeoutIntervalForRequest = 30
            urlSessionConfiguration.timeoutIntervalForResource = 30
            let urlSession = URLSession(configuration: urlSessionConfiguration)
            var pag = endPoint.ipApi+"getLocations/"
            guard let laUrl = URL(string: pag) else{ return}
            print(laUrl)
            
            
            
            var urlRequest: URLRequest = URLRequest(url: laUrl)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
           
            
            urlSession.dataTask(with: urlRequest) { data, response, error in
                // Qué haremos cuando obtengamos una repuesta
                if error == nil {
                    
                    guard let datas = data,  let resp = response as? HTTPURLResponse else {
                       
                        return
                    }
                    
                    DispatchQueue.main.async { [self] in
                        
                        do {
                            //todo lo ui
                         markers = try JSONDecoder().decode([Locations].self, from: datas)
                            for m in markers{
                             
                                let nuevaCoordenada = CLLocationCoordinate2D(latitude: Double(m.latitud)!, longitude: Double(m.longitud)!)
                                elMapa.setRegion(MKCoordinateRegion(center: nuevaCoordenada, latitudinalMeters: 50, longitudinalMeters: 50), animated: true)
                                let elPin = MKPointAnnotation()
                                elPin.coordinate = nuevaCoordenada
                                
                                elPin.title = "BANK: \(m.atm)"
                                elMapa.addAnnotation(elPin)
                            }
                            
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
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //cambiar las anotaciones del mapa
        let anotacion = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "reuseIdentifier")
        
        var cad = "\(annotation.title)"
        cad.contains("BANK")
        print( cad.contains("BANK"))
        if annotation.title == "BANK: 28"{
            anotacion.glyphImage = UIImage(named: "banking")
            anotacion.markerTintColor = .cyan
        }
        else if( cad.contains("BANK")){
            anotacion.glyphImage = UIImage(named: "banking")
            anotacion.markerTintColor = .blue
        }
        else{
            anotacion.glyphImage = UIImage(systemName: "person.circle")
            anotacion.glyphTintColor = UIColor.blue
        }
        
        
        
        return anotacion
    }
    
    
    func mostrarRuta(centro: CLLocationCoordinate2D ){
        //self.elMapa.removeOverlays(self.elMapa.overlays)
        print("bancos: ",markers, markers.count)
        
        print("overlays:",elMapa.overlays.count, elMapa.overlays)
        
        
        var bank: Locations?
        print(Int.random(in: 1..<60))
        bank = markers[Int.random(in: 1..<markers.count)]
        print(bank)
        var locBank = CLLocationCoordinate2D(latitude: Double(bank!.latitud)!, longitude: (Double(bank!.longitud)!))
        
        let indicaciones = MKDirections.Request()
        indicaciones.source = MKMapItem(placemark: MKPlacemark(coordinate: centro))
        indicaciones.destination = MKMapItem(placemark: MKPlacemark(coordinate: locBank))
        indicaciones.transportType = .any
        indicaciones.requestsAlternateRoutes = true
        
        let rutas = MKDirections(request: indicaciones)
        rutas.calculate { response, error in
            if error != nil {
                print("No se obtuvieron las rutas\(String(describing: error))")
            }
            else{
                guard let lasRutas = response?.routes else { return }
                var distancias = [Double]()
                if(self.elMapa.overlays.count > 0){
                    self.elMapa.removeOverlays(self.elMapa.overlays)
                }
                for r in lasRutas{
                    distancias.append(Double(r.distance))
                }
                
                self.bubble(arr: &distancias)
                print(distancias)
                    
               
                for r in lasRutas {
                    if(r.distance == distancias[0]){
                        self.elMapa.addOverlay(r.polyline)
                    }
                }
                
               
               
              
                
            }
        }
        
          
    }
    
    func bubble(arr: inout [Double]) {
        for i in (1..<arr.count).reversed() {
            for j in 0..<i where arr[j] > arr[j + 1] {
                arr.swapAt(j, j + 1)
            }
        }
    }
    
    func destino(centro: CLLocationCoordinate2D){
        /*let elPin = MKPointAnnotation()
        elPin.coordinate = estadioAzul
        elPin.title = "META"
        elMapa.addAnnotation(elPin)*/
       mostrarRuta(centro: centro)
    }
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        //para que si se vea la linea en el mapa para todas las overlays
        
        var   lineaParaDibuar = MKPolylineRenderer()
        if let linea = overlay as? MKPolyline {
             lineaParaDibuar = MKPolylineRenderer(polyline: linea)
            lineaParaDibuar.strokeColor = UIColor.green
            lineaParaDibuar.lineWidth = 2.0
               
            }
        return lineaParaDibuar
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.first else { return }
        print("parece que estas en: \(loc.coordinate)")
       
        NotificationCenter.default.post(name:NSNotification.Name("ubicacion_actualizada"), object: nil, userInfo: ["lat":loc.coordinate.latitude, "lon": loc.coordinate.longitude])
        let ad = UIApplication.shared.delegate as! AppDelegate
        ad.elCenter = loc.coordinate
        CLGeocoder().reverseGeocodeLocation(loc){ [self] lugares, error in
            if error != nil {
                print("ocurrio un error en la localizacion \(String(describing: error))")
            }
           
            
          
             
             if let centro = ad.elCenter {
               
             elMapa.setRegion(MKCoordinateRegion(center: centro,  latitudinalMeters: 50, longitudinalMeters: 50), animated: true)
             let elPin = MKPointAnnotation()
                 elPin.coordinate = centro
                
             elPin.title = "you are here, House"
             elMapa.addAnnotation(elPin)
            destino(centro: centro)
             }
             else{
             elMapa.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 19.468374833936412, longitude: -99.27710057919235), latitudinalMeters: 500, longitudinalMeters: 500), animated: true)
             
             NotificationCenter.default.addObserver(self, selector: #selector(ubicacionActualizada(_:)), name: NSNotification.Name("ubicacion_actualizada"), object: nil)
             
             }
            
               
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    
    

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       print("ocurrio un error:\(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let permiso = manager.authorizationStatus
        
        if permiso == .authorizedAlways || permiso == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        else{
            print("noa utoriza el permiso GPS.. que hacemos")
        }
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
