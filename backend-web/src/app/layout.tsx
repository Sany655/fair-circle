import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'FairCircle (ফেয়ার-সার্কেল) — সুদমুক্ত গণমানুষের অর্থনীতি',
  description: 'একটি স্বাধীন, সম্পূর্ণ সুদমুক্ত এবং আসল সম্পদভিত্তিক বৃত্তাকার অর্থনৈতিক প্ল্যাটফর্ম।',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="bn" className="scroll-smooth">
      <body className="antialiased text-slate-800 bg-white">{children}</body>
    </html>
  );
}
