# How This Works

This page explains how the movie lists on this site are generated from Netflix and IMDb data.  
All scripts are included in this repository, so you can reproduce or update the lists yourself.

---

## 🎬 Pipeline Overview

1. **Pick a Netflix genre**: each list corresponds to a Netflix genre URL, e.g.,  
   `https://www.netflix.com/browse/genre/8711` for *Essential Horror Flicks*.
2. **Run the main script**:  

```bash
./rate_them_all_IMDb.sh <Netflix-genre-URL>
```
3.  **Example**:
./rate_them_all_IMDb.sh https://www.netflix.com/browse/genre/8711


This script will:
- Use `wget` to read the html code from the Netflix page and retrieve all the titles of movies it can find for that genre.
- Call `imdb-rating_omdbapi.sh` to get IMDb ratings for each movie.
- Generate a simple text file in the data/ folder with ratings, titles, year, and links to the respective IMDb and Netflix websites.


I converted those tables in a nice Markdown table with columns like this one:

| IMDb ⭐ | Title | IMDb | Netflix |
|:-------:|:------|------|---------|
| 8.8 | *title* | https://www.imdb.com/title/<imdb_title> | https://www.netflix.com/title/<netflix_title> |
| 7.5 | *title* | https://www.imdb.com/title/<imdb_title> | https://www.netflix.com/title/<netflix_title> |
| . | *.* | . | . |

## 🛠 Scripts Overview
- `rate_them_all_IMDb.sh` – main pipeline script that calls the others
- `imdb-rating_omdbapi.sh` – fetches IMDb ratings using the OMDb API
- `imdb-rating.sh` – helper for Netflix scraping and getting the list of movies of a given genre.
- `highest_rated_ones_only.sh` – generates top-rated subset


```{warning}
Keep all scripts in the same folder when running the main script, because rate_them_all_IMDb.sh expects relative paths. The lists can be in a different directory, as long as you provide the path to them.
```

```{note}
For more technical users, the raw data is always available in the data/ folder of this repository.
```

## rate_them_all_IMDb.sh
```{literalinclude} ../scripts/rate_them_all_IMDb.sh
:language: bash
:linenos:
```

### Example
```bash
$ ./rate_them_all_IMDb.sh https://www.netflix.com/browse/genre/7627

CATEGORY: https://www.netflix.com/browse/genre/7627
Generating list of movies in category  https://www.netflix.com/browse/genre/7627 ...
#List of moves in genre "Cult Movies" :  https://www.netflix.com/browse/genre/7627

"Bad Education: Directors Cut"                                          2023    https://www.netflix.com/title/81713692
"Bad Trip"                                                              2021    https://www.netflix.com/title/81287254
"Battlefield Earth"                                                     2000    https://www.netflix.com/title/60000872
"Donnie Darko"                                                          2001    https://www.netflix.com/title/60022315
"Dune"                                                                  1984    https://www.netflix.com/title/464403
"Hostel: Part III"                                                      2011    https://www.netflix.com/title/70206131
"Christine"                                                             1983    https://www.netflix.com/title/70007667
"Elaan"                                                                 1971    https://www.netflix.com/title/80158482
"Labyrinth"                                                             1986    https://www.netflix.com/title/680020
"Eternal Summer"                                                        2006    https://www.netflix.com/title/70079159
"Little Women"                                                          1994    https://www.netflix.com/title/707114
"Night of the Living Dead"                                              1968    https://www.netflix.com/title/17017662
"Mean Girls"                                                            2004    https://www.netflix.com/title/60034551
"Monty Python's The Meaning of Life"                                    1983    https://www.netflix.com/title/60029676
"Pulp Fiction"                                                          1994    https://www.netflix.com/title/880640
"Pee-wee's Big Holiday"                                                 2016    https://www.netflix.com/title/80031800
"Silsila"                                                               1981    https://www.netflix.com/title/60001659
"Snatch"                                                                2000    https://www.netflix.com/title/60003388
"Stripes"                                                               1981    https://www.netflix.com/title/1008581
"The Texas Chainsaw Massacre"                                           1974    https://www.netflix.com/title/15815343
"Trailer Park Boys: The Movie"                                          2006    https://www.netflix.com/title/70069233
"This Is the End"                                                       2013    https://www.netflix.com/title/70264796
NA      "Bad Education: Directors Cut"                                          2023                                                        https://www.netflix.com/title/81713692
6.5     "Bad Trip"                                                              2021    https://www.imdb.com/title/tt9684220/               https://www.netflix.com/title/81287254
2.5     "Battlefield Earth"                                                     2000    https://www.imdb.com/title/tt0185183/               https://www.netflix.com/title/60000872
8.0     "Donnie Darko"                                                          2001    https://www.imdb.com/title/tt0246578/               https://www.netflix.com/title/60022315
```
See the resulting nicer list in [Cult Movies list](cult).

## imdb-rating_omdbapi.sh

```{literalinclude} ../scripts/imdb-rating_omdbapi.sh
:language: bash
:linenos:
```

### Example
```bash
./imdb-rating_omdbapi.sh ../data/list_Cult_Movies.txt
```

The list above was originally generated with

```bash
 ./imdb-rating.sh --getlist https://www.netflix.com/browse/genre/7627 > ../data/list_Cult_Movies.txt
```
