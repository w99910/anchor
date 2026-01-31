import React from 'react'

const Features = () => {
  return (
    <div className="bg-white py-20 px-8">
      <div className="max-w-7xl mx-auto">
        {/* Section Title */}
        <div className="text-center mb-16">
          <h2 className="font-fraunces text-4xl md:text-5xl lg:text-6xl font-black leading-tight mb-6">
            <span className="text-gray-900">Everything you need for </span>
            <span className="bg-gradient-to-r from-brand-green to-brand-yellow bg-clip-text text-transparent">
              mental wellness
            </span>
          </h2>
          <p className="font-poppins text-gray-600 text-lg md:text-xl max-w-4xl mx-auto">
            Comprehensive tools designed to support your mental health journey, all in one place.
          </p>
        </div>

        {/* Feature Card 1 - Talk Freely, Anytime. */}
        <div className="relative bg-gray-50 hover:bg-gray-100 transition-colors rounded-3xl p-12 md:p-16 text-center overflow-hidden min-h-[500px] flex flex-col items-center justify-center">
          {/* Background space for gif/animation */}
          <div className="absolute inset-0 -z-10">
            {/* Gif/animation will be added here as background */}
          </div>
          
          {/* Content */}
          <div className="relative z-10 max-w-2xl mx-auto">
            {/* Icon */}
            <div className="w-20 h-20 bg-brand-green rounded-2xl flex items-center justify-center mb-6 shadow-lg shadow-brand-green/30 mx-auto">
              <svg className="w-18 h-18 text-white" fill="none" stroke="currentColor" strokeWidth="1" viewBox="0 0 24 24">
                <rect x="7" y="6" width="10" height="8" rx="1" />
                <line x1="9" y1="4" x2="9" y2="6" />
                <line x1="15" y1="4" x2="15" y2="6" />
                <circle cx="10" cy="10" r="0.5" fill="currentColor" />
                <circle cx="14" cy="10" r="0.5" fill="currentColor" />
                <line x1="10" y1="12" x2="14" y2="12" strokeLinecap="round" />
              </svg>
            </div>

            {/* Title */}
            <h3 className="font-fraunces text-3xl md:text-4xl font-black text-gray-900 mb-4">
              Talk Freely, Anytime.
            </h3>

            {/* Description */}
            <p className="font-poppins text-gray-600 text-lg leading-relaxed mb-6">
              Choose between two modes: a supportive Friend for casual chats or a Therapist mode for guided emotional support. Our local AI model ensures zero latency and total privacy.
            </p>

            {/* Learn More Link */}
            <a href="#" className="inline-flex items-center gap-2 text-brand-green font-poppins font-semibold text-lg hover:gap-3 transition-all">
              Learn more
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 8l4 4m0 0l-4 4m4-4H3" />
              </svg>
            </a>
          </div>
        </div>

        {/* Feature Card 2 - Journaling */}
        <div className="relative bg-gray-50 hover:bg-gray-100 transition-colors rounded-3xl p-12 md:p-16 text-center overflow-hidden min-h-[500px] flex flex-col items-center justify-center mt-8">
          {/* Background space for gif/animation */}
          <div className="absolute inset-0 -z-10">
            {/* Gif/animation will be added here as background */}
          </div>
          
          {/* Content */}
          <div className="relative z-10 max-w-2xl mx-auto">
            {/* Icon */}
            <div className="w-20 h-20 bg-brand-yellow rounded-2xl flex items-center justify-center mb-6 shadow-lg shadow-brand-yellow/30 mx-auto">
              <svg className="w-12 h-12 text-white" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
              </svg>
            </div>

            {/* Title */}
            <h3 className="font-fraunces text-3xl md:text-4xl font-black text-gray-900 mb-4">
              Journaling with Insight.
            </h3>

            {/* Description */}
            <p className="font-poppins text-gray-600 text-lg leading-relaxed mb-6">
              Write your thoughts and let our AI summarize your day and track your emotional trends over the last week, month, or quarter. Reflect and edit your entries for up to 3 days before they are securely locked.
            </p>

            {/* Learn More Link */}
            <a href="#" className="inline-flex items-center gap-2 text-brand-green font-poppins font-semibold text-lg hover:gap-3 transition-all">
              Learn more
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 8l4 4m0 0l-4 4m4-4H3" />
              </svg>
            </a>
          </div>
        </div>

        {/* Feature Card 3 - Evaluation */}
        <div className="relative bg-gray-50 hover:bg-gray-100 transition-colors rounded-3xl p-12 md:p-16 text-center overflow-hidden min-h-[500px] flex flex-col items-center justify-center mt-8">
          {/* Background space for gif/animation */}
          <div className="absolute inset-0 -z-10">
            {/* Gif/animation will be added here as background */}
          </div>
          
          {/* Content */}
          <div className="relative z-10 max-w-2xl mx-auto">
            {/* Icon */}
            <div className="w-20 h-20 bg-brand-green rounded-2xl flex items-center justify-center mb-6 shadow-lg shadow-brand-green/30 mx-auto">
              <svg className="w-12 h-12 text-white" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z" />
              </svg>
            </div>

            {/* Title */}
            <h3 className="font-fraunces text-3xl md:text-4xl font-black text-gray-900 mb-4">
              Understand Yourself Better.
            </h3>

            {/* Description */}
            <p className="font-poppins text-gray-600 text-lg leading-relaxed mb-6">
              Take quick, stress-free evaluations to visualize your mental state. Choose the questions that matter to you.
            </p>

            {/* Learn More Link */}
            <a href="#" className="inline-flex items-center gap-2 text-brand-green font-poppins font-semibold text-lg hover:gap-3 transition-all">
              Learn more
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 8l4 4m0 0l-4 4m4-4H3" />
              </svg>
            </a>
          </div>
        </div>

        {/* Feature Card 4 - Professional Help */}
        <div className="relative bg-gray-50 hover:bg-gray-100 transition-colors rounded-3xl p-12 md:p-16 text-center overflow-hidden min-h-[500px] flex flex-col items-center justify-center mt-8">
          {/* Background space for gif/animation */}
          <div className="absolute inset-0 -z-10">
            {/* Gif/animation will be added here as background */}
          </div>
          
          {/* Content */}
          <div className="relative z-10 max-w-2xl mx-auto">
            {/* Icon */}
            <div className="w-20 h-20 bg-brand-yellow rounded-2xl flex items-center justify-center mb-6 shadow-lg shadow-brand-yellow/30 mx-auto">
              <svg className="w-12 h-12 text-white" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
              </svg>
            </div>

            {/* Title */}
            <h3 className="font-fraunces text-3xl md:text-4xl font-black text-gray-900 mb-4">
              Human Help When You Need It.
            </h3>

            {/* Description */}
            <p className="font-poppins text-gray-600 text-lg leading-relaxed mb-6">
              Need more support? Connect directly with licensed therapists and consultants within the app. Book sessions, rate your experience, and handle payments securely.
            </p>

            {/* Learn More Link */}
            <a href="#" className="inline-flex items-center gap-2 text-brand-green font-poppins font-semibold text-lg hover:gap-3 transition-all">
              Learn more
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 8l4 4m0 0l-4 4m4-4H3" />
              </svg>
            </a>
          </div>
        </div>

        {/* Additional Features - Horizontal Scroll */}
        <div className="mt-16 overflow-x-auto scrollbar-hide">
          <div className="flex gap-6 pb-4 min-w-max">
            {/* Card 1 - Local AI Processing */}
            <div className="bg-white rounded-3xl p-8 shadow-sm hover:shadow-md transition-shadow w-[350px] flex-shrink-0">
              <div className="w-14 h-14 bg-white rounded-2xl flex items-center justify-center mb-6 shadow-sm border border-gray-100">
                <svg className="w-7 h-7 text-brand-green" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                </svg>
              </div>
              <h4 className="font-fraunces text-2xl font-black text-gray-900 mb-3">
                Local AI Processing
              </h4>
              <p className="font-poppins text-gray-600 leading-relaxed">
                Your conversations never leave your device. Our AI runs locally for maximum privacy and zero latency.
              </p>
            </div>

            {/* Card 2 - Emotional Trends */}
            <div className="bg-white rounded-3xl p-8 shadow-sm hover:shadow-md transition-shadow w-[350px] flex-shrink-0">
              <div className="w-14 h-14 bg-white rounded-2xl flex items-center justify-center mb-6 shadow-sm border border-gray-100">
                <svg className="w-7 h-7 text-brand-green" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" />
                </svg>
              </div>
              <h4 className="font-fraunces text-2xl font-black text-gray-900 mb-3">
                Emotional Trends
              </h4>
              <p className="font-poppins text-gray-600 leading-relaxed">
                Visualize your emotional journey with detailed insights over days, weeks, months, or quarters.
              </p>
            </div>

            {/* Card 3 - Flexible Payment Options */}
            <div className="bg-white rounded-3xl p-8 shadow-sm hover:shadow-md transition-shadow w-[350px] flex-shrink-0">
              <div className="w-14 h-14 bg-white rounded-2xl flex items-center justify-center mb-6 shadow-sm border border-gray-100">
                <svg className="w-7 h-7 text-brand-green" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z" />
                </svg>
              </div>
              <h4 className="font-fraunces text-2xl font-black text-gray-900 mb-3">
                Flexible Payment Options
              </h4>
              <p className="font-poppins text-gray-600 leading-relaxed">
                Simple, secure, and straightforward payment methods for professional sessions.
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default Features
