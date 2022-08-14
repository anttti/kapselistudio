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
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [require("@tailwindcss/typography")],
};
