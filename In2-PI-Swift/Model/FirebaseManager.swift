//
//  FirebaseManager.swift
//  
//
//  Created by Terry Bu on 2/7/16.
//
//

import Foundation
import Firebase

class FirebaseManager {
    
    static let sharedManager = FirebaseManager()
    var rootRef = Firebase(url:"https://in2-pi.firebaseio.com")
    var noticesArray: [Notice]?

    func loginUser(email: String, password: String, completion: ((success: Bool) -> Void)) {
        rootRef.authUser(email, password: password,
            withCompletionBlock: { error, authData in
                if error != nil {
                    // There was an error logging in to this account
                    print(error)
                    completion(success: false)
                } else {
                    // Authentication just completed successfully :)
                    // The logged in user's unique identifier
                    print(authData.uid)
//                    print(authData.providerData)
//                    let providerData = authData.providerData as NSDictionary
//                    let profileURL = providerData.objectForKey("profileImageURL")
//                    print(profileURL) 
                    completion(success: true)
                }
        })
    }
    
    func createUser(email: String, password: String, firstName: String, lastName: String, birthdayString: String, completion: ((success:Bool) -> Void)) {
        rootRef.createUser(email, password: password,
            withValueCompletionBlock: { error, result in
                if error != nil {
                    // There was an error creating the account
                    print(error)
                    completion(success: false)
                } else {
                    let uid = result["uid"] as? String
                    print("Successfully created user account with uid: \(uid)")
                    completion(success: true)
                    // Create a new user dictionary accessing the user's info
                    // provided by the authData parameter
                    let newUser = [
                        "firstName": firstName,
                        "lastName": lastName,
                        "birthday": birthdayString
                    ]
                    // Create a child path with a key set to the uid underneath the "users" node
                    // This creates a URL path like the following:
                    //  - https://<YOUR-FIREBASE-APP>.firebaseio.com/Users/<uid>
                    self.rootRef.childByAppendingPath("Users")
                        .childByAppendingPath(uid).setValue(newUser)
                    
                    //Because Firebase signup does not AUTHENTICAT the user, must fire login again 
                    self.loginUser(email, password: password, completion: { (success) -> Void in
                        //completion block
                    })
                }
        })
    }
    
    //MARK: writing to firebase
    
    func createNewNoticeOnFirebase(notice: Notice, completion: (success: Bool)->Void) {
        let noticesRef = rootRef.childByAppendingPath("Notices")
        let noticeDict = [
            "title": notice.title,
            "body": notice.body,
            "link": notice.link,
            "date": notice.date,
            "active": 0
        ]
        let newNoticeIDRef = noticesRef.childByAutoId()
        newNoticeIDRef.setValue(noticeDict) { (error, firebase) -> Void in
            if error != nil {
                print(error)
                completion(success: false)
            } else {
                print("new notice created")
                completion(success: true)
            }
        }
    }
    
    func getNoticeObjectsFromFirebase(completion: (success: Bool)->Void) {
        // Get a reference to our posts
        var ref = rootRef.childByAppendingPath("Notices")
        // Attach a closure to read the data at our posts reference
        ref.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            if let snapshotDict = snapshot.value as? NSDictionary {
                self.noticesArray = []
                for noticeObjectKey in snapshotDict.allKeys {
                    //looping through all hashes
                    print(noticeObjectKey)
                    if let noticeDictionary = snapshotDict.objectForKey(noticeObjectKey) as? NSDictionary {
                        // get dictionary for individual record for specific hash
                        let title = noticeDictionary.objectForKey("title") as! String
                        let body = noticeDictionary.objectForKey("body") as! String
                        let link = noticeDictionary.objectForKey("link") as! String
                        let date = noticeDictionary.objectForKey("date") as! String
                        let active = noticeDictionary.objectForKey("active") as! NSNumber
                        let notice = Notice(title: title, body: body, link: link, date: date)
                        notice.active = active.boolValue
                        notice.firebaseID = noticeObjectKey as? String
                        self.noticesArray!.append(notice)
                    }
                }
                completion(success: true)
            }
            }, withCancelBlock: { error in
                print(error.description)
                completion(success: false)
        })
    }
    
    func updateNoticeObjectActiveFlag(notice: Notice, completion: (success: Bool) -> Void) {
        let noticeRef = rootRef.childByAppendingPath("Notices").childByAppendingPath(notice.firebaseID!)
        noticeRef.updateChildValues(["active" : notice.active], withCompletionBlock: { error, firebaseRef in
            if error == nil {
                print("updating child values completed \(firebaseRef.key)")
                completion(success: true)
            } else {
                print(error)
                completion(success:false)
            }
        })
    }
    
}