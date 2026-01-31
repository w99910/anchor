import React from 'react'

const Ready = () => {
  return (
    <div className="bg-gradient-to-br from-brand-green to-brand-yellow py-20 px-8">
      <div className="max-w-4xl mx-auto text-center">
        {/* Main Heading */}
        <h2 className="font-fraunces text-4xl md:text-5xl lg:text-6xl font-black text-gray-900 mb-6">
          Ready to start your journey?
        </h2>

        {/* Description */}
        <p className="font-poppins text-gray-800 text-lg md:text-xl mb-12 max-w-2xl mx-auto">
          Join thousands of people who are taking control of their mental wellness with Anchor AI.
        </p>

        {/* CTA Buttons */}
        <div className="flex flex-col sm:flex-row items-center justify-center gap-6 mb-12">
          <button className="bg-gray-900 hover:bg-gray-800 text-white font-poppins font-medium px-8 py-4 rounded-full transition-colors text-lg shadow-lg flex items-center gap-2">
            <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
              <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z"/>
            </svg>
            Download on Iphone
          </button>
          <button className="bg-white hover:bg-gray-50 text-gray-900 font-poppins font-medium px-8 py-4 rounded-full transition-colors text-lg shadow-lg border-2 border-gray-900 flex items-center gap-2">
            <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
              <path d="M17.523 15.341c-.676-.698-1.746-.879-2.642-.404l-1.571.834-2.311-2.311 2.311-2.311 1.571.834c.896.475 1.966.294 2.642-.404l2.828-2.828a1 1 0 0 0 0-1.414L15.523 2.51a1 1 0 0 0-1.414 0l-2.828 2.828c-.678.678-.879 1.746-.404 2.642l.834 1.571-2.31 2.31-2.311-2.31.834-1.571c.475-.896.274-1.964-.404-2.642L4.692 2.51a1 1 0 0 0-1.414 0L.45 5.338a1 1 0 0 0 0 1.414l2.828 2.828c.678.678 1.746.879 2.642.404l1.571-.834 2.311 2.311-2.311 2.311-1.571-.834c-.896-.475-1.964-.294-2.642.404L.45 16.17a1 1 0 0 0 0 1.414l2.828 2.828a1 1 0 0 0 1.414 0l2.828-2.828c.678-.678.879-1.746.404-2.642l-.834-1.571 2.311-2.311 2.311 2.311-.834 1.571c-.475.896-.274 1.964.404 2.642l2.828 2.828a1 1 0 0 0 1.414 0l2.828-2.828a1 1 0 0 0 0-1.414l-2.829-2.829z"/>
            </svg>
            Download on Android
          </button>
        </div>

        {/* Feature List */}
        <div className="flex flex-col sm:flex-row items-center justify-center gap-6 text-gray-800">
          <div className="flex items-center gap-2 font-poppins">
            <svg className="w-5 h-5 text-gray-900" fill="currentColor" viewBox="0 0 20 20">
              <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
            </svg>
            <span>Your safety comes first</span>
          </div>
          <div className="flex items-center gap-2 font-poppins">
            <svg className="w-5 h-5 text-gray-900" fill="currentColor" viewBox="0 0 20 20">
              <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
            </svg>
            <span>Track your emotions anytime, anywhere</span>
          </div>
        </div>
      </div>
    </div>
  )
}

export default Ready