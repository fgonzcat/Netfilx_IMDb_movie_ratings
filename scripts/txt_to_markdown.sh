#!/bin/bash

if [ -z $1 ] ; then
 echo "Provide a text file with rating, \"title\", imdb_link, Netflix_link    [Berkeley 01-04-25]"
 echo ""
 echo "EXAMPLES"
 echo "Usage: $0  list_Essential_Horror_Flicks_rating_imdb.txt "
 exit
fi



input=$1
GENRE_URL=$(head -n1 "$input" | grep -o 'https://www.netflix.com/browse/genre/[0-9]\+')
GENRE_NAME=$(head -n1 "$input" | sed -n 's/.*"\(.*\)".*/\1/p')

echo "# $GENRE_NAME on Netflix"
echo ""
echo "Netflix genre: <a href=\"$GENRE_URL\" target=\"_blank\">$GENRE_URL</a>"
echo ""
echo "## 🎬 Movie list (sample)"
echo ""

sort -gr $input | awk 'BEGIN { print "| IMDb ⭐ | Title | IMDb | Netflix |"; print "|:-------:|:------|------|---------|" } !/^#/ && NF>=3 {rating=$1; title = ""; match($0, /"[^"]+"/); if (RSTART) { title = substr($0, RSTART+1, RLENGTH-2)} imdb = $(NF-1); netflix = $NF; printf "| %s | *%s* | <a href=\"%s\" target=\"_blank\">%s</a> | <a href=\"%s\" target=\"_blank\">%s</a> |\n", rating, title, imdb, imdb, netflix, netflix} '



cat <<EOF

### 🔧 How this list was generated

Each movie list on this site is produced **automatically** using the scripts in this repository. Here’s the workflow:

1. **Select a Netflix genre**  
 For example: [$GENRE_URL]($GENRE_URL)

2. **Run the main script**  
   \`\`\`bash
   ./rate_them_all_IMDb.sh $GENRE_URL
   \`\`\`

3. **What the script does**  
   - Scrapes all available movie titles from the Netflix genre page
   - Retrieves IMDb ratings using the OMDb API
   - Generates a ranked list with IMDb ratings and direct links to Netflix and IMDb

4. Optional: Get all Netflix genre URLs
   \`\`\`bash
   ./imdb-rating.sh --categories
   \`\`\`
   or browse [this directory of Netflix codes](https://www.netflix-codes.com).

### Why this matters?

You don’t have to manually check IMDb for each movie — the ranking is fully reproducible and can be updated whenever you want.

\`\`\`{tip}
💡 You can run the script for any genre URL, not just the one listed above, to generate your own custom lists.
\`\`\`
EOF
