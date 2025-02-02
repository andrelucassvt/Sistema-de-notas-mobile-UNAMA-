import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_admob/firebase_admob.dart';

void main(){
  runApp(MaterialApp(
    title: "Calcular notas",
    home: Home(),
  ));
  
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {  

  //Controladores
  TextEditingController nota1 = TextEditingController();
  TextEditingController notaColegiada = TextEditingController();
  GlobalKey<FormState> validacao = GlobalKey<FormState>();
 
  String resultado ="";
  String resultFinal = "";

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['Faculdades', 'Farmacias'],
    contentUrl: 'https://flutter.io',
    childDirected: false,
    testDevices: <String>[], // Android emulators are considered test devices
  );


 BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-3652623512305285/3005334180',
    size: AdSize.fullBanner,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("BannerAd event is $event");
    },
  );

  BannerAd _bannerAd;
  
  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-3652623512305285~5040470589");
    _bannerAd = myBanner..load()..show(anchorType: AnchorType.bottom);
  }
  void _refres(){
    setState(() {
      resultado = " ";
      nota1.text = "";
      notaColegiada.text = "";
      resultFinal = "";
      validacao = GlobalKey<FormState>();
    });
  }


  void _calcular(){
    setState(() {
      double nota1AV = double.parse(nota1.text.replaceAll(",", "."));
      double nota2AV = double.parse(notaColegiada.text.replaceAll(",", "."));
      double media = (nota1AV + nota2AV) /2;
      double provaFinal = 10 - media;
    
      String formato = provaFinal.toStringAsFixed(2);
      
      if( nota1.text.length>=5|| notaColegiada.text.length>=5){
       resultado = "Nota inválida";
       resultFinal = "";

      }else{
      
        if(nota1AV > 10 || nota2AV > 10){
          resultado = "Nota inválida";
          resultFinal = "";
          
        }else if(nota1AV < 0 || nota2AV < 0){
          resultado = "Nota inválida";
          resultFinal = "";
          
        }else{
          if(media >=7){
          resultado = "Você passou";
          resultFinal = "";

        }else if(media < 7 && media >=4){
          resultado = "Você ficou de prova final.";
          resultFinal = "Precisa tirar $formato para passar"; 
          

        }else if(media<4){
          resultado = "Você reprovou";
          resultFinal = "";
        }
        }}});

  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Scaffold(
          //Barra de cima do app
          appBar: AppBar(

            title: Text("Calcule sua nota",style: TextStyle(color: Colors.white),),
            backgroundColor: Colors.blue,
            
            actions: <Widget>[
              IconButton(icon: Icon(Icons.refresh), onPressed: (){_refres();})
            ],
            
          ),
          //Corpo do app
          body:SingleChildScrollView(

            child: Form(
            key: validacao,
            child: Column(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
            
            //Imagem adicionada
            ClipOval(
              child: Align(
                heightFactor: 1.0,
                widthFactor: 0.5,
                child: Image.asset("Imagens/ser.png",fit: BoxFit.cover,height: 150,), 
              ),
            ),
           
            SizedBox(height: 55,),
            //Area de texto 1° avaliação
            TextFormField(keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(

              labelText: "1º avaliação",labelStyle: TextStyle(color: Colors.blue,
              fontSize: 15.0),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32))
                ),
              
              style: TextStyle(color: Colors.blue,fontSize: 15.0),
              controller: nota1,
              validator: (value){
                if(value.isEmpty){
                  return "Campo vazio!!";
                }
              },
            ),

            Padding(padding: EdgeInsets.all(15.0)),
            //Area de texto 2° avaliação
            TextFormField(keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: "2º avaliação",labelStyle: TextStyle(color: Colors.blue,
              fontSize: 15.0),

               border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32))
                
                ),

                style: TextStyle(color: Colors.blue,fontSize: 15.0),
                controller: notaColegiada,
                validator: (value){
                  if(value.isEmpty){
                    return "Campo vazio!!";
                  }
                },
            ),
            
            
            ],),)
           
          ),
          
          
          
          //Barra de baxio do botão
          bottomNavigationBar: BottomAppBar(
              child: Container(height: 60.0,),
              color: Colors.blue,
              
            ),
          //Botao
          floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.offline_pin),
          label: Text("Calcule"),
          backgroundColor: Colors.green,
          onPressed: (){
            if(validacao.currentState.validate()){
              _calcular();
              showDialog<String>(context: context,
              
              builder: (BuildContext context)=> AlertDialog(

                title: Text("Resultado"),
                content: Text("$resultado \n$resultFinal"),
                actions: <Widget>[
                  FlatButton(
                  onPressed: ()=> Navigator.pop(context,'OK'),
                  child: Text("OK"))

                ],
              )
              );
            }
          },
          ),
          //Colocando o botão no centro
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      ),
    );
  }
}

