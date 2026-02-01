import React from 'react'

const Navigation = () => {
  return (
    <nav className="fixed top-0 left-0 w-full px-8 py-6 bg-white/90 backdrop-blur-md border-b border-gray-100 z-50 opacity-0 animate-fadeIn" style={{animationDelay: '0.1s', animationFillMode: 'forwards'}}>
      <div className="max-w-7xl mx-auto flex items-center justify-between">
        {/* Logo */}
        <div className="flex items-center gap-3 cursor-pointer" onClick={() => window.scrollTo({ top: 0, behavior: 'smooth' })}>
          <div className="w-10 h-10 rounded-full bg-gradient-to-r from-brand-green to-brand-yellow flex items-center justify-center">
            <span className="text-white font-bold text-xl">A</span>
          </div>
          <span className="text-gray-900 font-semibold text-xl">Anchor AI</span>
        </div>

        {/* Navigation Links */}
        <div className="flex items-center gap-8 font-poppins">
          <div className="flex items-center gap-2 text-gray-600 bg-white border border-gray-300 px-4 py-2 rounded-full">
            <svg className="w-4 h-4 text-brand-green" fill="currentColor" viewBox="0 0 20 20">
              <path fillRule="evenodd" d="M2.166 4.999A11.954 11.954 0 0010 1.944 11.954 11.954 0 0017.834 5c.11.65.166 1.32.166 2.001 0 5.225-3.34 9.67-8 11.317C5.34 16.67 2 12.225 2 7c0-.682.057-1.35.166-2.001zm11.541 3.708a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
            </svg>
            Privacy First
          </div>
          <button 
            onClick={() => document.getElementById('features')?.scrollIntoView({ behavior: 'smooth' })}
            className="text-gray-600 hover:text-brand-green active:text-brand-green transition-colors cursor-pointer bg-transparent border-none"
          >
            Features
          </button>
          <button 
            onClick={() => document.getElementById('privacy')?.scrollIntoView({ behavior: 'smooth' })}
            className="text-gray-600 hover:text-brand-green active:text-brand-green transition-colors cursor-pointer bg-transparent border-none"
          >
            Privacy
          </button>
        </div>

        {/* Contact Us Button */}
        <button className="bg-gray-900 hover:bg-gray-800 hover:scale-105 text-white font-poppins font-medium px-6 py-3 rounded-full transition-all duration-300">
          Contact Us
        </button>
      </div>
    </nav>
  )
}

export default Navigation
