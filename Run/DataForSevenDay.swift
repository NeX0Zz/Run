import Foundation
import HealthKit

class DataForSevenDay {
    static let shared = DataForSevenDay()
    private init(){}
    
    var steps: [Double] = []
    var datee: [Date] = []
    var kcal: [Double] = []
    var meter: [Double] = []
    
    func fetchSteps2() {
        let healthStore = HKHealthStore()
        
        let typeOfQuantity = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        
        var steps: [Double] = []
        var datee: [Date] = []

        let query = HKSampleQuery(sampleType: typeOfQuantity, predicate: HKSampleQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate), limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
            if let results = results as? [HKQuantitySample] {
                var dailyData: [Date: (Double, Double)] = [:]
                for result in results {
                    let count = result.quantity.doubleValue(for: HKUnit.count())
                    let day = Calendar.current.startOfDay(for: result.startDate)
                    if let (existingCount, existingTotal) = dailyData[day] {
                        dailyData[day] = (existingCount + count, existingTotal + 1)
                    } else {
                        dailyData[day] = (count, 1)
                    }
                }

                let sortedDailyData = dailyData.sorted { $0.key < $1.key }
                steps = sortedDailyData.map { $0.value.0 }
                datee = sortedDailyData.map { $0.key }

                self.steps = steps
                self.datee = datee
            }
        }
        healthStore.execute(query)
    }
    
    func fetchSteps3() {
        let healthStore = HKHealthStore()
        
        let typeOfQuantity = HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        
        var steps: [Double] = []
        var datee: [Date] = []

        let query = HKSampleQuery(sampleType: typeOfQuantity, predicate: HKSampleQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate), limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
            if let results = results as? [HKQuantitySample] {
                var dailyData: [Date: (Double, Double)] = [:]
                for result in results {
                    let count = result.quantity.doubleValue(for: HKUnit.kilocalorie())
                    let day = Calendar.current.startOfDay(for: result.startDate)
                    if let (existingCount, existingTotal) = dailyData[day] {
                        dailyData[day] = (existingCount + count, existingTotal + 1)
                    } else {
                        dailyData[day] = (count, 1)
                    }
                }

                let sortedDailyData = dailyData.sorted { $0.key < $1.key }
                steps = sortedDailyData.map { $0.value.0 }
                datee = sortedDailyData.map { $0.key }

                self.kcal = steps
            }
        }
        healthStore.execute(query)
    }
    
    func fetchSteps4() {
        let healthStore = HKHealthStore()
        
        let typeOfQuantity = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        
        var steps: [Double] = []
        var datee: [Date] = []

        let query = HKSampleQuery(sampleType: typeOfQuantity, predicate: HKSampleQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate), limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
            if let results = results as? [HKQuantitySample] {
                var dailyData: [Date: (Double, Double)] = [:]
                for result in results {
                    let count = result.quantity.doubleValue(for: HKUnit.meter())
                    let day = Calendar.current.startOfDay(for: result.startDate)
                    if let (existingCount, existingTotal) = dailyData[day] {
                        dailyData[day] = (existingCount + count, existingTotal + 1)
                    } else {
                        dailyData[day] = (count, 1)
                    }
                }

                let sortedDailyData = dailyData.sorted { $0.key < $1.key }
                steps = sortedDailyData.map { $0.value.0 }
                datee = sortedDailyData.map { $0.key }

                self.meter = steps
            }
        }
        healthStore.execute(query)
    }
    
    func getFormattedDate(datee: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        return formatter.string(from: datee)
    }
}
