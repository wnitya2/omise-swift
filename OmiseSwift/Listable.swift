import Foundation

public protocol Listable { }

public class ListParams: Params {
    // from to offset limit order
    public var from: NSDate? {
        get { return get("from", DateConverter.self) }
        set { set("from", DateConverter.self, toValue: newValue) }
    }
    
    public var to: NSDate? {
        get { return get("to", DateConverter.self) }
        set { set("to", DateConverter.self, toValue: newValue) }
    }
    
    public var offset: Int? {
        get { return get("offset", IntConverter.self) }
        set { set("offset", IntConverter.self, toValue: newValue) }
    }
    
    public var limit: Int? {
        get { return get("limit", IntConverter.self) }
        set { set("limit", IntConverter.self, toValue: newValue) }
    }
    
    public var order: Ordering? {
        get { return get("order", EnumConverter.self) }
        set { set("order", EnumConverter.self, toValue: newValue) }
    }
}

public extension Listable where Self: ResourceObject {
    public typealias ListOperation = DefaultOperation<OmiseList<Self>>
    
    public static func list(using given: Client? = nil, params: ListParams? = nil, callback: Request<ListOperation>.Callback?) -> Request<ListOperation>? {
        let attributes = params?.normalizedAttributes ?? [:]
        
        let client = resolveClient(given: given)
        return client.call(ListOperation(klass: self, attributes: attributes), callback: callback)
    }
}