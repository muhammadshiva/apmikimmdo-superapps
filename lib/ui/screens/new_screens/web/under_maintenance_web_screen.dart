import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:marketplace/ui/widgets/rounded_button.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;

class UnderMaintenanceWeb extends StatelessWidget {
  const UnderMaintenanceWeb({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Center(
            child: Text("PanenPanen Web Under Maintenance",style: AppTypo.body1.copyWith(fontSize: 32),),
          ),
          RoundedButton.contained(label: "Ke toko reseller", onPressed: (){
            context.beamToNamed('/wppid/toko-st');
          })
        ],
      ),
    );
  }
}