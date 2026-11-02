'use client';

import React, { useState, useEffect } from 'react';

export default function LandingPage() {
  const [salary, setSalary] = useState(45000);
  
  // Bangladesh Bank Official Reference Indicators
  const [bbRate, setBbRate] = useState({
    weightedAverageLendingRate: 11.83,
    policyRepoRate: 9.50,
    sourceUrl: 'https://www.bb.org.bd/en/index.php/financialactivity/interestrate',
    policyRatesUrl: 'https://www.bb.org.bd/en/index.php/monetaryactivity/policyrates',
    lastUpdated: '২০২৬ বাংলাদেশ ব্যাংক লাইভ রেফারেন্স',
  });

  useEffect(() => {
    fetch('/api/v1/economic-indicators/rates')
      .then((res) => res.json())
      .then((data) => {
        if (data.success && data.data) {
          setBbRate(data.data);
        }
      })
      .catch(() => {
        // Fallback to official BB rate already initialized
      });
  }, []);

  // Core calculations synced with Bangladesh Bank weighted average lending rate
  const shielded = Math.round(salary * 0.40); // 40% locked into tangible asset circulation
  // Benchmark consumer loan / credit exposure of 2 months' income
  const loanExposure = salary * 2; 
  // Annual interest bleed to commercial banks at BB official lending rate
  const annualInterestBleed = Math.round(loanExposure * (bbRate.weightedAverageLendingRate / 100));
  const monthlyInterestBleed = Math.round(annualInterestBleed / 12);
  const debtDefense = Math.round(shielded * 0.30);

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
          <a href="#idea" className="flex items-center gap-2.5">
            <div className="w-9 h-9 rounded-2xl bg-gradient-to-tr from-emerald-600 to-teal-500 text-white flex items-center justify-center font-black text-xl shadow-md shadow-emerald-500/20">
              ◎
            </div>
            <div>
              <span className="text-xl font-black tracking-tight text-slate-900 leading-none block">FairCircle</span>
              <span className="text-[10px] text-emerald-700 font-bold tracking-wider uppercase">ফেয়ার-সার্কেল</span>
            </div>
          </a>

          <nav className="hidden md:flex items-center gap-7 text-xs font-semibold text-slate-600">
            <a href="#idea" className="hover:text-emerald-700 transition">আমাদের দর্শন</a>
            <a href="#how-it-works" className="hover:text-emerald-700 transition">পিরামিড বনাম সার্কেল</a>
            <a href="#pillars" className="hover:text-emerald-700 transition">মূল স্তম্ভসমূহ</a>
            <a href="#calculator" className="hover:text-emerald-700 transition">আর্থিক ক্যালকুলেটর</a>
          </nav>

          <div className="flex items-center gap-2">
            <a href="#download" className="inline-flex items-center gap-1.5 px-4 py-2 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs transition shadow-md shadow-emerald-600/20">
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" /></svg>
              <span>অ্যাপ ডাউনলোড</span>
            </a>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <section id="idea" className="relative pt-12 md:pt-20 pb-16 md:pb-24 overflow-hidden bg-gradient-to-b from-slate-50 via-white to-white">
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
            <a href="#download" className="w-full sm:w-auto px-6 py-3.5 rounded-xl bg-slate-900 hover:bg-slate-800 text-white font-bold text-sm transition shadow-lg shadow-slate-900/20 flex items-center justify-center gap-2">
              <svg className="w-5 h-5 text-emerald-400" fill="currentColor" viewBox="0 0 24 24"><path d="M17.523 15.3414c-.5511 0-.9993-.4486-.9993-.9997s.4482-.9993.9993-.9993c.551 0 .9993.4482.9993.9993 0 .5511-.4483.9997-.9993.9997m-11.046 0c-.5511 0-.9993-.4486-.9993-.9997s.4482-.9993.9993-.9993c.5511 0 .9993.4482.9993.9993 0 .5511-.4482.9997-.9993.9997m11.4045-6.02l1.9973-3.4592a.416.416 0 00-.1523-.5676.416.416 0 00-.5676.1523l-2.0223 3.503C15.5902 7.2796 13.8533 6.9118 12 6.9118s-3.5902.3678-5.1366 1.0381L4.8411 4.4469a.416.416 0 00-.5676-.1523.416.416 0 00-.1523.5676l1.9973 3.4592C2.6889 10.2867.3333 13.7915.3333 17.8333h23.3334c0-4.0418-2.3556-7.5466-5.7867-9.5119"/></svg>
              <span>Android App ডাউনলোড (APK)</span>
            </a>
            <a href="#how-it-works" className="w-full sm:w-auto px-6 py-3.5 rounded-xl border-2 border-slate-200 hover:border-slate-300 bg-white text-slate-800 font-bold text-sm transition">
              কীভাবে কাজ করে দেখুন →
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

      {/* How it Works / Pyramid vs Circle Section */}
      <section id="how-it-works" className="py-16 md:py-24 bg-slate-50 border-y border-slate-200/80">
        <div className="max-w-5xl mx-auto px-4">
          <div className="text-center max-w-2xl mx-auto mb-12">
            <span className="text-xs font-bold uppercase tracking-wider text-slate-500 bg-slate-200/80 px-3 py-1 rounded-full">
              সহজ অর্থনীতির চরম সত্য
            </span>
            <h2 className="text-2xl sm:text-3xl md:text-4xl font-black text-slate-900 tracking-tight mt-3 mb-3">
              টাকা কেন মানুষের গলায় ফাঁসের মতো কাজ করে?
            </h2>
            <p className="text-xs sm:text-sm text-slate-600 leading-relaxed">
              কোনো জটিলতা ছাড়াই দেখুন কীভাবে প্রচলিত ব্যাংক ব্যবস্থা মানুষকে স্থায়ী ঋণের পিরামিডে আটকে ফেলে এবং ফেয়ার-সার্কেল কীভাবে মানুষকে মুক্তি দেয়।
            </p>
          </div>

          {/* Side-by-Side Comparison */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            
            {/* Pyramid Trap Side */}
            <div className="bg-white border-2 border-red-200/80 rounded-2xl p-6 shadow-xs flex flex-col justify-between">
              <div>
                <div className="flex items-center justify-between mb-4">
                  <span className="text-xs font-bold text-red-800 bg-red-100 px-2.5 py-0.5 rounded-md">প্রচলিত শোষণব্যবস্থা</span>
                  <span className="text-xs font-bold text-red-700">সুদের পিরামিড ট্র্যাপ</span>
                </div>

                <div className="py-4 flex flex-col items-center justify-center">
                  <div className="w-32 bg-red-600 text-white text-[11px] font-bold py-2 rounded-t-lg text-center shadow-xs">
                    সেন্ট্রাল ব্যাংক
                    <div className="text-[9px] font-normal opacity-90">ছাপে মাত্র ৳১,০০০</div>
                  </div>
                  <div className="w-0.5 h-2 bg-red-300"></div>
                  <div className="w-48 bg-red-500 text-white text-[11px] font-bold py-2 text-center shadow-xs">
                    বাণিজ্যিক ঋণদাতা ব্যাংক
                    <div className="text-[9px] font-normal opacity-90">দাবি করে ৳১,১০০ (১০% সুদ)</div>
                  </div>
                  <div className="w-0.5 h-2 bg-red-300"></div>
                  <div className="w-64 bg-red-800 text-white text-[11px] font-bold py-2.5 rounded-b-lg text-center shadow-xs">
                    মেহনতী মানুষ ও পরিবার
                    <div className="text-[9px] font-medium text-red-200">দেনা: ৳১,১০০ | বাজারে আছে মাত্র ৳১,০০০!</div>
                  </div>
                </div>

                <div className="bg-red-50/50 border border-red-200 rounded-xl p-3.5 text-xs text-slate-700 space-y-1.5 mt-3">
                  <strong className="text-red-900 block font-bold text-xs">⚠️ গাণিতিক বাস্তবতা:</strong>
                  <p>১. ব্যাংক মোট তৈরি করেছে <strong>৳১,০০০</strong>।</p>
                  <p>২. সুদসহ ফেরত চায় <strong>৳১,১০০</strong>।</p>
                  <p>৩. অতিরিক্ত <strong>৳১০০</strong> আসল বাজারে নেই; <em>তা ছাপাই হয়নি!</em></p>
                  <p className="text-red-700 font-semibold pt-1 border-t border-red-200 text-[11px]">
                    ফলে সমাজে কাউকে না কাউকে অবশ্যই দেউলিয়া হতে হবে, জমি বিক্রি করতে হবে বা ঋণ শোধ করতে আবার নতুন সুদের ফাঁদে পড়তে হবে।
                  </p>
                </div>
              </div>
            </div>

            {/* FairCircle Solution Side */}
            <div className="bg-white border-2 border-emerald-300 rounded-2xl p-6 shadow-xs flex flex-col justify-between">
              <div>
                <div className="flex items-center justify-between mb-4">
                  <span className="text-xs font-bold text-emerald-800 bg-emerald-100 px-2.5 py-0.5 rounded-md">ন্যায্য সমাধান</span>
                  <span className="text-xs font-bold text-emerald-800">সুদমুক্ত জীবন্ত বৃত্ত (FairCircle)</span>
                </div>

                <div className="py-4 flex items-center justify-center">
                  <div className="w-44 h-44 rounded-full border-2 border-dashed border-emerald-500/70 flex items-center justify-center relative p-2">
                    <div className="w-20 h-20 rounded-full bg-gradient-to-tr from-emerald-600 to-teal-500 text-white flex flex-col items-center justify-center text-center p-1 shadow-sm">
                      <span className="font-black text-xs">আসল সম্পদ</span>
                      <span className="text-[9px] text-emerald-100 font-bold">০% সুদ</span>
                    </div>

                    <div className="absolute -top-3 bg-white border border-emerald-600 text-slate-800 font-bold text-[10px] px-2 py-0.5 rounded-full shadow-xs">
                      🌾 উৎপাদক
                    </div>
                    <div className="absolute -bottom-3 right-1 bg-white border border-emerald-600 text-slate-800 font-bold text-[10px] px-2 py-0.5 rounded-full shadow-xs">
                      🤝 করজে হাসানা
                    </div>
                    <div className="absolute -bottom-3 left-1 bg-white border border-emerald-600 text-slate-800 font-bold text-[10px] px-2 py-0.5 rounded-full shadow-xs">
                      👤 ভোক্তা
                    </div>
                  </div>
                </div>

                <div className="bg-emerald-50/50 border border-emerald-200 rounded-xl p-3.5 text-xs text-slate-700 space-y-1.5 mt-3">
                  <strong className="text-emerald-900 block font-bold text-xs">✅ ফেয়ার-সার্কেল কীভাবে মুক্তি আনে:</strong>
                  <p>১. <strong>৳১.০০ মান = ৳১.০০ আসল পণ্য</strong> (চাল, তেল, পোশাক, চিকিৎসা সেবা)।</p>
                  <p>২. <strong>শূন্য সুদ:</strong> বিপদে ৳১০,০০০ ধার নিলে হুবহু ৳১০,০০০-ই পরিশোধ করবেন।</p>
                  <p>৩. <strong>সম্পদ বণ্টন:</strong> অলস অর্থ ১ বছর পড়ে থাকলে ২.৫% স্থানীয় আপৎকালীন ফান্ডে বণ্টন হয়।</p>
                  <p className="text-emerald-800 font-semibold pt-1 border-t border-emerald-200 text-[11px]">
                    কোনো জমি বা সহায় সম্বল নিলাম হবে না। সমাজে টাকা অবিরাম ঘুরবে এবং মানুষ মর্যাদার সাথে বাঁচবে।
                  </p>
                </div>
              </div>
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
                জরুরি চিকিৎসার বিলে ০% সুদে ঋণ (করজে হাসানা) এবং কৃষি যন্ত্রপাতি ফ্রি শেয়ারিং।
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

      {/* Interactive Calculator Section (With Live Bangladesh Bank Sync) */}
      <section id="calculator" className="py-16 md:py-24 bg-slate-900 text-white">
        <div className="max-w-4xl mx-auto px-4 text-center">
          
          {/* Bangladesh Bank Live Benchmark Badge */}
          <div className="inline-flex items-center gap-2 bg-slate-800 border border-emerald-500/30 text-emerald-300 text-xs px-3.5 py-1.5 rounded-full mb-4 shadow-sm">
            <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
            <span>বাংলাদেশ ব্যাংক ব্যাংক-রেফারেন্স ঋণ সুদহার: <strong>{bbRate.weightedAverageLendingRate}%</strong> (পলিসি রেপো: {bbRate.policyRepoRate}%)</span>
            <a
              href={bbRate.sourceUrl}
              target="_blank"
              rel="noopener noreferrer"
              className="text-emerald-400 hover:text-emerald-300 underline font-bold ml-1 inline-flex items-center gap-0.5"
            >
              যাচাই করুন ↗
            </a>
          </div>

          <h2 className="text-2xl sm:text-3xl font-black text-white mb-2">
            আপনার আর্থিক স্বাস্থ্য পরীক্ষা করুন
          </h2>
          <p className="text-xs text-slate-400 mb-8 max-w-xl mx-auto">
            আপনার মাসিক আয়ের স্লাইডার টেনে দেখুন প্রচলিত ব্যাংক ব্যবস্থার সুদে আপনার কত টাকা গচ্চা যায় এবং ফেয়ার-সার্কেলে কত টাকা সুরক্ষিত থাকে।
          </p>

          <div className="bg-slate-800 border border-slate-700 p-6 md:p-8 rounded-3xl max-w-2xl mx-auto space-y-6 text-left">
            <div>
              <div className="flex justify-between items-center text-xs mb-2">
                <span className="text-slate-300 font-semibold">আপনার মাসিক বেতন বা আয়:</span>
                <span className="font-mono text-emerald-400 font-bold text-base">৳{salary.toLocaleString('en-IN')}</span>
              </div>
              <input
                type="range"
                min="15000"
                max="250000"
                step="2500"
                value={salary}
                onChange={(e) => setSalary(Number(e.target.value))}
                className="w-full h-2.5 bg-slate-700 rounded-lg appearance-none cursor-pointer accent-emerald-500"
              />
              <div className="flex justify-between text-[10px] text-slate-400 mt-1">
                <span>৳১৫,০০০</span>
                <span>৳১,০০,০০০</span>
                <span>৳২,৫০,০০০+</span>
              </div>
            </div>

            {/* Calculations Grid */}
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 text-center">
              
              {/* Shielded */}
              <div className="bg-slate-900/90 p-4 rounded-2xl border border-emerald-500/20">
                <span className="text-[10px] text-emerald-400 font-semibold block mb-1">আসল সম্পদে সুরক্ষিত (৪০%)</span>
                <span className="font-mono font-black text-white text-lg block">৳{shielded.toLocaleString('en-IN')}</span>
                <span className="text-[9px] text-slate-400">খাদ্য ও নিত্যপণ্যে সংরক্ষিত</span>
              </div>

              {/* Annual Loss in Commercial Usury */}
              <div className="bg-slate-900/90 p-4 rounded-2xl border border-red-500/30">
                <span className="text-[10px] text-red-400 font-semibold block mb-1">ব্যাংক সুদে বার্ষিক ক্ষতি ({bbRate.weightedAverageLendingRate}%)</span>
                <span className="font-mono font-black text-red-400 text-lg block">৳{annualInterestBleed.toLocaleString('en-IN')}</span>
                <span className="text-[9px] text-slate-400">গড়ে মাসিক ক্ষতি: ৳{monthlyInterestBleed.toLocaleString('en-IN')}</span>
              </div>

              {/* FairCircle Savings */}
              <div className="bg-emerald-950/60 p-4 rounded-2xl border border-emerald-400/40">
                <span className="text-[10px] text-emerald-300 font-semibold block mb-1">ফেয়ার-সার্কেলে সাশ্রয়</span>
                <span className="font-mono font-black text-emerald-400 text-lg block">৳{annualInterestBleed.toLocaleString('en-IN')}</span>
                <span className="text-[9px] text-emerald-200">০.০০% সুদে সম্পূর্ণ মুক্ত</span>
              </div>

            </div>

            {/* Verification and Proof Box */}
            <div className="bg-slate-900/70 border border-slate-700/80 rounded-xl p-3.5 text-xs text-slate-300 space-y-1.5">
              <div className="flex items-center justify-between text-[11px] font-bold text-slate-200">
                <span>🏛️ তথ্যের সত্যতা ও সূত্র (Bangladesh Bank Verified):</span>
                <span className="text-emerald-400">সরকারি সূত্র</span>
              </div>
              <p className="text-[11px] text-slate-400 leading-relaxed">
                বাংলাদেশ ব্যাংকের অফিসিয়াল <em>"Scheduled Banks' Weighted Average Lending Rate"</em> অনুযায়ী দেশের বাণিজ্যিক ব্যাংকগুলোর গড় ঋণ সুদহার বর্তমানে <strong>{bbRate.weightedAverageLendingRate}%</strong> এবং পলিসি রেপো রেট <strong>{bbRate.policyRepoRate}%</strong>।
              </p>
              <div className="pt-1 flex flex-wrap items-center gap-3 text-[11px]">
                <a
                  href={bbRate.sourceUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-emerald-400 hover:text-emerald-300 underline font-medium"
                >
                  🔗 তফসিলি ব্যাংকের গড় সুদহার টেবিল (bb.org.bd)
                </a>
                <span className="text-slate-600">•</span>
                <a
                  href={bbRate.policyRatesUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-emerald-400 hover:text-emerald-300 underline font-medium"
                >
                  🔗 নীতিগত সুদহার (Policy Repo Rates)
                </a>
              </div>
            </div>

          </div>
        </div>
      </section>

      {/* Download Section */}
      <section id="download" className="py-16 md:py-24 bg-white">
        <div className="max-w-4xl mx-auto px-4 text-center">
          <div className="bg-gradient-to-tr from-emerald-600 via-teal-600 to-slate-900 text-white rounded-3xl p-8 md:p-12 shadow-xl relative overflow-hidden">
            <div className="max-w-2xl mx-auto relative z-10">
              <span className="text-xs uppercase tracking-wider font-bold bg-white/20 px-3 py-1 rounded-full text-emerald-100">
                আজই যুক্ত হোন
              </span>
              <h2 className="text-2xl sm:text-4xl font-black mt-4 mb-3 tracking-tight">
                আসুন একসাথে সুদমুক্ত অর্থনীতি গড়ি
              </h2>
              <p className="text-xs sm:text-sm text-emerald-100 leading-relaxed mb-8">
                FairCircle কোনো বাণিজ্যিক মুনাফাখোর প্রতিষ্ঠান নয়; এটি গণমানুষের ন্যায্যতার একটি স্বাধীন উন্মুক্ত প্ল্যাটফর্ম। এখনই অ্যান্ড্রয়েড অ্যাপ অথবা ওয়েব ভার্সন ব্যবহার করুন।
              </p>

              <div className="flex flex-col sm:flex-row items-center justify-center gap-3">
                <a
                  href="https://github.com/Sany655/fair-circle/actions"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="w-full sm:w-auto px-6 py-3.5 rounded-xl bg-white text-slate-900 font-black text-sm hover:bg-slate-100 transition shadow-md flex items-center justify-center gap-2"
                >
                  <svg className="w-5 h-5 text-emerald-600" fill="currentColor" viewBox="0 0 24 24"><path d="M17.523 15.3414c-.5511 0-.9993-.4486-.9993-.9997s.4482-.9993.9993-.9993c.551 0 .9993.4482.9993.9993 0 .5511-.4483.9997-.9993.9997m-11.046 0c-.5511 0-.9993-.4486-.9993-.9997s.4482-.9993.9993-.9993c.5511 0 .9993.4482.9993.9993 0 .5511-.4482.9997-.9993.9997m11.4045-6.02l1.9973-3.4592a.416.416 0 00-.1523-.5676.416.416 0 00-.5676.1523l-2.0223 3.503C15.5902 7.2796 13.8533 6.9118 12 6.9118s-3.5902.3678-5.1366 1.0381L4.8411 4.4469a.416.416 0 00-.5676-.1523.416.416 0 00-.1523.5676l1.9973 3.4592C2.6889 10.2867.3333 13.7915.3333 17.8333h23.3334c0-4.0418-2.3556-7.5466-5.7867-9.5119"/></svg>
                  <span>Android Release APK ডাউনলোড</span>
                </a>
                <a
                  href="#calculator"
                  className="w-full sm:w-auto px-6 py-3.5 rounded-xl bg-emerald-950/80 hover:bg-emerald-950 text-white font-bold text-sm transition border border-white/20"
                >
                  ক্যালকুলেটর পরীক্ষা করুন
                </a>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-slate-50 border-t border-slate-200/80 py-8 text-xs text-slate-500 text-center">
        <div className="max-w-6xl mx-auto px-4 flex flex-col md:flex-row items-center justify-between gap-4">
          <div className="flex items-center gap-2">
            <div className="w-6 h-6 rounded-lg bg-emerald-600 text-white flex items-center justify-center font-bold text-xs">
              ◎
            </div>
            <span className="font-bold text-slate-800">FairCircle (ফেয়ার-সার্কেল)</span>
          </div>

          <div className="flex items-center gap-6">
            <a href="#idea" className="hover:text-slate-800 transition">আমাদের দর্শন</a>
            <a href="#how-it-works" className="hover:text-slate-800 transition">পিরামিড বনাম সার্কেল</a>
            <a href="#pillars" className="hover:text-slate-800 transition">মূল স্তম্ভ</a>
            <a href="#calculator" className="hover:text-slate-800 transition">হিসাব</a>
            <a href="#download" className="hover:text-slate-800 transition">ডাউনলোড</a>
          </div>

          <p>© 2026 FairCircle — সুদমুক্ত গণমানুষের অর্থনীতি</p>
        </div>
      </footer>
    </div>
  );
}
