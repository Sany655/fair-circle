import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class InvestScreen extends StatelessWidget {
  const InvestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final campaigns = [
      {
        'title': 'সরিষা আবাদ ও কোল্ড-প্রেস তেল উৎপাদন ২০২৬',
        'producer': 'মানিকগঞ্জ কৃষক সমবায় (৩৫ জন কৃষক)',
        'target': '৳ ১,৫০,০০০',
        'raised': '৳ ৯৭,৫০০',
        'percent': 0.65,
        'duration': '৯০ দিন বাকি',
        'share': 'উৎপাদিত খাঁটি তেলের ন্যায্য অংশীদারিত্ব',
        'tag': 'কৃষি ও খাদ্য',
      },
      {
        'title': 'টাঙ্গাইল তাঁত সমবায় আধুনিক তাঁত স্পিন্ডল',
        'producer': 'বাজিকর তাঁতি পল্লি, টাঙ্গাইল',
        'target': '৳ ৩,০০,০০০',
        'raised': '৳ ২,৪০,০০০',
        'percent': 0.80,
        'duration': '৪৫ দিন বাকি',
        'share': 'উৎপাদিত প্রিমিয়াম সুতির জামদানি/শাড়িতে ১০% ছাড় ও লভ্যাংশ',
        'tag': 'হস্তশিল্প ও বস্ত্র',
      },
      {
        'title': 'সুন্দরবন খাঁটি মধু মৌয়াল যৌথ উদ্যোগ',
        'producer': 'শ্যামনগর মৌয়াল ইউনিয়ন, সাতক্ষীরা',
        'target': '৳ ৮০,০০০',
        'raised': '৳ ৮০,০০০',
        'percent': 1.0,
        'duration': 'সম্পূর্ণ ফান্ডেড',
        'share': 'মৌসুমের প্রথম সংগৃহীত পদ্মমধু বন্টন',
        'tag': 'প্রাকৃতিক খাদ্য',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'বিনিয়োগ ও প্রি-অর্ডার',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            Text(
              'সুদমুক্ত উৎপাদন অংশীদারিত্ব ও আগাম ক্রয়',
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
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: const Row(
              children: [
                Icon(Icons.verified_user_outlined, color: AppColors.primary, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'কোনো কৃত্রিম সুদ বা বন্ড নয়। সরাসরি উৎপাদনমুখী উদ্যোগে অর্থায়ন করুন এবং উৎপাদিত পণ্যের প্রকৃত মালিকানা পান।',
                    style: TextStyle(fontSize: 12, color: AppColors.primary, height: 1.35, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...campaigns.map((c) => _buildCampaignCard(context, c)),
        ],
      ),
    );
  }

  Widget _buildCampaignCard(BuildContext context, Map<String, dynamic> c) {
    final double percent = c['percent'] as double;
    final bool isCompleted = percent >= 1.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  c['tag'] as String,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                ),
              ),
              Text(
                c['duration'] as String,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isCompleted ? AppColors.primary : const Color(0xFFEA580C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            c['title'] as String,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            c['producer'] as String,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 6,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(
                isCompleted ? AppColors.primary : const Color(0xFF10B981),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'সংগৃহীত: ${c['raised']}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              Text(
                'লক্ষ্য: ${c['target']}',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.handshake_outlined, size: 16, color: Color(0xFF64748B)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    c['share'] as String,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('অংশীদারিত্ব নিশ্চিত করতে এস্ক্রো লকিং প্রস্তুত করা হচ্ছে...')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isCompleted ? const Color(0xFF94A3B8) : AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 11),
                elevation: 0,
              ),
              child: Text(
                isCompleted ? 'লক্ষ্যমাত্রা অর্জিত' : 'অংশীদার হোন (প্রি-অর্ডার)',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
