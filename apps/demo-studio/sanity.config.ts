import {defineConfig} from 'sanity'
import {vyuh} from '@vyuh/sanity-plugin-structure'
import {system} from '@vyuh/sanity-schema-system'
import {tmdb} from 'tmdb-sanity-schema'
import {settings} from 'settings-sanity-schema'
import {auth} from '@vyuh/sanity-schema-auth'
import {onboarding} from '@vyuh/sanity-schema-onboarding'
import {food} from 'food-sanity-schema'
import {wonderous} from 'wonderous-sanity-schema'
import {puzzles} from 'puzzles-sanity-schema'
import {misc} from 'misc-sanity-schema'

export default defineConfig([
  {
    name: 'default',
    title: 'Vyuh Demo',
    basePath: '/',

    projectId: '8b76lu9s',
    dataset: 'production',

    plugins: [
      vyuh({
        features: [system, tmdb, settings, auth, onboarding, food, wonderous, puzzles, misc],
      }),
    ],
  },
])
