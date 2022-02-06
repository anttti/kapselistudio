module.exports = {
  mode: "jit",
  content: [
    "./js/**/*.js",
    "../lib/*_web/**/*.eex",
    "../lib/*_web/**/*.heex",
    "../lib/*_web/**/*_component.ex",
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
