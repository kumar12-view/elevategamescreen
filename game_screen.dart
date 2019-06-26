import 'package:flutter/material.dart';
import '../models/question_model.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/game_over.dart';
import 'dart:async';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class GameScreen extends StatefulWidget{
    final List<QuestionModel> questions;
    GameScreen({this.questions}); 
    @override
    State<StatefulWidget> createState() {
      return GameScreenState(questions:questions);
    }
}

class GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final changeNotifier = new StreamController.broadcast();
  bool _isOptionTap = false;
  bool _isSubmitAns = false;
  int  submitAnsValue = 0;  
  int _correctScore=0;
  bool _isCorrect = false;
  int qIndex = 0; 
  
  final _commentWidgetsA = <Widget>[];
  final _commentWidgetsB = List<Widget>();
  final _commentWidgetsC = List<Widget>();
  final _commentWidgetsD = List<Widget>();

  AnimationController _circleScaleController;
  AnimationController _controller1;
  AnimationController _controller2;
  AnimationController _controller3;
  SequenceAnimation sequenceAnimation1;
  SequenceAnimation sequenceAnimation2; 
  SequenceAnimation sequenceAnimation3;  

  final List<QuestionModel> questions;
  GameScreenState({this.questions});  
  var myColor = Colors.green[100]; 
  var myHeight = 10.0;
  var myWidth = 10.0; 
  Timer _timer; 
  @override
  void dispose() {
    super.dispose();
     changeNotifier.close();
    _circleScaleController.dispose();
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
  }
 
  void initState(){
    super.initState();
    _circleScaleController = AnimationController(
       duration: Duration(milliseconds:300),vsync: this,); 

    _controller1 = AnimationController(duration: Duration(milliseconds: 2000),vsync: this);
    _controller2 = AnimationController(duration: Duration(milliseconds: 2000),vsync: this);
    _controller3 = AnimationController(duration: Duration(milliseconds: 2000),vsync: this);

   sequenceAnimation1 = new SequenceAnimationBuilder()
    .addAnimatable(
      animatable: EdgeInsetsTween(begin:EdgeInsets.fromLTRB(0,0,40,0),end: EdgeInsets.fromLTRB(7,0,0,40)),
        from: Duration.zero,
        to: Duration(milliseconds:500),
        curve: Curves.ease,
        tag: "margin"
    ).addAnimatable(
      animatable: EdgeInsetsTween(begin:EdgeInsets.fromLTRB(7,0,0,40),end: EdgeInsets.fromLTRB(40,0,0,0)),
        from: Duration(milliseconds:500),
        to: Duration(milliseconds:1000),
        curve: Curves.ease,
        tag: "margin"
    ).addAnimatable(
      animatable: EdgeInsetsTween(begin:EdgeInsets.fromLTRB(40,0,0,0),end: EdgeInsets.fromLTRB(0,40,8,0)),
        from: Duration(milliseconds:1000),
        to: Duration(milliseconds:1500),
        curve: Curves.ease,
        tag: "margin"
    ).addAnimatable(
      animatable: EdgeInsetsTween(begin:EdgeInsets.fromLTRB(0,40,8,0),end: EdgeInsets.fromLTRB(0,0,40,0)),
        from: Duration(milliseconds:1500),
        to: Duration(milliseconds:2000),
        curve: Curves.ease,
        tag: "margin"
    ).animate(_controller1); 
    
    sequenceAnimation2 = new SequenceAnimationBuilder()
    .addAnimatable(
      animatable: EdgeInsetsTween(begin:EdgeInsets.fromLTRB(50,0,0,0),end: EdgeInsets.fromLTRB(0,0,7,50)),
        from: Duration.zero,
        to: Duration(milliseconds:500),
        curve: Curves.ease,
        tag: "margin_o"
    ).addAnimatable(
      animatable: EdgeInsetsTween(begin:EdgeInsets.fromLTRB(0,0,7,50),end: EdgeInsets.fromLTRB(0,0,50,7)),
        from: Duration(milliseconds:500),
        to: Duration(milliseconds:1000),
        curve: Curves.ease,
        tag: "margin_o"
    ).addAnimatable(
      animatable: EdgeInsetsTween(begin:EdgeInsets.fromLTRB(0,0,50,7),end: EdgeInsets.fromLTRB(7,50,0,0)),
        from: Duration(milliseconds:1000),
        to: Duration(milliseconds:1500),
        curve: Curves.ease,
        tag: "margin_o"
    ).addAnimatable(
      animatable: EdgeInsetsTween(begin:EdgeInsets.fromLTRB(7,50,0,0),end: EdgeInsets.fromLTRB(50,0,0,0)),
        from: Duration(milliseconds:1500),
        to: Duration(milliseconds:2000),
        curve: Curves.ease,
        tag: "margin_o"
    ) .animate(_controller2); 

    sequenceAnimation3 = new SequenceAnimationBuilder()
    .addAnimatable(
      animatable: EdgeInsetsTween(begin:EdgeInsets.fromLTRB(0,30,0,0),end: EdgeInsets.fromLTRB(10,0,0,0)),
        from: Duration.zero,
        to: Duration(milliseconds:500),
        curve: Curves.ease,
        tag: "margin_t"
    ).addAnimatable(
      animatable: EdgeInsetsTween(begin:EdgeInsets.fromLTRB(10,0,0,0),end: EdgeInsets.fromLTRB(0,0,0,30)),
        from: Duration(milliseconds:500),
        to: Duration(milliseconds:1000),
        curve: Curves.ease,
        tag: "margin_t"
    ).addAnimatable(
      animatable: EdgeInsetsTween(begin:EdgeInsets.fromLTRB(0,0,0,30),end: EdgeInsets.fromLTRB(0,0,10,0)),
        from: Duration(milliseconds:1000),
        to: Duration(milliseconds:1500),
        curve: Curves.ease,
        tag: "margin_t"
    ).addAnimatable(
      animatable: EdgeInsetsTween(begin:EdgeInsets.fromLTRB(0,0,10,0),end: EdgeInsets.fromLTRB(0,30,0,0)),
        from: Duration(milliseconds:1500),
        to: Duration(milliseconds:2000),
        curve: Curves.ease,
        tag: "margin_t"
    ) .animate(_controller3); 
     
  } 

  _resetAnimation(){
    _controller1.reset();
    _controller2.reset();
    _controller3.reset();
    _circleScaleController.reset();
    _circleScaleController.forward();  
    _controller1.forward();
    _controller2.forward();
    _controller3.forward();
    _controller1.addStatusListener((status){
        if(status == AnimationStatus.completed){
            _controller1.reverse();
             _controller2.reverse();
             _controller3.reverse();
        }else if(status == AnimationStatus.dismissed){
           _controller1.forward();
            _controller2.forward();
            _controller3.forward();
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(qIndex == questions.length){   
       return GameOver(_correctScore,questions.length-_correctScore);
    } 
    return drawQuestion(questions[qIndex],context); 
  }  

  Widget drawQuestion(QuestionModel question,BuildContext context){
     print('drawQuestion' ); 
     return Container(
       color: Colors.green[100],
       child: Center(
          child:Stack(
              children: <Widget>[
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                      Expanded(flex:1,child: Container(child:drawQuestionText(question),),),
                      _isOptionTap ? _circleContainer(question,context) : Expanded(flex:2,child:Container(),), 
                      Expanded(flex:1,child:Container(child:drawOptions(question,context),),), 
                    ],
                  ),
                  Center(
                    child:  AnimatedContainer(
                    alignment: Alignment.center,
                    duration: Duration(milliseconds:300), 
                    color: myColor,
                    height: myHeight,
                    width: myWidth,
                    child: _isSubmitAns ? Text(
                    submitAnsValue.toString(),
                      style: TextStyle(
                       fontFamily: 'Ostrich Sans',  
                       color: Colors.white,
                       fontSize:100,  
                    ),
                  ) : Text(''),
                  ),
                  ),
            ],
          ),
        ),
     );
  }

  Widget drawQuestionText(QuestionModel question) {  
    List<String> qText = question.questionText.split("/");
    return ShowUp(
      startOffset : Offset(0,-0.35),
      endOffset : Offset(0,0.0), 
      shouldTriggerChange: changeNotifier.stream,
      delay: 500,
      child: Column(  
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            qText[0],
            style: TextStyle(
              fontFamily: 'Bebas',
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          new Text(
            'DIVIDED BY ${qText[1]}.',
            style: TextStyle(
              fontSize: 20,  
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );  
  }

  Widget _circleContainer(QuestionModel question,BuildContext context){
      return AnimatedBuilder(
        animation: _circleScaleController,
        builder: (BuildContext context, Widget child){
          double size = _circleScaleController.value*200;
          return Expanded(flex: 2,child: Container(width: size,height: size,
            child:drawCircles(question,context),),);
        },
      );
  }

  Widget _buildAnimationOne(BuildContext context, Widget child) {
    return Opacity(
            opacity:1,
            child:Container(
              margin: sequenceAnimation1["margin"].value,
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(110),
                color: Colors.green.shade300,
              ),
            ),
          );
  }
 
  Widget _buildAnimationTwo(BuildContext context, Widget child) {
    return Opacity(
            opacity:1,
            child:Container(
              margin: sequenceAnimation2["margin_o"].value,     
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(110),
                color: Colors.green.shade300,
              ),
            ),
          );
  }

  Widget _buildAnimationThree(BuildContext context, Widget child) {
    return Opacity(
            opacity:1,
            child:Container(
              margin: sequenceAnimation3["margin_t"].value,     
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(115),
                color: Colors.green.shade300,
              ),
            ),
          );
  }

  Widget drawCircles(QuestionModel question,BuildContext context){
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          AnimatedBuilder(animation: _controller1,builder: _buildAnimationOne,),
          AnimatedBuilder(animation: _controller2,builder: _buildAnimationTwo,), 
          AnimatedBuilder(animation: _controller3,builder: _buildAnimationThree,), 
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(110),
              color: Colors.green,
            ),
          ),
          _placedValue(question,context), 
        ],
      );
  }

  Widget _placedValue(QuestionModel question,BuildContext context){ 
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
           Text(
           submitAnsValue.toString(),
            style: TextStyle(
             fontFamily:'Bebas',
             fontSize:32, 
             fontWeight: FontWeight.w500,
             color: Colors.white, 
            ),
          ),
          Container(), 
          FlatButton(
            onPressed: (){
              List<String> qText = question.questionText.split("/");  
              if(submitAnsValue == int.parse(qText[0])/int.parse(qText[1])){
                   _isCorrect = true;
                   _correctScore++;
              }
              setState(() {
                _isSubmitAns = true;
                myColor= Colors.green;
                myHeight = MediaQuery.of(context).size.height;
                myWidth = MediaQuery.of(context).size.width;  
              });
              _timer = new Timer(Duration(seconds:1),(){
                 _submitAnswer(question,context);
              });
            },
            child: Text(
                'SUBMIT',
                 style: TextStyle(
                         fontFamily:'Bebas',
                         color:Colors.white,fontSize:20.0,fontWeight: FontWeight.w700),),     
          ),
        ],
      ),
    ); 
  }
  
  Widget drawOptions(QuestionModel question,BuildContext context){
     final List<int> numbers = question.kids;
     final children = <Widget>[];
     for(var i=0;i<numbers.length;i++){
        children.add(makeButton(i,numbers[i]));
     }

     return ShowUp(
        startOffset : Offset(0,0.37),
        endOffset : Offset(0,0.0),
        shouldTriggerChange: changeNotifier.stream,
        child: Container(   
          margin: EdgeInsets.only(top:5,),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(flex:3,child: Container(child:Row(children: <Widget>[
              Expanded(child: Padding(padding: EdgeInsets.all(5),child: Container(child:Column(
                 verticalDirection: VerticalDirection.up,
                 children: _commentWidgetsA,),),),),
              Expanded(child: Padding(padding: EdgeInsets.all(5),child: Container(child:Column(
                verticalDirection: VerticalDirection.up,
                children: _commentWidgetsB,),),),),
              Expanded(child: Padding(padding: EdgeInsets.all(5),child: Container(child:Column(
                verticalDirection: VerticalDirection.up,
                children: _commentWidgetsC,),),),),
              Expanded(child: Padding(padding: EdgeInsets.all(5),child: Container(child:Column(
                verticalDirection: VerticalDirection.up,
                children: _commentWidgetsD,),),),),
              ],),),
              ),

            Expanded(flex:2,child: Container(child: Row( 
              children: children, 
             ),),),
           
         ],
        ),
       ),
        delay: 700,
    );
}

Widget _tapButton(List<Widget> _widgets,int number){
  return GestureDetector(
        onTap: (){
          setState((){ 
             submitAnsValue = submitAnsValue - number;
             _widgets.removeAt(0);
          });
        },
        child: Container(
          height:30,
          decoration: BoxDecoration(
            color: Colors.yellow[300],
            borderRadius: BorderRadius.all(Radius.circular(10)), 
          ),
        ),
  );
}

Widget _tapLine(){
    return Container(margin:EdgeInsets.only(top:2,bottom:2),height:3, decoration: BoxDecoration(color:Colors.yellow[300],borderRadius: BorderRadius.all(Radius.circular(2))),);
}

  void makeBucketForButtons(List<Widget> _widgets,int number){
    print('makeBucketForButtons $number');
    var _child = null;
    var _widgetCount = _widgets.length; 
    if(_widgetCount == 0){
       _child = _tapButton(_widgets,number);
       _widgets.add(_child);  
    }else{
        _widgets.clear();
        for(var i=0;i<_widgetCount+1;i++){
            if(i== _widgetCount){
              _child = _tapButton(_widgets,number);
            }else{
              _child = _tapLine();
            }
            _widgets.add(_child);
        }
    }
  } 

  Widget makeButton(int index, int number){
     var _widgets; 
     switch (index) {
       case 0:
         _widgets = _commentWidgetsA;
         break;
       case 1:
         _widgets = _commentWidgetsB;
         break;
       case 2:
         _widgets = _commentWidgetsC;
         break;
       case 3:
        _widgets = _commentWidgetsD;
         break;
       default:
     }
    
     return Expanded(
        child: Padding(
          padding: EdgeInsets.all(2.0), 
          child: Column(
            children:  <Widget>[
              FlatButton( 
                  child: Text(number.toString(),style:TextStyle(fontFamily:'Bebas',fontSize:20,fontWeight: FontWeight.w500),), 
                  onPressed: (){
                    print('Button value $number'); 
                    setState(() {
                      if(!_isOptionTap){
                           myColor = Colors.green; 
                          _resetAnimation();  
                      }
                      _isOptionTap = true;
                       if(_widgets.length <7){
                           submitAnsValue = submitAnsValue + number; 
                           makeBucketForButtons(_widgets,number); 
                       }
                    }); 
                  },
                ),
            ],
          ),
        ),
     );
  } 

  void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child, 
      ).then((String value) {
      if (value != null) {
          print('showDemoActionSheet $value');
          setState(() {
             qIndex++;
             _isSubmitAns = false;
             myColor = Colors.green[100];  
             myHeight = 10.0;
             myWidth = 10.0;
            _isOptionTap = false; 
            submitAnsValue = 0; 
            _isCorrect = false;
            _commentWidgetsA.clear();
            _commentWidgetsB.clear();
            _commentWidgetsC.clear();
            _commentWidgetsD.clear(); 
            _resetAnimation();
             changeNotifier.sink.add(null); 
          });
      }
    });
  }

  _submitAnswer(QuestionModel question,BuildContext context){
     print('_submitAnswer');
      setState(() {
             qIndex++;
             _isSubmitAns = false;
             myColor = Colors.green[100];  
             myHeight = 10.0;
             myWidth = 10.0;
            _isOptionTap = false; 
            submitAnsValue = 0; 
            _isCorrect = false;
            _commentWidgetsA.clear();
            _commentWidgetsB.clear();
            _commentWidgetsC.clear();
            _commentWidgetsD.clear(); 
            _resetAnimation();
             changeNotifier.sink.add(null); 
    });
  }
}

class ShowUp extends StatefulWidget {
  final Stream shouldTriggerChange;
  final Widget child;
  final Offset startOffset;
  final Offset endOffset;

  final int delay;
  ShowUp({@required this.child, this.delay,this.shouldTriggerChange,this.startOffset,this.endOffset});
  @override
  _ShowUpState createState() => _ShowUpState();
}

class _ShowUpState extends State<ShowUp> with TickerProviderStateMixin {
  StreamSubscription streamSubscription;
  AnimationController _animController;
  Animation<Offset> _animOffset;
  Offset _beginOffset;
  Offset _endOffset;

  @override
  void initState() {
    super.initState();
    _beginOffset =  widget.startOffset;
    _endOffset = widget.endOffset;
    _animController = AnimationController(vsync: this, duration: Duration(milliseconds:500));
    _animOffset = _generateAnimation();
      
    if (widget.delay == null) {
      _animController.forward();
    } else {
      Timer(Duration(milliseconds: widget.delay), () {
        _animController.forward();
      });
    }
    streamSubscription = widget.shouldTriggerChange.listen((_) => _resetShowUp());
  }

   @override
  didUpdateWidget(ShowUp old) {
    super.didUpdateWidget(old);
    // in case the stream instance changed, subscribe to the new one
    if (widget.shouldTriggerChange != old.shouldTriggerChange) {
      streamSubscription.cancel();
      streamSubscription = widget.shouldTriggerChange.listen((_) => _resetShowUp());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animController.dispose();
    streamSubscription.cancel();
  }

  void _resetShowUp() {
    _beginOffset =  widget.startOffset;
    _endOffset = widget.endOffset;
    _animController.reset();
    _animOffset = _generateAnimation();
    if (widget.delay == null) {
      _animController.forward();
    } else {
      Timer(Duration(milliseconds: widget.delay),() {
        _animController.forward();
      });
    } 
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
      opacity: _animController,
    );
  }

  Animation _generateAnimation() => Tween<Offset>(begin: _beginOffset, end: _endOffset)
            .animate(CurvedAnimation(curve: Curves.decelerate, parent: _animController));
}






