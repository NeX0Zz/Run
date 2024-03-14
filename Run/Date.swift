import Foundation

func getDate() -> String{
    let todayDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .none
    dateFormatter.dateFormat = "dd.MM"
    dateFormatter.locale = Locale(identifier: "ru_RU")
    let dateString = dateFormatter.string (from: todayDate)
    return dateString
}
