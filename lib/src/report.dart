@MirrorsUsed(symbols: 'Report')
import 'dart:mirrors';
import './report_property.dart';

class Report {
  final String title;
  final String description;

  final bool displayUntagged;

  const Report({this.title, this.description, this.displayUntagged = false});

  static int _getMaxKeyLength(Map<String, Object> collect) {
    int l = 0;

    for (String key in collect.keys) {
      if (key.length > l) l = key.length;
    }

    return l;
  }

  static Map<String, String> _getProperties(Object o) {
    InstanceMirror im = reflect(o);
    ClassMirror cm = im.type;

    Iterable<DeclarationMirror> decls = cm.declarations.values;

    Map<String, String> properties = new Map<String, String>();

    for (DeclarationMirror mm in decls) {
      if (mm is MethodMirror) {
        MethodMirror mmcast = mm;

        if (mmcast.isGetter) {
          for (InstanceMirror mmIns in mmcast.metadata) {
            if (mmIns.reflectee is ReportProperty) {
              String key = (mmIns.reflectee as ReportProperty).title;
              var value = im.getField(mmcast.simpleName).reflectee;

              properties[key] = value != null
                  ? (mmIns.reflectee as ReportProperty).prefix +
                      value.toString() +
                      (mmIns.reflectee as ReportProperty).suffix
                  : "";
            }
          }
        }
      }
    }

    return properties;
  }

  static String generate(Object o) {
    String report = "";

    Map<String, String> properties = _getProperties(o);
    int propertiesPadLength = _getMaxKeyLength(properties);

    properties.forEach((String key, String value) {
      report += "${key.padRight(propertiesPadLength)} : ${value}\n";
    });

    return report;
  }
}
