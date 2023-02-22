# SimpleCoreData
Simple iOS App to implement persist data using [Core Data](https://developer.apple.com/documentation/coredata) (create, retreive, update and delete) and bind it to UITableViewCell.

### Function
- Create
```swift
func  create(firstName: String, lastName: String, email: String)
```
Will create `NSEntityDescription` and save it in to `NSManagedObject`
- Retreive
```swift
func  retrieve() -> [UserModel]
```
Fetching request using `NSFetchRequest<NSFetchRequestResult>`
- Update
```swift
func  update(_  firstName: String, _  lastName: String, _  email: String)
```
Filtering entity  `NSFetchRequest<NSFetchRequestResult>` with `NSPredicate` using email and then update the value and save the `NSManagedObjectContext`
- Delete
```swift
func  delete(_  email: String)
```  
Filtering entity  `NSFetchRequest<NSFetchRequestResult>` with `NSPredicate` using email and then delete the `NSManagedObjectContext`