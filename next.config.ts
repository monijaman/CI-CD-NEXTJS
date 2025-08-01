import type { NextConfig } from "next";
import path from "path";

const nextConfig: NextConfig = {
  // Ensures Next.js builds a standalone output for Docker
  output: "standalone",

  // Optional: Helps with module aliasing (useful for cleaner imports)
  webpack(config) {
    config.resolve.alias["@"] = path.resolve(__dirname);
    return config;
  },

  // Optional but recommended: allows all static assets to resolve properly
  // basePath: '', // Only if you're deploying to a subdirectory
  // assetPrefix: '', // Not needed unless using CDN

  // Optional: If you serve fonts/static assets from a specific domain
  images: {
    domains: ['localhost', '18.136.120.174'],
  },
};

export default nextConfig;
