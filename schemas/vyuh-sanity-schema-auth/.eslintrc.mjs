export default {
  root: true,
  env: { browser: true, es2020: true },
  extends: ['eslint:recommended', 'plugin:@typescript-eslint/recommended'],
  ignorePatterns: ['dist', '.eslintrc.mjs'],
  parser: '@typescript-eslint/parser',
  plugins: [],
  rules: {},
};
