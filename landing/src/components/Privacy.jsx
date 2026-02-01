import React, { useState } from 'react'

const Privacy = () => {
  const [currentSlide, setCurrentSlide] = useState(3) // Default to "Zero-Knowledge Architecture" (now at index 2, so slide 3)
  
  const privacyFeatures = [
    {
      title: "Military-Grade Encryption",
      description: "All your data is protected with AES-256 encryption, the same standard used by banks and governments.",
      icon: (
        <svg className="w-7 h-7 text-white" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
        </svg>
      )
    },
    {
      title: "Zero-Knowledge Architecture",
      description: "We cannot access your data even if we wanted to. Your information is encrypted before it leaves your device.",
      icon: (
        <svg className="w-7 h-7 text-white" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
        </svg>
      )
    },
    {
      title: "No Data Selling",
      description: "We will never sell, rent, or share your personal information with third parties. Your privacy is not for sale.",
      icon: (
        <svg className="w-7 h-7 text-white" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
        </svg>
      )
    },
    {
      title: "HIPAA Compliant",
      description: "Our platform meets all healthcare privacy standards to ensure your mental health data stays confidential.",
      icon: (
        <svg className="w-7 h-7 text-white" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
        </svg>
      )
    }
  ]

  // Create array with blank spaces for centering
  const allSlides = [
    null, // Blank space
    ...privacyFeatures,
    null, // Blank space
    null  // Additional blank space for HIPAA centering
  ]

  const nextSlide = () => {
    if (currentSlide < allSlides.length - 2) { // Account for 2 blank spaces at end, but allow reaching HIPAA
      setCurrentSlide((prev) => prev + 1)
    }
  }

  const prevSlide = () => {
    if (currentSlide > 2) { // Account for blank space at beginning
      setCurrentSlide((prev) => prev - 1)
    }
  }

  const canGoNext = currentSlide < allSlides.length - 2
  const canGoPrev = currentSlide > 2
  return (
    <div id="privacy" className="bg-gray-900 py-20 px-8">
      <div className="max-w-7xl mx-auto">
        {/* Privacy First Badge */}
        <div className="flex justify-center mb-8">
          <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full border border-gray-700 bg-gray-800">
            <svg className="w-4 h-4 text-brand-green" fill="currentColor" viewBox="0 0 20 20">
              <path fillRule="evenodd" d="M2.166 4.999A11.954 11.954 0 0010 1.944 11.954 11.954 0 0017.834 5c.11.65.166 1.32.166 2.001 0 5.225-3.34 9.67-8 11.317C5.34 16.67 2 12.225 2 7c0-.682.057-1.35.166-2.001zm11.541 3.708a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
            </svg>
            <span className="text-white font-poppins text-sm font-medium">Privacy First</span>
          </div>
        </div>

        {/* Section Title */}
        <div className="text-center mb-16">
          <h2 className="font-fraunces text-4xl md:text-5xl lg:text-6xl font-black leading-tight mb-6">
            <span className="text-white">Your privacy is our </span>
            <span className="bg-gradient-to-r from-brand-green to-brand-yellow bg-clip-text text-transparent">
              top priority
            </span>
          </h2>
          <p className="font-poppins text-gray-300 text-lg md:text-xl max-w-4xl mx-auto">
            Mental health is deeply personal. We've built our platform from the ground up with privacy and security at its core.
          </p>
        </div>

        {/* Privacy Features Carousel */}
        <div className="relative">
          <div className="max-w-6xl mx-auto relative z-10">
            <div className="overflow-hidden">
              <div 
                className="flex transition-transform duration-500 ease-out"
                style={{ transform: `translateX(-${(currentSlide - 2) * (100/3)}%)` }}
              >
                {allSlides.map((feature, index) => {
                  const isCenter = index === currentSlide - 1
                  
                  return (
                    <div key={index} className="w-1/3 flex-shrink-0 px-8">
                      {feature ? (
                        <div 
                          className={`rounded-3xl p-12 text-center transition-opacity duration-500 ${
                            isCenter ? 'opacity-100' : 'opacity-50'
                          }`}
                        >
                          {/* Icon with special design for active state */}
                          <div className="relative mb-6 mx-auto w-14 h-14 flex items-center justify-center">
                            {isCenter && (
                              <>
                                {/* Outer glow circle */}
                                <div className="absolute inset-0 w-20 h-20 -top-3 -left-3 bg-brand-green/20 rounded-full"></div>
                                {/* Medium circle */}
                                <div className="absolute inset-0 w-16 h-16 -top-1 -left-1 bg-brand-green/30 rounded-full"></div>
                                {/* Decorative dots */}
                                <div className="absolute w-2 h-2 bg-brand-green rounded-full -top-2 left-1/2 transform -translate-x-1/2"></div>
                                <div className="absolute w-1.5 h-1.5 bg-brand-green rounded-full top-1 -right-3"></div>
                                <div className="absolute w-1 h-1 bg-brand-green rounded-full bottom-1 -left-2"></div>
                                <div className="absolute w-1.5 h-1.5 bg-brand-green rounded-full -bottom-2 right-2"></div>
                              </>
                            )}
                            {/* Main icon circle */}
                            <div className="relative w-14 h-14 bg-gradient-to-br from-brand-green to-brand-yellow rounded-full flex items-center justify-center z-10">
                              {feature.icon}
                            </div>
                          </div>
                          <h3 className="font-fraunces text-2xl font-black text-white mb-4">
                            {feature.title}
                          </h3>
                          <p className="font-poppins text-gray-300 leading-relaxed max-w-md mx-auto">
                            {feature.description}
                          </p>
                        </div>
                      ) : (
                        <div className="h-full"></div> // Blank space
                      )}
                    </div>
                  )
                })}
              </div>
            </div>
          </div>

          {/* Navigation Arrows */}
          <div className="flex justify-center gap-4 mt-12">
            <button 
              onClick={prevSlide}
              disabled={!canGoPrev}
              className={`w-12 h-12 border border-white/20 rounded-full flex items-center justify-center transition-colors ${
                canGoPrev 
                  ? 'bg-white/10 hover:bg-white/20 text-white cursor-pointer' 
                  : 'bg-white/5 text-white/30 cursor-not-allowed'
              }`}
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
              </svg>
            </button>
            <button 
              onClick={nextSlide}
              disabled={!canGoNext}
              className={`w-12 h-12 border border-white/20 rounded-full flex items-center justify-center transition-colors ${
                canGoNext 
                  ? 'bg-white/10 hover:bg-white/20 text-white cursor-pointer' 
                  : 'bg-white/5 text-white/30 cursor-not-allowed'
              }`}
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
              </svg>
            </button>
          </div>

          {/* Slide Indicators */}
          <div className="flex justify-center gap-2 mt-6">
            {privacyFeatures.map((_, index) => (
              <button
                key={index}
                onClick={() => setCurrentSlide(index + 2)} // Add 2 to account for blank space at beginning
                className={`w-2 h-2 rounded-full transition-colors ${
                  index + 2 === currentSlide ? 'bg-brand-green' : 'bg-white/30'
                }`}
              />
            ))}
          </div>
        </div>
      </div>
    </div>
  )
}

export default Privacy
