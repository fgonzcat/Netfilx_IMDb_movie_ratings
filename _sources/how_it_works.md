# How This Works

This page explains how the movie lists on this site are generated from Netflix and IMDb data.  
All scripts are included in this repository, so you can reproduce or update the lists yourself.

---

## 🎬 Pipeline Overview

1. **Pick a Netflix genre**: each list corresponds to a Netflix genre URL, e.g.,  
   `https://www.netflix.com/browse/genre/8711` for *Essential Horror Flicks*.
2. **Run the main script**:  

```bash
./scripts/rate_them_all_IMDb.sh <Netflix-genre-URL>
```

This script will:
- Use `wget` to read the html code from the Netflix page and retrieve all the titles of movies it can find for that genre.
- Call `imdb-rating_omdbapi.sh` to get IMDb ratings for each movie.
- Generate a text file in the data/ folder with ratings, titles, and links

This produces a nice Markdown table with columns:

| IMDb ⭐ | Title | IMDb | Netflix |
|:-------:|:------|------|---------|
| 8.8 | *title* | https://www.imdb.com/title/<imdb_title> | https://www.netflix.com/title/<netflix_title> |
| 7.5 | *title* | https://www.imdb.com/title/<imdb_title> | https://www.netflix.com/title/<netflix_title> |
| . | *.* | . | . |

## 🛠 Scripts Overview
- `rate_them_all_IMDb.sh` – main pipeline script that calls the others
- `imdb-rating_omdbapi.sh` – fetches IMDb ratings using the OMDb API
- `imdb-rating.sh` – helper for Netflix scraping
- `highest_rated_ones_only.sh` – generates top-rated subset


```{warning}
Keep all scripts in the same folder when running the main script, because rate_them_all_IMDb.sh expects relative paths. The lists can be in a different directory, as long as you provide the path to them.
```

```{note}
For more technical users, the raw data is always available in the data/ folder of this repository.
```

## rate_them_all_IMDb.sh
```bash
#######################################################################
#  Get the IMDb rating for a list of movies on Netflix                #
#######################################################################
#!/usr/bin/env bash

if [ -z $1 ] ; then
 echo "Provide the URL to a Netflix genre          [Berkeley 12-26-25]"
 echo ""
 echo "EXAMPLES"
 echo "Usage: $0  https://www.netflix.com/browse/genre/8711                          # Horror movies "
 echo ""
 echo "Get the Netflix categories with the imdb-rating.sh script:"
 echo "Usage: ./imdb-rating.sh  --getlist  https://www.netflix.com/browse/genre/8711?bc=34399      # get list of horror movies"
 echo "Usage: ./imdb-rating.sh  --categories                                                       # get URLs of Netflix categories"
 exit
fi



all_categories=$(./imdb-rating.sh --categories | head -2 | awk '{print $NF,"\n"}')
one_category="https://www.netflix.com/browse/genre/7627"  # Cult Movies

if [ "$1" != "" ]; then
 one_category="$1"
fi

echo "CATEGORY: $one_category"

for category in $one_category
do
 echo "Generating list of movies in category  $category ..."
 ./imdb-rating.sh --getlist $category > mylist.txt
 cat mylist.txt
 line=$(head -1 mylist.txt)
 genre=$(echo "$line" | sed -n 's/.*genre "\([^"]*\)".*/\1/p')
 simplified=$(echo "$genre" | sed 's/[^a-zA-Z0-9]/_/g; s/_\+/_/g')

 list="list_${simplified}.txt"
 mv mylist.txt "$list" 
 list_rated="list_${simplified}_rating_imdb.txt"

 #Use omdbapi.com to find the IMDb rating of movies on the list
 ./imdb-rating_omdbapi.sh "$list"  > "$list_rated"  &
 
 # Monitor the file as is being written
 pid=$!
 tail -f "$list_rated" &
 tailpid=$!
 wait "$pid"        # wait until imdb-rating_omdbapi.sh finishes
 kill "$tailpid"    # stop tail
 head -2 "$list"  > nn.txt
 sort -g "$list_rated" >> nn.txt
 mv nn.txt "$list_rated"
 cat "$list_rated"


done

```
