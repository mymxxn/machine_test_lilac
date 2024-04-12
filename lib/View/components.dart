import 'package:flutter/material.dart';

class Components {
  static commonTextfield(
          {required String txt,
          required TextEditingController controller,
          required TextInputType inputtype,
          Function(dynamic)? onChanged,
          bool readOnly = false}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            txt,
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(
            height: 4,
          ),
          TextField(
            readOnly: readOnly,
            controller: controller,
            keyboardType: inputtype,
            onChanged: onChanged,
            textInputAction: TextInputAction.none,
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                isCollapsed: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.black87,
                  ),
                )),
          )
        ],
      );
}
