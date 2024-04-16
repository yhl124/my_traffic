//
//  CoreDataManager.swift
//  my_traffic
//
//  Created by yhl on 4/14/24.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    // 👉 앱의 라이프사이클 동안 한번 생성하게되면 중복되지 않고 어디서든 동일한 인스턴스를 호출할 수 있도록 싱글톤 패턴을 적용.
    static let shared = CoreDataManager()
    private init() { }

    // ✅ AppGroup 을 활용하여 CoreData 로 저장한 데이터를 공유.
    private let appGroup = "group.com.mytraffic"

    lazy var persistentContainer: NSPersistentContainer = {

        // ✅ App Group identifier 와 연결된 container directory 를 반환. 즉, 해당 group 의 공유 directory 의 파일 시스템 내 위치를 지정하는 NSURL 인스턴스를 반환.
        guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else { fatalError("Shared file container could not be created.") }

        let storeURL = url.appending(path: "my_traffic.sqlite")

        // ✅ persistent store 를 생성 및 로드하는데 사용되는 description object.
        let storeDescription = NSPersistentStoreDescription(url: storeURL)

        let container = NSPersistentContainer(name: "my_traffic")

        // ✅ 생성된 container 에서 사용하는 persistent store 의 타입을 재정의하려면 NSPersistentStoreDescription 배열로 설정할 수 있다.
        container.persistentStoreDescriptions = [storeDescription]

        // ✅ container 가 persistent store 를 로드하고, CoreData stack 을 생성 완료하도록 지시한다.
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

extension CoreDataManager {
    // ✅ scene 이 foreground 에서 background 로 전환될 때 호출되는 sceneDidEnterBackground(_ scene:) 메서드가 SceneDelegate 에서 구현되어있습니다.
    // 해당 메서드가 호출될 때, CoreData 의 변경사항을 저장하기 위해 saveContext() 메서드를 호출해야 합니다.(AppDelegate 에 있던 코드 그대로 사용하였습니다.)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


    func fetch(entityName: String) -> [NSManagedObject] {
        let viewContext = persistentContainer.viewContext

        // ✅ entityName 파라미터에 따라서 해당 entity 를 조회하는 request 생성.
        let fetchReqeust = NSFetchRequest<NSManagedObject>(entityName: entityName)

        do {
            // ✅ 조회.
            let fetchResult = try viewContext.fetch(fetchReqeust)

            return fetchResult
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
