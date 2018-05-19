#* @apiTitle Natural Language Generation through Markov Chains
#* @apiDescription Stuff.

# Libs
library(markovifyR)
library(tidyverse)
library(jsonlite)

#' Default GET route.
#' @get /
function() {
  list(status = "OK")
}

#' Builds a Markov model for the input sentences, then generates sentences like the input.
#' @post /generate
#' @param input_sentences A vector of sentences for the markov model to learn from.
#' @param markov_state_size The state size of the Markov model. Defaults to 2 if left empty.
#' @param max_overlap_total Max overlap total. Defaults to 25 if left empty.
#' @param max_overlap_ratio Max overlap ratio. Defaults to 0.85 if left empty.
#' @param maximum_sentence_length The max length (in characters) of sentences to be generated. Is also depends on input sentences in `strings`. Defaults to 200 if left empty.
#' @param sentences_to_generate The number of sentences to generate. These will be distinct. Defaults to 25 if left empty.
function(req,
         input_sentences,
         markov_state_size = 2L,
         max_overlap_total = 25,
         max_overlap_ratio = 0.85, 
         maximum_sentence_length = 200, 
         sentences_to_generate = 25) {
  
  print("Recieved something!")

  # Run input check.
  if (!is.character(input_sentences) || length(input_sentences) <= 1) {
    req$status = 400
    req$body = "`input_sentences` is not a character vector, or is only a single value."
    return(req)
  }
  
  print("Input validations passed.")
  
  # Coerce options user inputs to numerics.
  markov_state_size = as.numeric(markov_state_size)
  max_overlap_total = as.numeric(max_overlap_total)
  max_overlap_ratio = as.numeric(max_overlap_ratio)
  maximum_sentence_length = as.numeric(maximum_sentence_length)
  sentences_to_generate = as.numeric(sentences_to_generate)
  
  print("Coerced options to numerics.")
  
  # Build Markov model based on inputs.
  markov_model = generate_markovify_model(
    input_text = input_sentences,
    markov_state_size = markov_state_size,
    max_overlap_total = max_overlap_total,
    max_overlap_ratio = max_overlap_ratio
  )
  
  print("Generated Markov model.")
  
  # Generate new sentences from model.
  output = markovify_text(
    markov_model = markov_model,
    maximum_sentence_length = maximum_sentence_length,
    output_column_name = 'generated',
    count = sentences_to_generate,
    tries = 100,
    only_distinct = TRUE,
    return_message = FALSE
  )
  
  print("Successfully created output.")

  # Return new sentences.
  return(
    list(generated = output$generated)
  )
  
}
