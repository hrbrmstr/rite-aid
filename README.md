# rite-aid store scraper

Rite-Aid closed 60+ stores in 2021 (https://www.cnn.com/2021/12/21/business/rite-aid-store-closures/index.html). They said they'd nuke over 1,000 of them over three years back in 2022. And, they're now about to close ~500 due to bankruptcy (https://www.silive.com/news/2023/09/rite-aid-could-close-up-to-500-stores-report-says-could-staten-islands-locations-be-shuttered.html).

FWIW Heyward Donigan, Former President and CEO — in 2023 — took home $1,043,713 in cash, $7,106,993 in equity, and $617,105 in "other" (total $8,767,811) for this fine, bankrupt leadership. Lots of other got lots too for being incompetent: https://www1.salary.com/RITE-AID-CORP-Executive-Salaries.html

## What's in the tin?

- `rite-aid-stores.r` is a small R script to do the main scraping to get all the store URLs.
- `store-parse.r` is a small R script that shows how to extract useful store info
- `ri.sh` (have no idea why i named it that) is a small bash script to politely scrape the store URL contents
- `input-urls.txt` is the store urls
- `output/*` are each of the store files

You can get an individual store status via (no auth or tokens required):

`https://www.riteaid.com/services/ext/v2/stores/getStores?count=1&radius=50&storeNumbers=4144`

This way proper data journalists can keep track of what closes when, since Rite-Aid will likely not be forthcoming with a list.
