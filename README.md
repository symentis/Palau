# Palau

Palau is a simple wrapper for NSDefaults.
Out-of-the-box it handles storing Types like Int, String, Array<String>, RawRepresentable and NSCoding.


## Usage 
Once you import the module you can setup Defaults like:

```
import Palau
extension PalauDefaults {
  public static var name: PalauDefaultsEntry<String> {
    get { return value("name") }
    set { }
  }
}
```

By Default a Value will always be optional. 
If you want to set a value you call:

```
PalauDefaults.name.value = "String"
```
## Usage with fallback

If you want to provide a fallback, when there is no value set,
you can write:

```
import Palau
extension PalauDefaults {
  public static var color: PalauDefaultsEntry<UIColor> {
    get { return value("color")
                 .whenNil(use: UIColor.redColor())  }
    set { }
  }
}
/// is redColor() 
let color: UIColor? = PalauDefaults.color.value
```

## Usage with ensure

You can also build up arbitrary rules for your value like:

```
  public static var ensuredIntValue: PalauDefaultsEntry<Int> {
    get { return value("ensuredIntValue")
      .whenNil(use: 10)
      .ensure(when: lessThan10, use: 10) }
    set { }
  }
```






