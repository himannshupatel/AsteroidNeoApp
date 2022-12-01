//
//  NeoFeeds.swift
//  AsteroidNeoApp
//
//  Created by HimAnshu Patel on 29/11/22.
//

import Foundation

class WSResponseData : Codable {
    
}

class NeoFeeds : WSResponseData {
    var element_count : Int?
    var near_earth_objects : NearEarthMainObject?
    
    enum CodingKeys: String, CodingKey {
        case element_count = "element_count"
        case near_earth_objects = "near_earth_objects"
    }
    
    private struct CodingKeysDates : CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        element_count = try values.decodeIfPresent(Int.self, forKey: .element_count)
        near_earth_objects = try values.decodeIfPresent(NearEarthMainObject.self, forKey: .near_earth_objects)
    }
}

class NearEarthMainObject : WSResponseData {
    var near_earth_objects : [String: [NearEarthObject]]?
    
    private struct CodingKeys : CodingKey {
        var stringValue: String
        init?(stringValue: String) { self.stringValue = stringValue}

        var intValue: Int?
        init?(intValue: Int) { return nil}
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.near_earth_objects = [:]
        for key in values.allKeys {
            if let dataarr = try? values.decode([NearEarthObject].self, forKey:key) {
                self.near_earth_objects?[key.stringValue] = dataarr
            }
        }
    }
}

class NearEarthObject : WSResponseData {
    var id : String?
    var name : String?
    var estimated_diameter : EstimatedDiameter?
    var close_approach_data : [Close_approach_data]?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case estimated_diameter = "estimated_diameter"
        case close_approach_data = "close_approach_data"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        estimated_diameter = try values.decodeIfPresent(EstimatedDiameter.self, forKey: .estimated_diameter)
        close_approach_data = try values.decodeIfPresent([Close_approach_data].self, forKey: .close_approach_data)
    }
}

class EstimatedDiameter : Codable {
    var kilometers : Diamiters?
    var meters : Diamiters?
    var miles : Diamiters?
    var feet : Diamiters?
}

class Diamiters : Codable {
    var estimated_diameter_min : Double?
    var estimated_diameter_max : Double?
}

class Close_approach_data : WSResponseData {
    var close_approach_date : String?
    var close_approach_date_full : String?
    var epoch_date_close_approach : Int?
    var relative_velocity : Relative_velocity?
    var miss_distance : Miss_distance?
    var orbiting_body : String?

    enum CodingKeys: String, CodingKey {

        case close_approach_date = "close_approach_date"
        case close_approach_date_full = "close_approach_date_full"
        case epoch_date_close_approach = "epoch_date_close_approach"
        case relative_velocity = "relative_velocity"
        case miss_distance = "miss_distance"
        case orbiting_body = "orbiting_body"
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        close_approach_date = try values.decodeIfPresent(String.self, forKey: .close_approach_date)
        close_approach_date_full = try values.decodeIfPresent(String.self, forKey: .close_approach_date_full)
        epoch_date_close_approach = try values.decodeIfPresent(Int.self, forKey: .epoch_date_close_approach)
        relative_velocity = try values.decodeIfPresent(Relative_velocity.self, forKey: .relative_velocity)
        miss_distance = try values.decodeIfPresent(Miss_distance.self, forKey: .miss_distance)
        orbiting_body = try values.decodeIfPresent(String.self, forKey: .orbiting_body)
    }

}

class Miss_distance : Codable {
    var astronomical : String?
    var lunar : String?
    var kilometers : String?
    var miles : String?

    enum CodingKeys: String, CodingKey {

        case astronomical = "astronomical"
        case lunar = "lunar"
        case kilometers = "kilometers"
        case miles = "miles"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        astronomical = try values.decodeIfPresent(String.self, forKey: .astronomical)
        lunar = try values.decodeIfPresent(String.self, forKey: .lunar)
        kilometers = try values.decodeIfPresent(String.self, forKey: .kilometers)
        miles = try values.decodeIfPresent(String.self, forKey: .miles)
    }
}

class Relative_velocity : Codable {
    var kilometers_per_second : String?
    var kilometers_per_hour : String?
    var miles_per_hour : String?

    enum CodingKeys: String, CodingKey {

        case kilometers_per_second = "kilometers_per_second"
        case kilometers_per_hour = "kilometers_per_hour"
        case miles_per_hour = "miles_per_hour"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        kilometers_per_second = try values.decodeIfPresent(String.self, forKey: .kilometers_per_second)
        kilometers_per_hour = try values.decodeIfPresent(String.self, forKey: .kilometers_per_hour)
        miles_per_hour = try values.decodeIfPresent(String.self, forKey: .miles_per_hour)
    }
}
