import { defineField } from 'sanity';

export const showLoginErrorField = () =>
  defineField({
    name: 'showLoginError',
    title: 'Show Login Error',
    description: 'Show an error message when login fails',
    type: 'boolean',
    initialValue: true,
  });
