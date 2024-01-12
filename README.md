# COW

A copy-on-write wrapper for Swift objects

This is mainly useful for mutable objects that you need to pass around, but you want to [try really hard to] avoid shared mutability. For example

```swift
let doc = Cow(try XMLDocument(data: someData))

func getReadOnlyValue(doc: Cow<XMLDocument>) {
	print(doc.readOnlyObject.isStandalone)
}

func mutateTheDocument(doc: inout Cow<XMLDocument>) {
	doc.mutableObject.removeChild(at: 0)
}
```

Unfortunately, if you mutate the value you get from `readOnlyObject`, you're breaking the contract, and that change will be reflected by all the other copies of this `COW`. Since Swift isn't Rust, there's not a lot that can be done about that.
