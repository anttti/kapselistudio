module.exports = {
  mode: "jit",
  purge: ["./js/**/*.js", "../lib/*_web/**/*.eex", "../lib/*_web/**/*.heex", "../lib/*_web/**/*_component.ex"],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [require("@tailwindcss/typography")],
};
