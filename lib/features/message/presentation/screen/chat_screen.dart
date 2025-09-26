import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/bottom_nav_bar/common_bottom_bar.dart';
import 'package:testemu/core/component/other_widgets/common_loader.dart';
import 'package:testemu/core/component/screen/error_screen.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/component/text_field/common_text_field.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/constants/app_string.dart';
import 'package:testemu/core/utils/enum/enum.dart';
import '../controller/chat_controller.dart';
import '../../data/model/chat_list_model.dart';
import '../widgets/chat_list_item.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// App Bar Section Starts here
      appBar: AppBar(
        centerTitle: true,
        title: const CommonText(
          text: AppString.inbox,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      ),

      /// Body Section Starts here
      body: GetBuilder<ChatController>(
        builder: (controller) => switch (controller.status) {
          /// Loading bar here
          Status.loading => const CommonLoader(),

          /// Error Handle here
          Status.error => ErrorScreen(
            onTap: ChatController.instance.getChatRepo,
          ),

          /// Show main data here
          Status.completed => Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              children: [
                /// User Search bar here
                CommonTextField(
                  prefixIcon: const Icon(Icons.search),
                  hintText: AppString.searchDoctor,
                ),

                /// Show all Chat List here
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.chats.length,
                    padding: EdgeInsets.only(top: 16.h),
                    itemBuilder: (context, index) {
                      ChatModel item = controller.chats[index];
                      return GestureDetector(
                        /// routing with data
                        onTap: () => Get.toNamed(
                          AppRoutes.message,
                          parameters: {
                            "chatId": item.id,
                            "name": item.participant.fullName,
                            "image": item.participant.image,
                          },
                        ),

                        /// Chat List item here
                        child: chatListItem(item: controller.chats[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        },
      ),

      /// Bottom Navigation Bar Section Starts here
      bottomNavigationBar: const CommonBottomNavBar(currentIndex: 2),
    );
  }
}
