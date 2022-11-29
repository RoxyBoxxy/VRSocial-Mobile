//
// class UIStateBuilder<C extends Cubit<CommonUIState>, CommonUIState> extends StatefulWidget {
//   final Widget onError;
//   final Widget buildHome;
//   final Widget buildInit;
//   const UIStateBuilder({Key key, this.buildHome, this.onError, this.buildInit}) : super(key: key);
//   @override
//   _UIStateBuilderState createState() => _UIStateBuilderState<C,CommonUIState>();
// }
//
// class _UIStateBuilderState<C extends Cubit<CommonUIState>, CommonUIState> extends State<UIStateBuilder> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<C,CommonUIState>(builder: (c,state)=>s,
//         success: (s)=> widget.buildHome,
//         loading: ()=> LoadingBar(),
//         error:(e)=> widget.buildHome??widget.onError));
//   }
// }
