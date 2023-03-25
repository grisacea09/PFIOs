//
//  UsuarioPwd.swift
//  inversiones-ios
//
//  Created by Grisel Angelica Perez Quezada on 21/03/23.
//

import Foundation

struct dtoBody: Codable, Hashable {
    var username: String
    var password: String
}

struct UsuarioBody: Codable, Hashable{
    var username: String
    var password:String
    var cuenta: String
    var telefono: String
    var montoMaximo: Int
    var moneda: String
}

struct UsuarioResponseBody: Codable, Hashable{
    var response: String
}

struct ResponseDiv: Codable, Hashable{
    var id: String
    var divisaBase: String
    var divisaDestino: String
    var usuario: String
    var montoCompra: CLong
    var tasaBase: Double
    
}

struct Locations : Codable, Hashable{
    var id: String
    var atm: String
    var latitud: String
    var longitud: String
}


struct compraDivisa: Codable, Hashable{
    var divisaBase: String
    var divisaDestino: String
    var usuario: String
    var montoCompra: CLong
    var tasaBase: Double
    
}

struct Divisas: Codable, Hashable {
    var id: Int
    var simbolo: String
    var divisa: String
    var imagen: String
}



struct Serie: Codable, Hashable {
    let success, timeseries: Bool
    let start_date, end_date, base: String
    let rates: [String: Rate]

   /* enum CodingKeys: String, CodingKey {
        case success = "success"
        case timeseries = "timeseries"
        case start_date = "start_date"
        case end_date = "end_date"
        case base = "base"
        case rates = "rates"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        success = try container.decode(Bool.self, forKey: .success)
        timeseries = try container.decode(Bool.self, forKey: .timeseries)
        start_date =  try container.decode(String.self, forKey: .start_date)
        end_date =  try container.decode(String.self, forKey: .end_date)
        base  =  try container.decode(String.self, forKey: .base)
        rates = try container.decode([String: Rate].self, forKey: .rates)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(success, forKey: .success)
        try container.encode(timeseries, forKey: .timeseries)
        try container.encode(start_date, forKey: .start_date)
        try container.encode(end_date, forKey: .end_date)
        try container.encode(base, forKey: .base)
        try container.encode(rates, forKey: .rates)
      
    }*/
    
    
}

// MARK: - Rate
struct Rate: Codable, Hashable {
    var GBP: Double
    var BRL: Double
    var CAD:  Double
    var USD:  Double
    var EGP:  Double
    var EUR:  Double
    var INR:  Double
    var KPW:  Double
    var KRW:  Double
    var COP:  Double
    var CUP:  Double
    var SEK:  Double
    var RUB:  Double
    var CNY:  Double

    enum CodingKeys: String, CodingKey {
        case GBP = "GBP"
        case BRL = "BRL"
        case CAD = "CAD"
        case USD = "USD"
        case EGP = "EGP"
        case EUR = "EUR"
        case INR = "INR"
        case KPW = "KPW"
        case KRW = "KRW"
        case COP = "COP"
        case CUP = "CUP"
        case SEK = "SEK"
        case RUB = "RUB"
        case CNY = "CNY"
    }
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
    
        
        GBP = try container.decode(Double.self, forKey: .GBP)
        BRL = try container.decode(Double.self, forKey: .BRL)
        CAD = try container.decode(Double.self, forKey: .CAD)
        USD = try container.decode(Double.self, forKey: .USD)
        EGP = try container.decode(Double.self, forKey: .EGP)
        EUR = try container.decode(Double.self, forKey: .EUR)
        INR = try container.decode(Double.self, forKey: .INR)
        KPW = try container.decode(Double.self, forKey: .KPW)
        KRW = try container.decode(Double.self, forKey: .KRW)
        COP = try container.decode(Double.self, forKey: .COP)
        CUP = try container.decode(Double.self, forKey: .CUP)
        SEK = try container.decode(Double.self, forKey: .SEK)
        RUB = try container.decode(Double.self, forKey: .RUB)
        CNY = try container.decode(Double.self, forKey: .CNY)
        
        
        
        
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(GBP, forKey: .GBP)
            try container.encode(BRL, forKey: .BRL)
            try container.encode(CAD, forKey: .CAD)
            try container.encode(USD, forKey: .USD)
            try container.encode(EGP, forKey: .EGP)
            try container.encode(EUR, forKey: .EUR)
            try container.encode(INR, forKey: .INR)
            try container.encode(KPW, forKey: .KPW)
            try container.encode(COP, forKey: .COP)
            try container.encode(CUP, forKey: .CUP)
            try container.encode(SEK, forKey: .SEK)
            try container.encode(RUB, forKey: .RUB)
            try container.encode(CNY, forKey: .CNY)
        }
    
    
    
}

