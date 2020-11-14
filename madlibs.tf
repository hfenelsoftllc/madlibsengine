terraform{
    required_version="~>0.13"
    required_providers{
        random="~>2.2"
    }
}

variable "words" {
    description="list of word pool to use for Mad Libs"
    type=object({
        nouns = list(string),
        adjectives=list(string),
        verbs=list(string),
        adverbs=list(string),
        numbers =list(number)
    })

    #validation{
     #   condition=length(var.words["nouns"]) >= 11
     #   error_message="at least eleven(11) nouns must be supplied"
    #}
}


resource "random_shuffle" "random_nouns" {
  input = var.words["nouns"] #A
}
 
resource "random_shuffle" "random_adjectives" {
  input = var.words["adjectives"]
}
 
resource "random_shuffle" "random_verbs" {
  input = var.words["verbs"]
}
 
resource "random_shuffle" "random_adverbs" {
  input = var.words["adverbs"]
}
 
resource "random_shuffle" "random_numbers" {
  input = var.words["numbers"]
}

output "mad_libs" {
  value = templatefile("${path.module}/templates/alice.txt",
    {
      nouns      = random_shuffle.random_nouns.result
      adjectives = random_shuffle.random_adjectives.result
      verbs      = random_shuffle.random_verbs.result
      adverbs    = random_shuffle.random_adverbs.result
      numbers    = random_shuffle.random_numbers.result
  })
}