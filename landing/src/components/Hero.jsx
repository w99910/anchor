import React from 'react'

const Hero = () => {
  return (
    <div className="min-h-screen bg-gradient-to-br from-indigo-50 via-purple-50 to-pink-50">
      <div className="max-w-7xl mx-auto px-8 py-16">
        {/* Now Available Badge */}
        <div className="flex justify-center mb-12 opacity-0 animate-fadeIn" style={{animationDelay: '0.4s', animationFillMode: 'forwards'}}>
          <div className="relative inline-flex items-center gap-2 px-4 py-2 rounded-full border border-brand-green bg-white" style={{borderWidth: '0.4px'}}>
            <span className="relative flex h-3 w-3">
              <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-brand-green opacity-75"></span>
              <span className="relative inline-flex rounded-full h-3 w-3 bg-brand-green"></span>
            </span>
            <span className="text-gray-700 font-poppins text-sm font-medium">Now Available</span>
          </div>
        </div>

        {/* Main Headline */}
        <div className="text-center mb-8">
          <h1 className="font-fraunces text-6xl md:text-7xl lg:text-8xl font-black leading-tight">
            <span className="inline-block overflow-hidden">
              <span className="text-gray-900 inline-block animate-revealWord" style={{animationDelay: '0.7s'}}>Your</span>
            </span>
            {' '}
            <span className="inline-block overflow-hidden">
              <span className="text-gray-900 inline-block animate-revealWord" style={{animationDelay: '0.9s'}}>mind's</span>
            </span>
            {' '}
            <span className="inline-block overflow-hidden">
              <span className="bg-gradient-to-r from-brand-green to-brand-yellow bg-clip-text text-transparent inline-block animate-revealWord" style={{animationDelay: '1.1s'}}>
                safest
              </span>
            </span>
            {' '}
            <span className="inline-block overflow-hidden">
              <span className="bg-gradient-to-r from-brand-green to-brand-yellow bg-clip-text text-transparent inline-block animate-revealWord" style={{animationDelay: '1.3s'}}>
                place
              </span>
            </span>
            <br />
            <span className="inline-block overflow-hidden">
              <span className="text-gray-900 inline-block animate-revealWord" style={{animationDelay: '1.5s'}}>to</span>
            </span>
            {' '}
            <span className="inline-block overflow-hidden">
              <span className="text-gray-900 inline-block animate-revealWord" style={{animationDelay: '1.7s'}}>land</span>
            </span>
          </h1>
        </div>

        {/* Subheading */}
        <div className="text-center mb-12 max-w-4xl mx-auto opacity-0 animate-fadeIn" style={{animationDelay: '1.9s', animationFillMode: 'forwards'}}>
          <p className="font-poppins text-gray-600 text-lg md:text-xl leading-relaxed">
            Total privacy. Total support. Chat, journal, and grow with an AI that listens and professionals who care—backed by rock-solid security to protect what matters most: you.
          </p>
        </div>

        {/* CTA Buttons */}
        <div className="flex flex-col sm:flex-row items-center justify-center gap-4 mb-20 opacity-0 animate-fadeIn" style={{animationDelay: '2.2s', animationFillMode: 'forwards'}}>
          <button className="bg-gray-900 hover:bg-gray-800 text-white font-poppins font-medium px-8 py-4 rounded-full transition-colors text-lg flex items-center gap-2">
            <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
              <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z"/>
            </svg>
            Download on Iphone
          </button>
          <button className="bg-white hover:bg-gray-50 text-gray-900 font-poppins font-medium px-8 py-4 rounded-full transition-colors text-lg border border-gray-200 flex items-center gap-2">
            <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
              <path d="M17.523 15.341c-.676-.698-1.746-.879-2.642-.404l-1.571.834-2.311-2.311 2.311-2.311 1.571.834c.896.475 1.966.294 2.642-.404l2.828-2.828a1 1 0 0 0 0-1.414L15.523 2.51a1 1 0 0 0-1.414 0l-2.828 2.828c-.678.678-.879 1.746-.404 2.642l.834 1.571-2.31 2.31-2.311-2.31.834-1.571c.475-.896.274-1.964-.404-2.642L4.692 2.51a1 1 0 0 0-1.414 0L.45 5.338a1 1 0 0 0 0 1.414l2.828 2.828c.678.678 1.746.879 2.642.404l1.571-.834 2.311 2.311-2.311 2.311-1.571-.834c-.896-.475-1.964-.294-2.642.404L.45 16.17a1 1 0 0 0 0 1.414l2.828 2.828a1 1 0 0 0 1.414 0l2.828-2.828c.678-.678.879-1.746.404-2.642l-.834-1.571 2.311-2.311 2.311 2.311-.834 1.571c-.475.896-.274 1.964.404 2.642l2.828 2.828a1 1 0 0 0 1.414 0l2.828-2.828a1 1 0 0 0 0-1.414l-2.829-2.829z"/>
            </svg>
            Download on Android
          </button>
        </div>

        {/* Stats Section */}
        <div className="flex flex-col md:flex-row items-center justify-center gap-8 md:gap-16 opacity-0 animate-fadeIn" style={{animationDelay: '2.5s', animationFillMode: 'forwards'}}>
          <div className="text-center">
            <div className="font-fraunces text-4xl md:text-5xl font-black text-gray-900 mb-2">50k+</div>
            <div className="font-poppins text-gray-600 text-sm">Active Users</div>
          </div>
          
          <div className="hidden md:block w-px h-16 bg-gray-300"></div>
          
          <div className="text-center">
            <div className="font-fraunces text-4xl md:text-5xl font-black text-gray-900 mb-2">4.9/5</div>
            <div className="font-poppins text-gray-600 text-sm">User Rating</div>
          </div>
          
          <div className="hidden md:block w-px h-16 bg-gray-300"></div>
          
          <div className="text-center">
            <div className="font-fraunces text-4xl md:text-5xl font-black text-gray-900 mb-2">100%</div>
            <div className="font-poppins text-gray-600 text-sm">Privacy Protection</div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default Hero
