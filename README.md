# report

Generate text reports from object instances with @annotations to format and extend.

## Usage

```dart
import 'package:dart_report/report.dart';

@Report()
class Test {
  @ReportProperty("Hello msg")
  String get var1 => "hello";

  @ReportProperty("World message", suffix: "!!")
  String get var2 => "world";
}

main() {
  print(Report.generate(new Test()));
}
```

Output:
```
Hello msg     : hello
World message : world!!
```