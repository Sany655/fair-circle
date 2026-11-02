'use client';

import React, { useState } from 'react';
import Link from 'next/link';

export default function LandingPage() {
  const [salary, setSalary] = useState(45000);
  const shielded = Math.round(salary * 0.4);
  const debtDefense = Math.round(shielded * 0.3);

  return (
    <div className="min-h-screen bg-white">
      {/* Top Banner */}
      <aside className="bg-slate-900 text-white text-xs py-2 px-4 border-b border-slate-800 text-center">
        <div className="max-w-6xl mx-auto flex items-center justify-center gap-2">
          <span className="inline-block w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
          <span className="font-medium text-slate-300">একটি বৈপ্লবিক সুদমুক্ত অর্থনৈতিক আন্দোলনের সূচনা</span>
          <span className="text-slate-500">•</span>
          <a href="#how-it-works" className="text-emerald-400 hover:text-emerald-300 font-bold underline transition">
            গণিতটি দেখুন →
          </a>
        </div>
      </aside>

      {/* Header */}
      <header className="bg-white/95 backdrop-blur-md border-b border-slate-100 sticky top-0 z-50">
        <div className="max-w-6xl mx-auto px-4 py-3.5 flex items-center justify-between gap-4">
          <div className="flex items-center gap-2.5">
            <div className="w-9 h-9 rounded-2xl bg-gradient-to-tr from-emerald-600 to-teal-500 text-white flex items-center justify-center font-black text-xl shadow-md shadow-emerald-500/20">
              ◎
            </div>
            <div>
              <span className="text-xl font-black tracking-tight text-slate-900 leading-none block">FairCircle</span>
              <span className="text-[10px] text-emerald-700 font-bold tracking-wider uppercase">ফেয়ার-সার্কেল</span>
            </div>
          </div>

          <nav className="hidden md:flex items-center gap-7 text-xs font-semibold text-slate-600">
            <a href="#how-it-works" className="hover:text-emerald-700 transition">পিরামিড বনাম সার্কেল</a>
            <a href="#pillars" className="hover:text-emerald-700 transition">মূল স্তম্ভসমূহ</a>
            <a href="#calculator" className="hover:text-emerald-700 transition">আর্থিক ক্যালকুলেটর</a>
          </nav>

          <div className="flex items-center gap-2">
            <a href="#download" className="inline-flex items-center gap-1.5 px-4 py-2 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs transition shadow-md shadow-emerald-600/20">
              অ্যাপ ডাউনলোড
            </a>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <section className="relative pt-12 md:pt-20 pb-16 md:pb-24 overflow-hidden bg-gradient-to-b from-slate-50 via-white to-white">
        <div className="max-w-4xl mx-auto px-4 text-center">
          <div className="inline-flex items-center gap-2 bg-emerald-50 border border-emerald-200/80 text-emerald-800 text-xs font-bold px-3.5 py-1.5 rounded-full mb-6 shadow-xs">
            <span className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
            <span>টাকা মানুষের সেবার জন্য, মানুষের গোলামির জন্য নয়</span>
          </div>

          <h1 className="text-3xl sm:text-5xl md:text-6xl font-black text-slate-900 tracking-tight leading-[1.15] mb-6">
            ব্যাংক ও সুদের শোষণমুক্ত <br className="hidden sm:inline" />
            <span className="text-transparent bg-clip-text bg-gradient-to-r from-emerald-600 via-teal-600 to-emerald-700">
              গণমানুষের আসল অর্থনীতি
            </span>
          </h1>

          <p className="text-base sm:text-lg text-slate-600 font-normal leading-relaxed max-w-2xl mx-auto mb-8">
            যেকোনো ধর্মের বা মতাদর্শের মানুষ যখন সত্য দেখবেন, তখন ন্যায়ের এই ব্যবস্থাকে বেছে নেবেন। সম্পূর্ণ সুদমুক্ত কেনাকাটা, কৃষকের ফসলে অগ্রিম প্রি-অর্ডার এবং মহল্লার সুদমুক্ত আপৎকালীন ফান্ড।
          </p>

          <div className="flex flex-col sm:flex-row items-center justify-center gap-3 mb-10">
            <a href="#download" className="w-full sm:w-auto px-6 py-3.5 rounded-xl bg-slate-900 hover:bg-slate-800 text-white font-bold text-sm transition shadow-lg shadow-slate-900/20">
              Android App ডাউনলোড (APK)
            </a>
            <a href="#pillars" className="w-full sm:w-auto px-6 py-3.5 rounded-xl border-2 border-slate-200 hover:border-slate-300 bg-white text-slate-800 font-bold text-sm transition">
              প্ল্যাটফর্মের সেবাগুলো দেখুন →
            </a>
          </div>

          {/* Badges */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-3 max-w-3xl mx-auto text-left">
            <div className="bg-white border border-slate-200/80 p-3.5 rounded-xl shadow-xs">
              <div className="text-xs text-slate-400 font-semibold">সুদের হার</div>
              <div className="text-base font-black text-emerald-700">০.০০% চিরকাল</div>
            </div>
            <div className="bg-white border border-slate-200/80 p-3.5 rounded-xl shadow-xs">
              <div className="text-xs text-slate-400 font-semibold">সম্পদের মান</div>
              <div className="text-base font-black text-slate-900">১০০% আসল পণ্য</div>
            </div>
            <div className="bg-white border border-slate-200/80 p-3.5 rounded-xl shadow-xs">
              <div className="text-xs text-slate-400 font-semibold">সুরক্ষা নিয়ম</div>
              <div className="text-base font-black text-slate-900">৪৮ ঘণ্টা এসক্রো</div>
            </div>
            <div className="bg-white border border-slate-200/80 p-3.5 rounded-xl shadow-xs">
              <div className="text-xs text-slate-400 font-semibold">সম্পদ পুঞ্জীভূত রোধ</div>
              <div className="text-base font-black text-slate-900">২.৫% স্থানীয় বণ্টন</div>
            </div>
          </div>
        </div>
      </section>

      {/* 4 Pillars Section */}
      <section id="pillars" className="py-16 md:py-24 bg-white">
        <div className="max-w-6xl mx-auto px-4">
          <div className="text-center max-w-2xl mx-auto mb-14">
            <span className="text-xs font-bold uppercase tracking-wider text-emerald-800 bg-emerald-50 px-3 py-1 rounded-full border border-emerald-200">
              প্ল্যাটফর্মের ৪টি মূল ভিত্তি
            </span>
            <h2 className="text-2xl sm:text-3xl md:text-4xl font-black text-slate-900 tracking-tight mt-3 mb-2">
              একটি স্বয়ংসম্পূর্ণ প্যারালাল ইকোনমি
            </h2>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <div className="bg-slate-50 border border-slate-200 rounded-2xl p-5">
              <div className="w-10 h-10 rounded-xl bg-emerald-100 text-emerald-700 flex items-center justify-center font-bold text-lg mb-4">
                🛒
              </div>
              <h3 className="font-bold text-slate-900 text-base mb-1.5">সরাসরি উৎপাদক হাট</h3>
              <p className="text-xs text-slate-600 leading-relaxed mb-3">
                কাঁচামাল ও মজুরির হিসাব উন্মুক্ত। মধ্যস্বত্বভোগী সিন্ডিকেট সম্পূর্ণ শূন্য।
              </p>
              <span className="text-[11px] font-bold text-emerald-700 bg-emerald-100/60 px-2 py-0.5 rounded">৪৮ ঘণ্টা এসক্রো</span>
            </div>

            <div className="bg-slate-50 border border-slate-200 rounded-2xl p-5">
              <div className="w-10 h-10 rounded-xl bg-purple-100 text-purple-700 flex items-center justify-center font-bold text-lg mb-4">
                🌱
              </div>
              <h3 className="font-bold text-slate-900 text-base mb-1.5">ফসলে অগ্রিম বিনিয়োগ</h3>
              <p className="text-xs text-slate-600 leading-relaxed mb-3">
                কৃষক সুদে ঋণ নেন না। আবাদ শুরুর আগেই প্রি-অর্ডার করে কৃষককে সুদমুক্ত মূলধন দিন।
              </p>
              <span className="text-[11px] font-bold text-purple-700 bg-purple-100/60 px-2 py-0.5 rounded">Salam Model</span>
            </div>

            <div className="bg-slate-50 border border-slate-200 rounded-2xl p-5">
              <div className="w-10 h-10 rounded-xl bg-blue-100 text-blue-700 flex items-center justify-center font-bold text-lg mb-4">
                🤝
              </div>
              <h3 className="font-bold text-slate-900 text-base mb-1.5">০% সুদমুক্ত ধার ও শেয়ার</h3>
              <p className="text-xs text-slate-600 leading-relaxed mb-3">
                হাসপাতালের জরুরি বিলে ০% সুদে ঋণ (করজে হাসানা) এবং ভারী যন্ত্রপাতি ফ্রি শেয়ারিং।
              </p>
              <span className="text-[11px] font-bold text-blue-700 bg-blue-100/60 px-2 py-0.5 rounded">০.০০% সুদ</span>
            </div>

            <div className="bg-slate-50 border border-slate-200 rounded-2xl p-5">
              <div className="w-10 h-10 rounded-xl bg-amber-100 text-amber-700 flex items-center justify-center font-bold text-lg mb-4">
                📊
              </div>
              <h3 className="font-bold text-slate-900 text-base mb-1.5">আর্থিক স্বাস্থ্য ও সুরক্ষা</h3>
              <p className="text-xs text-slate-600 leading-relaxed mb-3">
                চাকরিজীবীদের বেতনের টাকাকে সুদের আক্রমণ থেকে রক্ষা ও ২.৫% স্থানীয় অভাবী বণ্টন।
              </p>
              <span className="text-[11px] font-bold text-amber-700 bg-amber-100/60 px-2 py-0.5 rounded">মুহাসাবা অডিট</span>
            </div>
          </div>
        </div>
      </section>

      {/* Interactive Calculator Section */}
      <section id="calculator" className="py-16 md:py-24 bg-slate-900 text-white">
        <div className="max-w-4xl mx-auto px-4 text-center">
          <h2 className="text-2xl sm:text-3xl font-black text-white mb-2">
            আপনার আর্থিক স্বাস্থ্য পরীক্ষা করুন
          </h2>
          <p className="text-xs text-slate-400 mb-8">
            আপনার মাসিক আয়ের স্লাইডার টেনে দেখুন আপনার পরিবার কতটুকু সুদমুক্ত ও সুরক্ষিত।
          </p>

          <div className="bg-slate-800 border border-slate-700 p-6 rounded-3xl max-w-xl mx-auto space-y-5">
            <div>
              <div className="flex justify-between items-center text-xs mb-2">
                <span className="text-slate-300 font-semibold">মাসিক বেতন বা আয়:</span>
                <span className="font-mono text-emerald-400 font-bold text-sm">৳{salary.toLocaleString('en-IN')}</span>
              </div>
              <input
                type="range"
                min="15000"
                max="150000"
                step="2500"
                value={salary}
                onChange={(e) => setSalary(Number(e.target.value))}
                className="w-full h-2 bg-slate-700 rounded-lg appearance-none cursor-pointer accent-emerald-500"
              />
            </div>

            <div className="grid grid-cols-2 gap-3 text-center">
              <div className="bg-slate-900/80 p-3 rounded-xl border border-slate-700">
                <span className="text-[10px] text-slate-400 block mb-1">আসল সম্পদে সুরক্ষিত</span>
                <span className="font-mono font-bold text-emerald-400 text-sm">৳{shielded.toLocaleString('en-IN')}</span>
              </div>
              <div className="bg-slate-900/80 p-3 rounded-xl border border-slate-700">
                <span className="text-[10px] text-slate-400 block mb-1">সুদের ঋণ ধ্বংস বাজেট</span>
                <span className="font-mono font-bold text-red-400 text-sm">৳{debtDefense.toLocaleString('en-IN')}</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-slate-50 border-t border-slate-200/80 py-8 text-xs text-slate-500 text-center">
        <div className="max-w-6xl mx-auto px-4">
          <p>© 2026 FairCircle (ফেয়ার-সার্কেল) — সুদমুক্ত গণমানুষের অর্থনীতি • ১০০% উন্মুক্ত ও স্বাধীন</p>
        </div>
      </footer>
    </div>
  );
}
