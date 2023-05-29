import UIKit

typealias EmptyAction =  (() -> ())

public struct CountryDTO{
    
    private var countriesName   : String = ""
    private var dialCode        : String = ""
    private var countryCode     : String = ""
    private var flag            : UIImage?
    
    init?(json : NSDictionary) {
        self.countriesName  = json["name"] as! String
        self.dialCode       = json["dial_code"] as! String
        self.countryCode    = json["code"] as! String
        
        let path = Bundle.module.path(forResource: self.countryCode, ofType: "png")
        self.flag           = UIImage(contentsOfFile: path ?? "")
    }
    
    /**
     * full name of the country
     * dial code of the country with + embeded
     * country code
     * image of the flag of the country
     */
    public func getName() -> String{
        return self.countriesName
    }
    
    public func getDialCode() -> String{
        return String(format: "+%@", self.dialCode)
    }
    
    public func getCountryCode() -> String{
        return self.countryCode
    }
    
    public func getFlagImage() -> UIImage?{
        return self.flag
    }
}

public protocol CountryManagerDelegate{
    func didLoadCountry(countryList : [CountryDTO])
}

public class CountryManager{
    
    var delegate : CountryManagerDelegate
    
    private var countryList : [CountryDTO] = []
    
    public var count : Int {
        return countryList.count
    }
    
    //MARK: initialization
    public init(delegate : CountryManagerDelegate){
        self.delegate = delegate
        self.setupCountries()
    }
    
    //MARK: public func
    public func getCountryList() -> [CountryDTO] {
        return self.countryList
    }
    
    //MARK: private func
    /*
     get countries form json files from the bundle
     */
    private func setupCountries(){
        do {
            if let file = Bundle.module.url(forResource: "countryCodes", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSArray
                
                for object in json {
                    let dict = object as! NSDictionary
                    if let dto = CountryDTO.init(json: dict)
                    {
                        self.countryList.append(dto)
                    }
                }
                self.delegate.didLoadCountry(countryList: self.countryList)
            } else {
            }
        } catch {
        }
    }
}
