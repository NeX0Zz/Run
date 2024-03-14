import Foundation
import HealthKit

class HealthKitManager{
    static let shared = HealthKitManager()
    
    init(){
        requestAuthorization()
    }
    
    var healthStore = HKHealthStore()
    var stepsToday: Int = 0
    var km: Int = 0
    var activity: Int = 0
    
    func requestAuthorization() {
        guard let dataToRead = HKObjectType.quantityType(forIdentifier: .stepCount),
              let dfg = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned),
              let sleep = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
              let activeEnergy = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else {return}
        
        let healthKitTypesToRead: Set<HKObjectType> = [dataToRead,activeEnergy,dfg]
        
        guard HKHealthStore.isHealthDataAvailable() else {
            print("health data is not available")
            return
        }
        
        healthStore.requestAuthorization(toShare: nil, read: healthKitTypesToRead) { success, failure in
            if success {
                self.fetchStepCount()
                self.fetchDistanceWalkingRunning()
                self.fetchActiveEnergyBurned()
            } else {
                print("!")
            }
        }
    }
    
    func fetchStepCount(){
        guard let stepCount = HKQuantityType.quantityType(forIdentifier: .stepCount) else {return}
        
        let now = Date()
        let startDate = Calendar.current.startOfDay(for: now)
        let presicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: now,
                                                    options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepCount,
                                      quantitySamplePredicate: presicate,
                                      options: .cumulativeSum){_, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print ("Failed to read user's steps with error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            let steps = Int(sum.doubleValue(for: HKUnit.count()))
            self.stepsToday = steps
        }
        healthStore.execute(query)
    }
    
    func fetchDistanceWalkingRunning(){
        guard let stepCount = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {return}
        
        let now = Date()
        let startDate = Calendar.current.startOfDay(for: now)
        let presicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: now,
                                                    options: .strictStartDate)
        
        let query1 = HKStatisticsQuery(quantityType: stepCount,
                                      quantitySamplePredicate: presicate,
                                      options: .cumulativeSum){_, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print ("Failed to read user's steps with error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            let steps = Int(sum.doubleValue(for: HKUnit.meter()))
            self.km = steps
        }
        healthStore.execute(query1)
    }
    
    func fetchActiveEnergyBurned(){
        guard let stepCount = HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned) else {return}
        
        let now = Date()
        let startDate = Calendar.current.startOfDay(for: now)
        let presicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: now,
                                                    options: .strictStartDate)
        
        let query2 = HKStatisticsQuery(quantityType: stepCount,
                                      quantitySamplePredicate: presicate,
                                      options: .cumulativeSum){_, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print ("Failed to read user's steps with error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            let steps = Int(sum.doubleValue(for: HKUnit.kilocalorie()))
            self.activity = steps
        }
        healthStore.execute(query2)
    }
    
//    func fetchHealthData() {
//        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
//        let endDate = Date()
//
//        let stepCountQuery = HKSampleQuery(sampleType: HKObjectType.quantityType(forIdentifier: .stepCount)!,
//                                           predicate: NSPredicate(format: "date >= %@ AND date <= %@", startDate as CVarArg, endDate as CVarArg),
//                                           limit: HKObjectQueryNoLimit,
//                                           sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { (query, samples, error) in
//            if let error = error {
//                print("Error fetching step count data: \(error.localizedDescription)")
//                return
//            }
//
//            guard let stepCountSamples = samples as? [HKQuantitySample] else {
//                print("Unexpected sample type in step count query.")
//                return
//            }
//
//            // Process step count data
//            var totalSteps: Double = 0
//            for sample in stepCountSamples {
//                totalSteps += sample.quantity.doubleValue(for: HKUnit.count())
//                print("Steps at \(sample.startDate): \(sample.quantity.doubleValue(for: HKUnit.count()))")
//            }
//
//            print("Total steps in the past week: \(totalSteps)")
//        }
//
//        healthStore.execute(stepCountQuery)
//    }

}

