# Load
library("tidytext")
library("tm")
library("tidyr")
library("dplyr")
library("stringr")
library("corpus")
library("ggplot2")
# Read the text file from local machine , choose file interactively
text <- read.csv("D:\\Work\\Git\\Text Analytics\\SecDefDetailed.txt",
        header = TRUE, sep = "\t")
tidy_text <- text %>% unnest_tokens(word, Description)
data(stop_words)
custom_stop_words <- bind_rows(tibble(word = c("we're", "region",
    "indo", "pacific", "friends"), lexicon = c("custom")), stop_words)
tidy_data <- tidy_text %>% anti_join(custom_stop_words)
print(tail(tidy_data %>% count(word, sort = TRUE), 10))
print(tidy_data %>%
  count(word, sort = TRUE) %>%
  filter(n > 5) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
  geom_col() +
  labs(y = NULL))
print(tidy_sentiment <- tidy_data %>%
  inner_join(get_sentiments("afinn")) %>%
  count(word, wt = value, sort = TRUE) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
  geom_col() +
  labs(y = NULL))
ggsave("tidy_sentiment.png")