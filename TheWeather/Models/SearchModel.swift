
import Foundation

struct SearchModel: Codable {
    let predictions: [Prediction]
    let status: String
}

struct Prediction: Codable {
    let description, id: String
    let structured_formatting: StructFormatting
}

struct StructFormatting: Codable{
    let main_text: String
    let secondary_text: String
}
