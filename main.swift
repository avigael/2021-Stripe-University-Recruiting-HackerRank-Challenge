func cleanUpMessage(_ id: String, _ message: String) -> String {
    // add merchant_id to front of message
    var finalMessage = id
    // if message is not blank then we are missing fields
    if message != "" {
        // UNVERIFIED, also drop "," at end
        finalMessage += ":UNVERIFIED:" + String(message.dropLast())
    } else {
        // no missing fields, VERFIED!
        finalMessage += ":VERFIED"
    }
    return finalMessage
}

func verify_merchants(_ provided_fields: [String]) {
    // ORGANIZE STREAM OF DATA
    var location: [String:Int] = [:] // stores location of merchant_id in group array
    var group: [[String:String]] = [] // stores all information for each merchant_id
    var count = 0 // holds the next position for new merchant_id
    // parse input
    for item in provided_fields {
        // split up into 3 parts
        let fields = item.split(separator: ",")
        let merchant_id = String(fields[0])
        let field_name = String(fields[1])
        let field_value = String(fields[2])
        // if merchant_id exists then add fields
        if let index = location[merchant_id] {
            group[index][field_name] = field_value
        } else {
            // else store new merchant_id and add fields
            location[merchant_id] = count
            group.append(["merchant_id":merchant_id])
            group[count][field_name] = field_value
            count += 1
        }
    }
    // stores the message we will print
    var message = ""
    // loop through merchants
    for member in group {
        // simple switch case checking the main categories
        switch (member["business_type"], member["country"]) {
            case ("individual", "US"):
                // ternary operator adds missing field to message string if the field does not
                // exist in our dictionary member
                message += member["first_name"] != nil ? "": "first_name,"
                message += member["last_name"] != nil ? "": "last_name,"
                message += member["date_of_birth"] != nil ? "": "date_of_birth,"
                message += member["social_security_number"] != nil ? "": "social_security_number,"
                message += member["email"] != nil ? "": "email,"
                message += member["phone"] != nil ? "": "phone,"
                // formats the message how it should be displayed "!" unwraps Optional
                print(cleanUpMessage(member["merchant_id"]!, message))
            case ("individual", "JP"):
                message += member["first_name"] != nil ? "": "first_name,"
                message += member["last_name"] != nil ? "": "last_name,"
                message += member["first_name_kana"] != nil ? "": "first_name_kana,"
                message += member["last_name_kana"] != nil ? "": "last_name_kana,"
                message += member["date_of_birth"] != nil ? "": "date_of_birth,"
                message += member["tax_id_number"] != nil ? "": "tax_id_number,"
                message += member["email"] != nil ? "": "email,"
                print(cleanUpMessage(member["merchant_id"]!, message))
            case ("individual", "FR"):
                message += member["first_name"] != nil ? "": "first_name,"
                message += member["last_name"] != nil ? "": "last_name,"
                message += member["tax_id_number"] != nil ? "": "tax_id_number,"
                message += member["email"] != nil ? "": "email,"
                message += member["phone"] != nil ? "": "phone,"
                print(cleanUpMessage(member["merchant_id"]!, message))
            case ("individual", _):
                // this means country is missing or invalid
                message += "country,"
                print(cleanUpMessage(member["merchant_id"]!, message))
            case ("company", "US"):
                message += member["name"] != nil ? "": "name,"
                message += member["employer_id_number"] != nil ? "": "employer_id_number,"
                message += member["tax_id_number"] != nil ? "": "tax_id_number,"
                message += member["support_email"] != nil ? "": "support_email,"
                message += member["phone"] != nil ? "": "phone,"
                print(cleanUpMessage(member["merchant_id"]!, message))
            case ("company", "JP"):
                message += member["name"] != nil ? "": "name,"
                message += member["tax_id_number"] != nil ? "": "tax_id_number,"
                message += member["support_email"] != nil ? "": "support_email,"
                message += member["phone"] != nil ? "": "phone,"
                print(cleanUpMessage(member["merchant_id"]!, message))
            case ("company", "FR"):
                message += member["name"] != nil ? "": "name,"
                message += member["director_name"] != nil ? "": "director_name,"
                message += member["tax_id_number"] != nil ? "": "tax_id_number,"
                message += member["phone"] != nil ? "": "phone,"
                print(cleanUpMessage(member["merchant_id"]!, message))
            case ("company", _):
                // this means country is missing or invalid
                message += "country,"
                print(cleanUpMessage(member["merchant_id"]!, message))
            default:
                // this means business_type is missing or invalid
                message += "business_type,"
                print(cleanUpMessage(member["merchant_id"]!, message))
        }
        // Reset message for next loop
        message = ""
    }
}

verify_merchants([
    "acct_456,business_type,individual",
    "acct_456,country,JP",
    "acct_456,first_name,Mei",
    "acct_456,last_name,Sato",
    "acct_456,first_name_kana,Mei",
    "acct_456,last_name_kana,Sato",
    "acct_456,date_of_birth,01011970",
    "acct_456,tax_id_number,123456789",
    "acct_456,email,test@example.com"
    ])