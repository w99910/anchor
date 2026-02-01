import React, { useState, useEffect, useRef } from 'react'

const Features = () => {
  const [expandedCards, setExpandedCards] = useState({
    card1: false,
    card2: false,
    card3: false,
    card4: false
  })
  const card1Ref = useRef(null)
  const card2Ref = useRef(null)
  const card3Ref = useRef(null)
  const card4Ref = useRef(null)

  useEffect(() => {
    let ticking = false
    
    const handleScroll = () => {
      if (!ticking) {
        requestAnimationFrame(() => {
          const viewportHeight = window.innerHeight
          const triggerPointDown = viewportHeight * (2/3) // Trigger when top of card reaches 2/3 of viewport

          // Check each card individually
          const cards = [
            { ref: card1Ref, key: 'card1' },
            { ref: card2Ref, key: 'card2' },
            { ref: card3Ref, key: 'card3' },
            { ref: card4Ref, key: 'card4' }
          ]

          setExpandedCards(prevState => {
            const newExpandedState = { ...prevState }
            
            cards.forEach(({ ref, key }) => {
              if (ref.current) {
                const rect = ref.current.getBoundingClientRect()
                const cardHeight = rect.height
                const twoThirdsOfCard = cardHeight * (2/3)
                
                // Debug console logging
                if (key === 'card1') {
                  console.log(`Card1 - Top: ${rect.top}, Bottom: ${rect.bottom}, TriggerDown: ${triggerPointDown}, CardHeight: ${cardHeight}, TwoThirdsVisible: ${rect.bottom - twoThirdsOfCard}`)
                }
                
                // Expand: when top of card reaches 2/3 of viewport height
                // Shrink: when 2/3 of the card cannot be seen (when bottom of card minus 2/3 height is above viewport)
                if (rect.top <= triggerPointDown && rect.bottom >= twoThirdsOfCard) {
                  // Card should be expanded
                  if (!prevState[key]) {
                    newExpandedState[key] = true
                    console.log(`${key} expanded!`)
                  }
                } else {
                  // Card should be shrunk
                  if (prevState[key]) {
                    newExpandedState[key] = false
                    console.log(`${key} shrunk!`)
                  }
                }
              }
            })
            
            return newExpandedState
          })
          
          ticking = false
        })
        ticking = true
      }
    }

    window.addEventListener('scroll', handleScroll)
    handleScroll() // Check initial state
    
    return () => window.removeEventListener('scroll', handleScroll)
  }, [])

  return (
    <div id="features" className="bg-white py-20 px-8">
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

        {/* Feature Cards Container */}
        <div className="space-y-20">
          {/* Feature Card 1 - Talk Freely, Anytime. */}
          <div ref={card1Ref} className={`relative bg-gray-50 hover:bg-gray-100 transition-all duration-300 ease-in-out rounded-3xl p-12 md:p-16 text-center overflow-hidden min-h-[500px] flex flex-col items-center justify-center ${
            expandedCards.card1 ? 'scale-100 opacity-100' : 'scale-75 opacity-75'
          }`}>
            {/* Background space for gif/animation */}
            <div className="absolute inset-0 -z-10">
              {/* Gif/animation will be added here as background */}
            </div>
            
            {/* Content */}
            <div className="relative z-10 max-w-2xl mx-auto mt-32">
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
          <div ref={card2Ref} className={`relative bg-gray-50 hover:bg-gray-100 transition-all duration-300 ease-in-out rounded-3xl p-12 md:p-16 text-center overflow-hidden min-h-[500px] flex flex-col items-center justify-center ${
            expandedCards.card2 ? 'scale-100 opacity-100' : 'scale-75 opacity-75'
          }`}>
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
          <div ref={card3Ref} className={`relative bg-gray-50 hover:bg-gray-100 transition-all duration-300 ease-in-out rounded-3xl p-12 md:p-16 text-center overflow-hidden min-h-[500px] flex flex-col items-center justify-center ${
            expandedCards.card3 ? 'scale-100 opacity-100' : 'scale-75 opacity-75'
          }`}>
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
          <div ref={card4Ref} className={`relative bg-gray-50 hover:bg-gray-100 transition-all duration-300 ease-in-out rounded-3xl p-12 md:p-16 text-center overflow-hidden min-h-[500px] flex flex-col items-center justify-center ${
            expandedCards.card4 ? 'scale-100 opacity-100' : 'scale-75 opacity-75'
          }`}>
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
        </div>

        {/* Additional Features - Blog Style Layout */}
        <div className="mt-16">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {/* Card 1 - Local AI Processing */}
            <div className="bg-white border border-gray-200 rounded-2xl overflow-hidden shadow-lg hover:shadow-2xl hover:-translate-y-2 transition-all duration-300 ease-out cursor-default group flex flex-col items-center justify-center p-6 pb-8">
              {/* Circular Icon */}
              <div className="w-16 h-16 rounded-full bg-gradient-to-br from-brand-green to-brand-yellow flex items-center justify-center mb-4">
                <svg className="w-8 h-8 text-white" fill="none" stroke="currentColor" strokeWidth="1.5" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                </svg>
              </div>
              {/* Content Section */}
              <div className="flex flex-col justify-center items-center text-center">
                <h4 className="font-fraunces text-xl font-black text-gray-900 mb-3">
                  Local AI Processing
                </h4>
                <p className="font-poppins text-gray-600 text-sm leading-relaxed">
                  Your conversations never leave your device. Our AI runs locally for maximum privacy and zero latency.
                </p>
              </div>
            </div>

            {/* Card 2 - Emotional Trends */}
            <div className="bg-white border border-gray-200 rounded-2xl overflow-hidden shadow-lg hover:shadow-2xl hover:-translate-y-2 transition-all duration-300 ease-out cursor-default group flex flex-col items-center justify-center p-6 pb-8">
              {/* Circular Icon */}
              <div className="w-16 h-16 rounded-full bg-gradient-to-br from-purple-500 to-pink-500 flex items-center justify-center mb-4">
                <svg className="w-8 h-8 text-white" fill="none" stroke="currentColor" strokeWidth="1.5" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" />
                </svg>
              </div>
              {/* Content Section */}
              <div className="flex flex-col justify-center items-center text-center">
                <h4 className="font-fraunces text-xl font-black text-gray-900 mb-3">
                  Emotional Trends
                </h4>
                <p className="font-poppins text-gray-600 text-sm leading-relaxed">
                  Visualize your emotional journey with detailed insights over days, weeks, months, or quarters.
                </p>
              </div>
            </div>

            {/* Card 3 - Flexible Payment Options */}
            <div className="bg-white border border-gray-200 rounded-2xl overflow-hidden shadow-lg hover:shadow-2xl hover:-translate-y-2 transition-all duration-300 ease-out cursor-default group flex flex-col items-center justify-center p-6 pb-8">
              {/* Circular Icon */}
              <div className="w-16 h-16 rounded-full bg-gradient-to-br from-blue-500 to-cyan-500 flex items-center justify-center mb-4">
                <svg className="w-8 h-8 text-white" fill="none" stroke="currentColor" strokeWidth="1.5" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" d="M2.25 8.25h19.5M2.25 9h19.5m-16.5 5.25h6m-6 2.25h3m-3.75 3h15a2.25 2.25 0 002.25-2.25V6.75A2.25 2.25 0 0019.5 4.5h-15a2.25 2.25 0 00-2.25 2.25v10.5A2.25 2.25 0 004.5 19.5z" />
                </svg>
              </div>
              {/* Content Section */}
              <div className="flex flex-col justify-center items-center text-center">
                <h4 className="font-fraunces text-xl font-black text-gray-900 mb-3">
                  Flexible Payment Options
                </h4>
                <p className="font-poppins text-gray-600 text-sm leading-relaxed">
                  Simple, secure, and straightforward payment methods for professional sessions.
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default Features
