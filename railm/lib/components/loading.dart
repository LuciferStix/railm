// SPDX-License-Identifier: GPL-2.0
// Author: xunicatt
// Project: railm (railm) 
// Copyright (c) 2026 xunicatt <contact.aniket.biswas@gmail.com>

import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
    const Loading({super.key});

    @override
    Widget build(BuildContext context) {
        return Center(
            child: CircularProgressIndicator(
                color: Colors.blue,
            ),
        );
    }
}
