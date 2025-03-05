/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  env: {
    PORT: process.env.PORT || 3000,
  },
  // Server configuration
  serverRuntimeConfig: {
    // Will only be available on the server side
    PORT_START: 3000,
    PORT_END: 3010,
  },
  // Enable static optimization
  experimental: {
    optimizeCss: true,
    scrollRestoration: true,
  },
  // Configure image optimization
  images: {
    domains: [],
    deviceSizes: [640, 750, 828, 1080, 1200, 1920, 2048, 3840],
    imageSizes: [16, 32, 48, 64, 96, 128, 256, 384],
  },
  // Production optimizations
  compiler: {
    removeConsole: process.env.NODE_ENV === 'production',
  },
  // Webpack configuration
  webpack: (config, { dev, isServer }) => {
    // Add optimizations here
    if (!dev && !isServer) {
      Object.assign(config.resolve.alias, {
        'react/jsx-runtime.js': 'preact/compat/jsx-runtime',
        react: 'preact/compat',
        'react-dom/test-utils': 'preact/test-utils',
        'react-dom': 'preact/compat',
      });
    }
    return config;
  },
};

module.exports = nextConfig;
