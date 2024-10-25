# TMDB Feature

Shows list of movies and its details from TMDB API.

## Usage

This feature uses a environment variable to get the api key for TMDB. You can
get a key [here](https://www.themoviedb.org/documentation/api). Once you have an
API Key create a `.env` file in the root of the project and add the following:

```bash
TMDB_API_KEY=<your-api-key>
```

> Ensure the .env is added to your `.gitignore` file

During the init of this feature, the `TMDB_API_KEY` will be read from the `.env`
file.
