const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{html.erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      backgroundImage: {
        'footer-texture': "url('/img/footer-texture.png')",
      },
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      gridTemplateRows: {
        'base-layout': 'auto 1fr auto',
      },
      gridTemplateColumns: {
        'base-layout': '100%',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
