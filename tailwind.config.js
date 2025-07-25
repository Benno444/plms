/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        porsche: {
          red: '#D5001C',
          black: '#000000',
          gold: '#B8860B',
          silver: '#C0C0C0',
        },
      },
    },
  },
  plugins: [],
}