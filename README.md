# SwiftyNet
A generic network layer written in swift
An abstraction layer above Alamofire


# SwiftyNet 1.0.0

## Installation
### CocoaPods

For SwiftyNet, use the following entry in your Podfile:

```rb
pod 'SwiftyNet', '~> 1.0.0'
```
Then run `pod install`.

## Usage

You can see [The Provided Example](https://github.com/mohammed-salah-zidane/SwiftyNet/tree/main/Example/SwiftNetTest), using SwiftyNet is really simple. You can access an API with the return object type you want:

```swift
  let request = UsersRequests.getUsers
  let router = NetworkRouter()
      
  router.request( 
      targetRequest: request,
      responseObject: BaseResponse<[UserModel]>.self
  ) { result in
       switch result {
        case .success(let data):
              print(data.data?.count)
        case .failure(let error):
              print(error.errorDescription)
        default:
              fatalError()
        }
  }
```

## License

Moya is released under an MIT license. See [License.md](https://github.com/Moya/Moya/blob/master/License.md) for more information.
