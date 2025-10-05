import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/helpers/status_builder.dart';
import '../../../../core/widgets/image_widgets/custom_image_slider.dart';
import '../../../../core/widgets/scaffolds/auth_scaffold.dart';
import '../../../home/cubit/home_cubit.dart';
import '../../data/models/home_model.dart';
import '../cubits/home_cubit.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainViewCubit()..getHomeData(),
      child: BlocBuilder<MainViewCubit, AsyncState<HomeModel>>(
        builder: (context, state) => CenterCardScaffold.withCenteredCard(
            upperWidget: Container(),
            body: Container(),
            centerCardBody: StatusBuilder(
                data: state,
                onSuccess: (data, context) => ImageSlider(
                    images: state.data.banners!.map((e) => e.image??'').toList()
                )
            )
        ),
      ),
    );
  }
}
