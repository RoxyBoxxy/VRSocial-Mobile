import 'package:colibri/core/common/uistate/common_ui_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget blocProvider<B extends Cubit<CommonUIState<T>>,T>(T value, B bloc)=> BlocBuilder<B,CommonUIState>(
    builder: (BuildContext context, state) => state.when(
          initial: ()=>Container(child: const Text("init"),),
          success: (d)=>Container(child: const Text("Success"),),
          loading: ()=>Container(child: const Text("loading"),),
          error: (e)=>Container(child: const Text('erro'),)),
  );

