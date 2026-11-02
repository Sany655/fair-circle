import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'অর্থনৈতিক দর্শন',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            Text(
              'পিরামিড মডেল বনাম ফেয়ার-সার্কেল মডেল',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildComparisonCard(
            title: '১. সুদের শোষণ বনাম সম্পদভিত্তিক লেনদেন',
            pyramidText: 'সুদি ব্যবস্থায় অর্থ থেকে অর্থ তৈরি হয় কোনো উৎপাদন ছাড়াই। ঋণের ফাঁদে সাধারণ মানুষ ও উৎপাদক নিঃস্ব হয়।',
            circleText: 'ফেয়ার-সার্কেলে অর্থ কেবল বাস্তব পণ্য বা সেবার বিনিময়ে হাতবদল হয়। শূন্য শতাংশ (০%) সুদ ও সরাসরি এস্ক্রো নিরাপত্তা।',
          ),
          const SizedBox(height: 14),
          _buildComparisonCard(
            title: '২. মুনাফাবাজি ও মজুদ বনাম বাধ্যতামূলক প্রবাহ',
            pyramidText: 'সম্পদ গুটি কয়েক ধনীর সিন্দুকে পুঞ্জীভূত থাকে। কৃত্রিম সঙ্কট তৈরি করে দাম বাড়িয়ে অতিরিক্ত মুনাফা নেওয়া হয়।',
            circleText: 'উদ্বৃত্ত ও অলস অলংকার/অর্থের উপর বাৎসরিক ২.৫% সঞ্চালন শুল্ক। অর্থ আটকে রাখার বদলে উৎপাদন ও কর্জে বিনিয়োগ করা লাভজনক।',
          ),
          const SizedBox(height: 14),
          _buildComparisonCard(
            title: '৩. গোপন মূল্য কারসাজি বনাম উন্মুক্ত কস্ট-শীট',
            pyramidText: 'উৎপাদক কত পেল এবং মধ্যস্বত্বভোগী সিন্ডিকেট কত নিল—তা সম্পূর্ণ গোপন। ভোক্তা ঠকে, কৃষক নিঃস্ব হয়।',
            circleText: 'প্রতিটি পণ্যের কাঁচামাল, শ্রম, পরিবহন ও ন্যায্য মুনাফার পূর্ণ বিবরণ উন্মুক্ত। কোনো লুকানো চার্জ বা কালো সিন্ডিকেট নেই।',
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'সার্বজনীন মানবিক অর্থনীতি',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 6),
                Text(
                  'ফেয়ার-সার্কেল কোনো সংকীর্ণ বা বিশেষ গোষ্ঠীর ব্যবস্থা নয়। এটি সুস্থ, শোষণমুক্ত ও সমতাভিত্তিক এক অর্থনৈতিক মডেল—যার ভিত্তি গণমানুষের যৌথ কল্যাণ ও পারস্পরিক সহযোগিতা।',
                  style: TextStyle(fontSize: 12, color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonCard({
    required String title,
    required String pyramidText,
    required String circleText,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFECACA)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('❌ ', style: TextStyle(fontSize: 13)),
                Expanded(
                  child: Text('বর্তমান শোষক ধারা: $pyramidText', style: const TextStyle(fontSize: 11, color: Color(0xFF991B1B), height: 1.3)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('✅ ', style: TextStyle(fontSize: 13)),
                Expanded(
                  child: Text('ফেয়ার-সার্কেল ধারা: $circleText', style: const TextStyle(fontSize: 11, color: Color(0xFF166534), height: 1.3, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
