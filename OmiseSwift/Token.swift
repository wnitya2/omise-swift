import Foundation

public class Token: ResourceObject {
    public override class var resourceEndpoint: Endpoint { return Endpoint.Vault }
    public override class var resourcePath: String { return "/tokens" }
    
    public var used: Bool? {
        get { return get("used", BoolConverter.self) }
        set { set("used", BoolConverter.self, toValue: newValue) }
    }
    
    public var card: Card? {
        get { return getChild("card", Card.self) }
        set { setChild("card", Card.self, toValue: newValue) }
    }
}

public class TokenParams: Params {
    public var name: String? {
        get { return get("card[name]", StringConverter.self) }
        set { set("card[name]", StringConverter.self, toValue: newValue) }
    }
    
    public var number: String? {
        get { return get("card[number]", StringConverter.self) }
        set { set("card[number]", StringConverter.self, toValue: newValue) }
    }
    
    public var expirationMonth: Int? {
        get { return get("card[expiration_month]", IntConverter.self) }
        set { set("card[expiration_month]", IntConverter.self, toValue: newValue) }
    }
    
    public var expirationYear: Int? {
        get { return get("card[expiration_year]", IntConverter.self) }
        set { set("card[expiration_year]", IntConverter.self, toValue: newValue) }
    }
    
    public var securityCode: String? {
        get { return get("card[security_code]", StringConverter.self) }
        set { set("card[security_code]", StringConverter.self, toValue: newValue) }
    }
    
    public var city: String? {
        get { return get("card[city]", StringConverter.self) }
        set { set("card[city]", StringConverter.self, toValue: newValue) }
    }
    
    public var postalCode: String? {
        get { return get("card[postal_code]", StringConverter.self) }
        set { set("card[postal_code]", StringConverter.self, toValue: newValue) }
    }
}

extension Token: Creatable {
    public typealias CreateParams = TokenParams
}

extension Token { // can't use Retrievable because this uses the API endpoint instead of the vault :facepalm:
    public typealias RetrieveOperation = DefaultOperation<Token>
    
    public static func retrieve(using given: Client? = nil, id: String, callback: Request<RetrieveOperation>.Callback) -> Request<RetrieveOperation>? {
        let operation = RetrieveOperation(
            endpoint: Endpoint.API,
            method: "GET",
            paths: [resourcePath, id]
        )
        
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}

func exampleToken() {
    let params = TokenParams()
    params.number = "4242424242424242"
    params.name = "JOHN SMITH"
    params.expirationMonth = 10
    params.expirationYear = 2020
    params.securityCode = "123"
    
    Token.create(params: params) { (result) in
        switch result {
        case let .Success(token):
            print("token: \(token.id)")
        case let .Fail(err):
            print("error: \(err)")
        }
    }
}
