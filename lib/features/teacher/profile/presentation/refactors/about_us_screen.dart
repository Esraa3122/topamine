import 'package:flutter/material.dart';
import 'package:test/core/common/widgets/custom_app_bar.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/images/app_images.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutBack),
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildSectionCard({
    required String title,
    required String content,
    required BuildContext context,
  }) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [context.color.mainColor!, Colors.grey.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(
              color: Colors.blueAccent.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextApp(
                text: title,
                theme: context.textStyle.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 12),
              TextApp(
                text: content,
                theme: context.textStyle.copyWith(
                  fontSize: 16,
                  color: context.color.textColor,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValueCard({
    required IconData icon,
    required String title,
    required BuildContext context,
  }) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey.shade50,
                context.color.mainColor!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Colors.blueAccent.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 8),
              TextApp(
                text: title,
                theme: context.textStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: context.color.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'About Us',
        color: context.color.textColor!,
        backgroundColor: context.color.mainColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          // color: context.color.mainColor,
          gradient: LinearGradient(
            colors: [context.color.mainColor!, Colors.blue.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header Image
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage(AppImages.home1),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Center(
                        child: TextApp(
                          text: 'توبامين',
                          theme: context.textStyle.copyWith(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Our Idea Section
                _buildSectionCard(
                  context: context,
                  title: 'فكرتنا',
                  content:
                      'منصتنا هي منصة تعليمية مبتكرة تهدف إلى تمكين الطلاب من خلال توفير محتوى تعليمي عالي الجودة. نسعى لجعل التعليم ممتعًا ومتاحًا للجميع، مع التركيز على تجربة تعلم تفاعلية ومخصصة.',
                ),

                // What We Do Section
                _buildSectionCard(
                  context: context,
                  title: 'ماذا نقدم؟',
                  content:
                      'نقدم مجموعة واسعة من الكورسات والمحاضرات التي تغطي مختلف المجالات الأكاديمية والمهنية، مع واجهة سهلة الاستخدام ودعم مستمر للطلاب. منصتنا تتيح لك متابعة تقدمك، تقييم المحتوى، والتفاعل مع مجتمع المتعلمين.',
                ),

                // Our Vision Section
                _buildSectionCard(
                  context: context,
                  title: 'رؤيتنا',
                  content:
                      'نسعى لأن نكون المنصة الرائدة في التعليم الرقمي في العالم العربي، من خلال تقديم تجربة تعليمية شاملة تدعم الابتكار وتلهم الأجيال القادمة.',
                ),

                // Our Values Section
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextApp(
                          text: 'قيمنا الأساسية',
                          theme: context.textStyle.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: context.color.textColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1,
                          children: [
                            _buildValueCard(
                              context: context,
                              icon: Icons.support_agent,
                              title: 'الدعم المستمر',
                            ),
                            _buildValueCard(
                              context: context,
                              icon: Icons.star,
                              title: 'التميز',
                            ),
                            _buildValueCard(
                              context: context,
                              icon: Icons.verified,
                              title: 'الثقة',
                            ),
                            _buildValueCard(
                              context: context,
                              icon: Icons.autorenew,
                              title: 'المرونة',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
