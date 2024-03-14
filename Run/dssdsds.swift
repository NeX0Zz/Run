import Foundation
import HealthKit


struct DateStepPair {
    let date: Date
    let steps: Int
}
class lol{
    
    func fetchSteps(from startDate: Date, to endDate: Date, completion: @escaping ([DateStepPair]) -> Void) {
        let healthStore = HKHealthStore()
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let query = HKSampleQuery(sampleType: stepsQuantityType,
                                  predicate: HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate),
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: nil) { (query, samples, error) in
            guard let samples = samples as? [HKQuantitySample] else {
                completion([])
                return
            }
            
            let dateSteps = Dictionary(grouping: samples, by: { Calendar.current.startOfDay(for: $0.endDate) })
   
            let dateStepPairs = dateSteps.map { (date, samples) in
                let steps = samples.reduce(0) { (total, sample) in total + Int(sample.quantity.doubleValue(for: HKUnit.count())) }
                return DateStepPair(date: date, steps: steps)
            }
            let sortedDateStepPairs = dateStepPairs.sorted { $0.date < $1.date }
            
            completion(sortedDateStepPairs)
        }
        healthStore.execute(query)
    }
    
    let calendar = Calendar.current.startOfDay(for: .now)
    let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
    let endDate = Date()
    
//    fetchSteps(from: startDate, to: endDate) { weeklyData in
//        print("Weekly data: \(weeklyData)")
//    }
}
