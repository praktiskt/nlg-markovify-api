# nlg-markovify-api
An API built on Plumber (R) utilizing Markovify, a Python package, wrapped in markovifyR (R). It builds a Markov Chain-model based on text (user input) and generates new text based on the model.

## General

The API is hosted on a free instance on Heroku. If left unused for 30 minutes it will automatically shut down, making the initial call take a couple of extra seconds (for the container to boot up again). 

## Usage
The API is available here: https://nlg-markovify-api.herokuapp.com/

All documentation is available in the [Swagger docs](https://nlg-markovify-api.herokuapp.com/__swagger__/).

### Routes

#### GET /
Returns `status=OK` and should be used for starting the Heroku instance / checking if it's up.

#### POST /generate
The main route for generating new sentences based on input. 

Requires `input_sentences`: A character vector of sentences for the model to learn from.

Many more parameters are available and documented in the [Swagger docs](https://nlg-markovify-api.herokuapp.com/__swagger__/), including `maximum_sentence_length` and `sentences_to_generate`.

## Example (R-code)
```
# Get 40 pages of tweets (~800 tweets).
tweets = tweetDumpR::get_tweets_fast("hadleywickham", 40)$text

# Build JSON-body. Ask API to generate 2 sentences.
body = jsonlite::toJSON(
  list(
    input_sentences = tweets, 
    sentences_to_generate = 2
  )
)

# Make request, store parsed response as `content`.
content = httr::content(
  httr::POST(
    url = "https://nlg-markovify-api.herokuapp.com/generate", 
    body = body
  )
)
```
Returns
```
content

$generated
$generated[[1]]
[1] "R is your last chance to process and write about my reflections on rstudio::conf."

$generated[[2]]
[1] "I'm a free-agent data scientist, statistician, analyst, scientist, machine learner ...?"
```

## Credits

Markovify: https://github.com/jsvine/markovify

R wrapper functions for Markovify: https://github.com/abresler/markovifyR
