import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class MutualAidScreen extends StatelessWidget {
  const MutualAidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'পারস্পরিক সহায়তা ও ধার',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              Text(
                '০% সুদ কর্জে হাসানা ও উন্মুক্ত সরঞ্জাম',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 0.5,
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            tabs: [
              Tab(text: '০% ঋণ (কর্জ তহবীল)'),
              Tab(text: 'সরঞ্জাম শেয়ারিং'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildLoansTab(context),
            _buildToolsTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLoansTab(BuildContext context) {
    final loanPools = [
      {
        'title': 'ছোট কৃষক বীজ ও সার কর্জ পুল',
        'provider': 'যশোর কৃষক কল্যাণ ট্রাস্ট',
        'available': '৳ ৭৫,০০০',
        'apr': '০.০% (সুদমুক্ত)',
        'maxLimit': '৳ ১৫,০০০ জন প্রতি',
        'tenor': 'ফসল কাটার পর (সর্বোচ্চ ১২০ দিন)',
      },
      {
        'title': 'নারী ক্ষুদ্র উদ্যোক্তা সিড ফান্ড',
        'provider': 'স্বাবলম্বী নারী ফোরাম, রংপুর',
        'available': '৳ ১,২০,০০০',
        'apr': '০.০% (সুদমুক্ত)',
        'maxLimit': '৳ ২০,০০০ জন প্রতি',
        'tenor': 'মাসিক সহজ কিস্তি (১৮০ দিন)',
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBBF7D0)),
          ),
          child: const Row(
            children: [
              Icon(Icons.favorite_border, color: AppColors.primary, size: 26),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'কর্জ-ই-হাসানা: কোনো সুদ বা বিলম্ব ফি নেই। সমাজ সঞ্চিত উদ্বৃত্ত তহবিল থেকে প্রয়োজনমাফিক ধার দেওয়া ও সঠিক সময়ে ফেরত পাওয়ার নৈতিক চুক্তি।',
                  style: TextStyle(fontSize: 12, color: AppColors.primary, height: 1.35),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...loanPools.map((pool) => _buildLoanCard(context, pool)),
      ],
    );
  }

  Widget _buildLoanCard(BuildContext context, Map<String, dynamic> pool) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  pool['title'] as String,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  pool['apr'] as String,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(pool['provider'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('উপলব্ধ তহবিল: ${pool['available']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              Text('সীমা: ${pool['maxLimit']}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 6),
          Text('পরিশোধ শর্ত: ${pool['tenor']}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ঋণ আবেদন ফর্ম খোলা হচ্ছে...')),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('আবেদন করুন', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolsTab(BuildContext context) {
    final tools = [
      {
        'title': 'সৌরচালিত কোল্ড-স্টোরেজ স্পেস (১ টন)',
        'location': 'শ্রীপুর, গাজীপুর',
        'cost': '৳ ০ / সামাজিক শেয়ারিং',
        'status': 'ব্যবহারযোগ্য',
      },
      {
        'title': 'পাওয়ার টিলার ও ধান মাড়াই মেশিন',
        'location': 'নলডাঙ্গা, নাটোর',
        'cost': '৳ ০ (শুধু জ্বালানি খরচ)',
        'status': '৩ দিন পর খালি হবে',
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...tools.map((t) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      t['title'] as String,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(t['status'] as String, style: const TextStyle(fontSize: 11)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text('অবস্থান: ${t['location']}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 6),
              Text(t['cost'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
            ],
          ),
        )),
      ],
    );
  }
}
