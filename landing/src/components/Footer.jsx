import React from 'react'

const Footer = () => {
  return (
    <footer className="bg-gray-900">
      {/* Main Footer Content */}
      <div className="max-w-7xl mx-auto px-8 py-16">
        <div className="grid grid-cols-1 lg:grid-cols-4 gap-12">
          {/* Brand Section */}
          <div className="lg:col-span-1">
            {/* Logo */}
            <div className="flex items-center gap-3 mb-4 cursor-pointer" onClick={() => window.scrollTo({ top: 0, behavior: 'smooth' })}>
              <div className="w-10 h-10 rounded-full bg-gradient-to-r from-brand-green to-brand-yellow flex items-center justify-center">
                <span className="text-white font-bold text-xl">A</span>
              </div>
              <span className="text-white font-semibold text-xl">Anchor AI</span>
            </div>

            {/* Tagline */}
            <p className="text-gray-400 font-poppins mb-6 max-w-xs">
              Your journey to mental wellness starts here. Privacy-first mental health support.
            </p>

            {/* Privacy Badge */}
            <div className="inline-flex items-center gap-2">
              <svg className="w-4 h-4 text-brand-green" fill="none" stroke="currentColor" viewBox="0 0 20 20" strokeWidth={1.5}>
                <path strokeLinecap="round" strokeLinejoin="round" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
              </svg>
              <span className="text-brand-green font-poppins text-sm font-light">Privacy First</span>
            </div>
          </div>

          {/* Product Column */}
          <div>
            <h3 className="text-white font-poppins font-semibold text-lg mb-6">Product</h3>
            <ul className="space-y-4">
              <li><a href="#" className="text-gray-400 hover:text-white transition-colors font-poppins">Features</a></li>
              <li><a href="#" className="text-gray-400 hover:text-white transition-colors font-poppins">Pricing</a></li>
              <li><a href="#" className="text-gray-400 hover:text-white transition-colors font-poppins">Security</a></li>
              <li><a href="#" className="text-gray-400 hover:text-white transition-colors font-poppins">For Therapists</a></li>
            </ul>
          </div>

          {/* Company Column */}
          <div>
            <h3 className="text-white font-poppins font-semibold text-lg mb-6">Company</h3>
            <ul className="space-y-4">
              <li><a href="#" className="text-gray-400 hover:text-white transition-colors font-poppins">About Us</a></li>
              <li><a href="#" className="text-gray-400 hover:text-white transition-colors font-poppins">Careers</a></li>
              <li><a href="#" className="text-gray-400 hover:text-white transition-colors font-poppins">Blog</a></li>
              <li><a href="#" className="text-gray-400 hover:text-white transition-colors font-poppins">Contact</a></li>
            </ul>
          </div>

          {/* Legal Column */}
          <div>
            <h3 className="text-white font-poppins font-semibold text-lg mb-6">Legal</h3>
            <ul className="space-y-4">
              <li><a href="#" className="text-gray-400 hover:text-white transition-colors font-poppins">Privacy Policy</a></li>
              <li><a href="#" className="text-gray-400 hover:text-white transition-colors font-poppins">Terms of Service</a></li>
              <li><a href="#" className="text-gray-400 hover:text-white transition-colors font-poppins">HIPAA Compliance</a></li>
              <li><a href="#" className="text-gray-400 hover:text-white transition-colors font-poppins">Cookie Policy</a></li>
            </ul>
          </div>
        </div>
      </div>

      {/* Bottom Bar */}
      <div className="border-t border-gray-800">
        <div className="max-w-7xl mx-auto px-8 py-6">
          <div className="flex flex-col md:flex-row justify-between items-center gap-4">
            {/* Copyright */}
            <p className="text-gray-400 font-poppins text-sm">
              © 2026 Anchor AI. All rights reserved.
            </p>

            {/* Social Icons */}
            <div className="flex items-center gap-6">
              {/* GitHub */}
              <a href="#" className="text-gray-400 hover:text-white transition-colors">
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" strokeWidth={1.5}>
                  <path strokeLinecap="round" strokeLinejoin="round" d="M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 0 0-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0 0 20 4.77 5.07 5.07 0 0 0 19.91 1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 0 0 5 4.77a5.44 5.44 0 0 0-1.5 3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 0 0 9 18.13V22"/>
                </svg>
              </a>

              {/* LinkedIn */}
              <a href="#" className="text-gray-400 hover:text-white transition-colors">
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" strokeWidth={1.5}>
                  <path strokeLinecap="round" strokeLinejoin="round" d="M16 8a6 6 0 016 6v7h-4v-7a2 2 0 00-2-2 2 2 0 00-2 2v7h-4v-7a6 6 0 016-6zM2 9h4v12H2z"/>
                  <circle cx="4" cy="4" r="2" stroke="currentColor" fill="none"/>
                </svg>
              </a>
            </div>
          </div>
        </div>
      </div>
    </footer>
  )
}

export default Footer