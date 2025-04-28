import { defineConfig } from 'vitepress'
export default defineConfig({
  title: "Spicetify-nix",
  description: "",
  themeConfig: {
    search: {
      provider: 'local',
    },
    nav: [
      { text: 'Home', link: '/index' },
      { text: 'Options', link: '/options' },
      { text: 'Usage', link: '/usage' },
      { text: 'Themes', link: '/themes' },
      { text: 'Extensions', link: '/extensions' },
      { text: 'Custom Apps', link: '/custom-apps' },
      { text: 'Snippets', link: '/snippets' },

    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/Gerg-L/spicetify-nix' },
    ],

    outline: {
      level: "deep",
    },
  },
  vite: {
    ssr: {
      noExternal: 'easy-nix-documentation',
    },
  },
})
