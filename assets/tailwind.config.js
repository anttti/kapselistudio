module.exports = {
  mode: "jit",
  content: [
    "./js/**/*.js",
    "../lib/*_web/**/*.eex",
    "../lib/*_web/**/*.heex",
    "../lib/*_web/**/*_component.ex",
    "../lib/*_web/**/*_live.ex",
    "../lib/*_web/**/components.ex",
    "../lib/*_web/live/*_live/*.ex",
  ],
  darkMode: "media",
  theme: {
    extend: {
      colors: {
        primary: "var(--primary)",
        "primary-dark": "var(--primary-dark)",
        "primary-start": "var(--primary-start)",
        "primary-end": "var(--primary-end)",
        secondary: "var(--secondary)",
        "secondary-start": "var(--secondary-start)",
        "secondary-end": "var(--secondary-end)",
        "body-bg": "var(--body-bg)",
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [require("@tailwindcss/typography")],
};
