import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testemu/core/component/appbar/common_app_bar.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/features/download/controller/download_sesone_list_controller.dart';

class DownloadSesoneListScreen extends StatelessWidget {
  const DownloadSesoneListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DownloadSesoneListController>(
      init: DownloadSesoneListController(),
      builder: (controller) {
        return Scaffold(
          appBar: CommonAppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 2.0),
                child: IconButton(
                  onPressed: () {
                    controller.valueManupolate();
                  },
                  icon: SvgPicture.asset(width: 18.w, AppImages.markIcon),
                ),
              ),
            ],
            isCenterTitle: false,
            title: "Downloaded",
            isShowBackButton: false,
          ),

          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: downloadItems.length,
                  itemBuilder: (context, index) {
                    final item = downloadItems[index];
                    return Obx(() {
                      return MovieCardD(
                        imagePath: item.imagePath,
                        title: item.name,
                        description: item.description,
                        size: item.size,
                        isMarkShowAll: controller.value.value,
                        isSelected: controller.selectedItems.contains(index),
                        onTap: () {
                          if (controller.value.value) {
                            controller.toggleSelection(index);
                          } else {
                            Get.toNamed(AppRoutes.downloadEpisodList);
                          }
                        },
                      );
                    });
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: Obx(() {
            return controller.value.value
                ? SafeArea(
                    child: Container(
                      color: Colors.black, // eta tumar bg color hishebe daw
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: CommonText(
                              text: "Select All",
                              style: GoogleFonts.poppins(
                                color: AppColors.white,
                                fontSize: 14.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          // Vertical Divider
                          Container(
                            width: 1,
                            height: 24, // divider height adjust koro
                            color: AppColors.white.withValues(alpha: 0.5),
                          ),

                          Expanded(
                            child: InkWell(
                              onTap: () {
                                // Get.toNamed(AppRoutes.downloadSesone);
                              },
                              child: CommonText(
                                text: "Delete",
                                style: GoogleFonts.poppins(
                                  color: AppColors.red,
                                  fontSize: 14.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox();
          }),
        );
      },
    );
  }
}

class MovieCardD extends StatefulWidget {
  final String? imagePath;
  final String? title;
  final String? description;
  final String? size;
  final VoidCallback? onTap;
  final bool isMarkShowAll;
  final bool isSelected;

  const MovieCardD({
    super.key,
    this.imagePath,
    this.title,
    this.description,
    this.size,
    this.onTap,
    this.isMarkShowAll = false,
    this.isSelected = false,
  });

  @override
  State<MovieCardD> createState() => _MovieCardDState();
}

class _MovieCardDState extends State<MovieCardD> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: widget.onTap,
        child: Row(
          spacing: 8,
          children: [
            if (widget.isMarkShowAll)
              InkWell(
                onTap: widget.onTap,
                child: widget.isSelected
                    ? Container(
                        width: 18.w,
                        height: 18.h,
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Icon(
                          Icons.done,
                          size: 12,
                          color: AppColors.black,
                        ),
                      )
                    : Container(
                        width: 18.w,
                        height: 18.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.r),
                          border: Border.all(color: AppColors.white),
                        ),
                      ),
              ),
            CommonImage(
              borderRadius: 8.r,
              width: 82.w,
              height: 103.h,
              imageSrc: widget.imagePath ?? AppImages.m1,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 130,
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: widget.title ?? "Reborn True Princess Returns",
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  CommonText(
                    text:
                        widget.description ??
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore ...",
                    maxLines: 3,
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      color: AppColors.white.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Spacer(),
                  CommonText(
                    text: widget.size ?? "26.23 MB",
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      color: AppColors.white.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/////////////////////Model////////////////////////
class DownloadItemModel {
  final String imagePath;
  final String name;
  final String description;
  final String size;

  DownloadItemModel({
    required this.imagePath,
    required this.name,
    required this.description,
    required this.size,
  });
}

List<DownloadItemModel> downloadItems = [
  DownloadItemModel(
    imagePath: AppImages.m1,
    name: "Inception",
    description:
        "Inception is a mind-bending sci-fi thriller that explores the power of dreams and the blurred line between reality and imagination. The story follows Dom Cobb, a skilled thief who steals corporate secrets by entering people's subconscious minds. To regain his lost life and see his children again, he must perform an impossible task: implant an idea instead of stealing one. As the team dives deeper into layered dream worlds, tensions rise and danger intensifies. Each layer becomes more unstable, pushing them to confront personal fears, hidden memories, and emotional battles. Inception challenges viewers to question what is real.",
    size: "29.00 MB",
  ),
  DownloadItemModel(
    imagePath: AppImages.m2,
    name: "Interstellar",
    description:
        "Interstellar is an emotional science-fiction masterpiece where humanity faces extinction due to climate collapse. Former pilot Cooper joins a secret NASA mission through a wormhole in search of a new habitable planet. As he travels to distant galaxies, time dilation and cosmic mysteries test his courage. Meanwhile, his daughter Murph grows up on Earth, believing her father abandoned her. The film explores love, sacrifice, survival, and the connection between time and space. With breathtaking visuals and compelling characters, Interstellar reminds us that love transcends distance, science, and time, driving us to hope even in humanity's darkest moments.",
    size: "32.50 MB",
  ),
  DownloadItemModel(
    imagePath: AppImages.m3,
    name: "The Dark Knight",
    description:
        "The Dark Knight follows Batman as he battles the Joker, a chaotic mastermind who wants to prove that anyone can fall into madness. Gotham City faces pure terror as the Joker disrupts order, manipulating minds and testing morals. Batman, struggling with ethical boundaries, must balance being a hero and staying human. Harvey Dent, Gotham’s shining hope, faces tragedy and turns into Two-Face, questioning fate and justice. The film dives deep into chaos, sacrifice, hope, and corruption. It is not just a superhero movie, but a psychological drama about the price of saving a broken world.",
    size: "28.40 MB",
  ),
  DownloadItemModel(
    imagePath: AppImages.m4,
    name: "Avatar",
    description:
        "Avatar takes viewers to Pandora, a breathtaking alien world rich with life, spirituality, and beauty. Former Marine Jake Sully joins a mission to learn about the Na’vi people, but soon questions humanity’s greed and destructive actions. He forms a bond with Neytiri and embraces their culture, discovering harmony with nature. As conflict grows, Jake becomes a warrior to protect Pandora from exploitation. Avatar explores themes of loyalty, environmental protection, cultural respect, and identity. With emotional storytelling and stunning visuals, the film inspires us to respect nature and understand that true strength comes from unity and compassion.",
    size: "35.10 MB",
  ),
  DownloadItemModel(
    imagePath: AppImages.m5,
    name: "Avengers: Endgame",
    description:
        "Avengers: Endgame follows Earth’s mightiest heroes after Thanos wipes out half the universe. Devastated and broken, the surviving Avengers attempt to rebuild their lives until a chance appears to reverse the tragedy. They reunite, time-travel, and face past battles, discovering the meaning of sacrifice, friendship, and destiny. Tony Stark finds redemption and chooses ultimate sacrifice, proving that heroes are not defined by power but by heart. The film delivers emotional closure, heroic risks, and unforgettable teamwork. Endgame celebrates courage, love, loss, and the belief that hope can rise even from the greatest defeat.",
    size: "40.25 MB",
  ),
  DownloadItemModel(
    imagePath: AppImages.m6,
    name: "Joker",
    description:
        "Joker tells the haunting story of Arthur Fleck, a man struggling with mental illness, poverty, and loneliness in a harsh society. Constantly mistreated and ignored, he slowly loses his grasp on reality, transforming into the Joker. The film highlights how lack of empathy, social injustice, and emotional neglect can push vulnerable individuals toward chaos. Arthur seeks validation, meaning, and a sense of identity but finds only cruelty and rejection. Joker forces viewers to question society’s responsibility in shaping broken minds and challenges the thin line between victim and villain in a world lacking compassion.",
    size: "24.70 MB",
  ),
  DownloadItemModel(
    imagePath: AppImages.m7,
    name: "Spider-Man: No Way Home",
    description:
        "Spider-Man: No Way Home begins with Peter Parker’s identity being exposed, throwing his life into chaos. Desperate for normalcy, he seeks Doctor Strange’s help, but a spell goes wrong, opening the multiverse and bringing villains from other worlds. Peter faces moral dilemmas, emotional pain, and tough decisions as he tries to save everyone. The arrival of previous Spider-Man heroes creates unforgettable unity, heart, and nostalgia. The film blends action, humor, sacrifice, and growth, showing that true heroism means choosing responsibility over desire. Peter matures into a wiser, stronger Spider-Man shaped by loss and love.",
    size: "33.00 MB",
  ),
  DownloadItemModel(
    imagePath: AppImages.m8,
    name: "Black Panther",
    description:
        "Black Panther follows T’Challa as he becomes king of Wakanda, a secret advanced nation built on tradition, strength, and technological brilliance. His rule is challenged by Killmonger, who seeks power through anger and pain caused by injustice. The story explores leadership, heritage, identity, and the responsibility of power. T’Challa learns that progress requires compassion, unity, and sharing knowledge to uplift others. The film celebrates African culture, pride, and hope, showing that true greatness comes from protecting people and honoring legacy. It inspires strength, dignity, and the belief that a nation thrives when people stand together.",
    size: "27.80 MB",
  ),
  DownloadItemModel(
    imagePath: AppImages.m9,
    name: "Frozen II",
    description:
        "Frozen II follows Elsa and Anna on a magical journey to uncover the origin of Elsa’s powers and the truth about their family’s past. When a mysterious voice calls Elsa, she must face unknown lands, ancient spirits, and emotional challenges. The sisters confront hidden secrets, reveal truth, and embrace destiny. Anna learns leadership and resilience, while Elsa discovers her true identity and purpose. The film beautifully explores self-discovery, loyalty, courage, and love. With enchanting music and heartfelt moments, Frozen II teaches that growth requires facing fears and trusting the voice inside your heart.",
    size: "22.90 MB",
  ),
  DownloadItemModel(
    imagePath: AppImages.m10,
    name: "Fast & Furious 9",
    description:
        "Fast & Furious 9 continues the high-octane action as Dom Toretto confronts a shocking enemy — his long-lost brother Jakob. With worldwide missions, daring stunts, and emotional family moments, the crew reunites to protect the world from a dangerous threat. Dom faces complicated past memories, understanding that family bonds can break but also heal. The film blends loyalty, forgiveness, adrenaline, and teamwork. Every character contributes to the mission, proving that strength is built from trust and unity. Fast & Furious 9 celebrates resilience, brotherhood, and the unstoppable power of family against all odds.",
    size: "30.00 MB",
  ),
];
